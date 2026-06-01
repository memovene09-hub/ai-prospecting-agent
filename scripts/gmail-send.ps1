#!/usr/bin/env pwsh
# gmail-send.ps1 -- Envio de correo via Gmail REST API (multipart/alternative)
# Uso: .\gmail-send.ps1 -To "dest@email.com" -Subject "Asunto" -Body "Cuerpo del email"
# Fallback cuando mcp__gmail__* no esta disponible en sesion.

param(
    [Parameter(Mandatory=$true)]  [string]$To,
    [Parameter(Mandatory=$true)]  [string]$Subject,
    [Parameter(Mandatory=$true)]  [string]$Body,
    [string]$CredentialsPath = "$env:USERPROFILE\.gmail-mcp\credentials.json",
    [string]$OAuthKeysPath   = "$env:USERPROFILE\.gmail-mcp\gcp-oauth.keys.json",
    [string]$SignaturePath   = "$PSScriptRoot\..\firma-claryon.html"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- 1. Cargar credenciales ---
if (-not (Test-Path $CredentialsPath)) {
    Write-Error "No se encontro credentials.json en $CredentialsPath"
    exit 1
}
$creds = Get-Content $CredentialsPath -Raw | ConvertFrom-Json

# --- 2. Verificar / refrescar token ---
$now    = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
$margin = 120000  # refrescar si expira en <2 min

if ($creds.expiry_date -le ($now + $margin)) {
    Write-Host "Refrescando token..."

    if (-not (Test-Path $OAuthKeysPath)) {
        Write-Error "No se encontro gcp-oauth.keys.json en $OAuthKeysPath"
        exit 1
    }
    $keys  = (Get-Content $OAuthKeysPath -Raw | ConvertFrom-Json)
    $oauth = if ($keys.installed) { $keys.installed } else { $keys.web }

    $refreshParams = @{
        client_id     = $oauth.client_id
        client_secret = $oauth.client_secret
        refresh_token = $creds.refresh_token
        grant_type    = "refresh_token"
    }
    $refreshed = Invoke-RestMethod -Uri "https://oauth2.googleapis.com/token" `
        -Method POST -Body $refreshParams

    $creds.access_token = $refreshed.access_token
    $creds.expiry_date  = $now + ($refreshed.expires_in * 1000)
    $creds | ConvertTo-Json | Set-Content $CredentialsPath -Encoding utf8
    Write-Host "Token refrescado (expira en $($refreshed.expires_in)s)"
}

$token = $creds.access_token

# --- 3. Preparar partes del mensaje ---

# Parte plain: cuerpo + firma de texto
$plainBody = $Body + "`r`n`r`n-- Equipo Claryon | claryonmx@gmail.com | claryon.mx"

# Parte HTML: convertir markdown basico
$htmlBody = $Body `
    -replace '\*\*(.+?)\*\*', '<strong>$1</strong>' `
    -replace "`r`n", '<br>' `
    -replace "`n", '<br>'

# Leer firma HTML
$signatureHtml = ""
if (Test-Path $SignaturePath) {
    $rawSignature = Get-Content $SignaturePath -Raw -Encoding utf8
    if ($rawSignature -match '(?s)<body[^>]*>(.*)</body>') {
        $signatureHtml = $matches[1].Trim()
    } else {
        $signatureHtml = $rawSignature
    }
} else {
    Write-Warning "No se encontro firma-claryon.html en $SignaturePath -- enviando sin firma visual"
}

$htmlFull = '<!DOCTYPE html><html><body style="font-family: Arial, sans-serif; font-size: 14px; color: #1B2A4A; line-height: 1.6;"><p>' `
    + $htmlBody + '</p>' + $signatureHtml + '</body></html>'

# --- 4. Construir mensaje RFC 2822 multipart/alternative ---
$boundary     = "==Part_$(Get-Random)_Claryon"
$fromAddress  = "Claryon" + " " + "<claryonmx@gmail.com>"
$subjectB64   = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Subject))
$subjectEncoded = "=?utf-8?B?" + $subjectB64 + "?="
$plainB64     = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($plainBody))
$htmlB64      = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($htmlFull))

$rawMsg = "From: $fromAddress`r`n" +
          "To: $To`r`n" +
          "Subject: $subjectEncoded`r`n" +
          "MIME-Version: 1.0`r`n" +
          "Content-Type: multipart/alternative; boundary=`"$boundary`"`r`n" +
          "`r`n" +
          "--$boundary`r`n" +
          "Content-Type: text/plain; charset=utf-8`r`n" +
          "Content-Transfer-Encoding: base64`r`n" +
          "`r`n" +
          "$plainB64`r`n" +
          "`r`n" +
          "--$boundary`r`n" +
          "Content-Type: text/html; charset=utf-8`r`n" +
          "Content-Transfer-Encoding: base64`r`n" +
          "`r`n" +
          "$htmlB64`r`n" +
          "`r`n" +
          "--$boundary--"

$encodedRaw = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($rawMsg))
$encoded = $encodedRaw.Replace('+', '-').Replace('/', '_').TrimEnd('=')

# --- 5. Enviar ---
$response = Invoke-RestMethod -Uri "https://gmail.googleapis.com/gmail/v1/users/me/messages/send" `
    -Method POST `
    -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" } `
    -Body (@{ raw = $encoded } | ConvertTo-Json)

Write-Host "Correo enviado a $To | ID: $($response.id)"
return $response.id
