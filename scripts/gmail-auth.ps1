#!/usr/bin/env pwsh
# gmail-auth.ps1 -- Genera credentials.json para claryonmx@gmail.com
# Uso: .\gmail-auth.ps1
# Requiere: ~/.gmail-mcp/gcp-oauth.keys.json (tipo Desktop app)

param(
    [string]$OAuthKeysPath = "$env:USERPROFILE\.gmail-mcp\gcp-oauth.keys.json",
    [string]$CredentialsPath = "$env:USERPROFILE\.gmail-mcp\credentials.json"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- 1. Leer llaves GCP ---
if (-not (Test-Path $OAuthKeysPath)) {
    Write-Error "No se encontro gcp-oauth.keys.json en $OAuthKeysPath"
    exit 1
}
$keys  = Get-Content $OAuthKeysPath -Raw | ConvertFrom-Json
$oauth = if ($keys.installed) { $keys.installed } else { $keys.web }

$clientId     = $oauth.client_id
$clientSecret = $oauth.client_secret
$redirectUri  = "urn:ietf:wg:oauth:2.0:oob"
$scope        = "https://mail.google.com/"

# --- 2. Abrir browser para autorizar ---
$authUrl = "https://accounts.google.com/o/oauth2/v2/auth" +
    "?client_id=$clientId" +
    "&redirect_uri=$([Uri]::EscapeDataString($redirectUri))" +
    "&response_type=code" +
    "&scope=$([Uri]::EscapeDataString($scope))" +
    "&access_type=offline" +
    "&prompt=consent"

Write-Host ""
Write-Host "Abriendo el browser para autorizar acceso a claryonmx@gmail.com..."
Write-Host ""
Start-Process $authUrl
Start-Sleep -Seconds 2

Write-Host "1. Elige la cuenta: claryonmx@gmail.com"
Write-Host "2. Acepta los permisos"
Write-Host "3. Google te mostrara un codigo en pantalla (tipo: 4/0AX...)"
Write-Host ""
$code = Read-Host "Pega aqui el codigo que aparecio en el browser"

# --- 3. Intercambiar codigo por tokens ---
Write-Host ""
Write-Host "Obteniendo tokens..."

$tokenResponse = Invoke-RestMethod `
    -Uri "https://oauth2.googleapis.com/token" `
    -Method POST `
    -Body @{
        client_id     = $clientId
        client_secret = $clientSecret
        code          = $code.Trim()
        redirect_uri  = $redirectUri
        grant_type    = "authorization_code"
    }

if (-not $tokenResponse.refresh_token) {
    Write-Error "No se recibio refresh_token. Asegurate de haber aceptado 'prompt=consent'."
    exit 1
}

# --- 4. Guardar credentials.json ---
New-Item -ItemType Directory -Force (Split-Path $CredentialsPath) | Out-Null

$credentials = [PSCustomObject]@{
    access_token  = $tokenResponse.access_token
    refresh_token = $tokenResponse.refresh_token
    expiry_date   = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds() + ($tokenResponse.expires_in * 1000)
}

$credentials | ConvertTo-Json | Set-Content $CredentialsPath -Encoding utf8

Write-Host ""
Write-Host "credentials.json guardado en: $CredentialsPath"
Write-Host "Token expira en: $($tokenResponse.expires_in) segundos (se refresca automaticamente)"
Write-Host ""
Write-Host "Listo. Ahora puedes ejecutar el Modo Envio en Claude."
