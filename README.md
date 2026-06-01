# claryon-prospectos

Agente de prospección comercial de Claryon. Identifica empresas que ya tienen Microsoft 365 activo pero lo subutilizan, las califica con el score ICP y prepara el mensaje de primer contacto.

## Carril activo

**S2 · Microsoft 365** — Power Apps / Power Automate / Power BI / SharePoint / Teams como plataforma operativa.

Solo prospecta empresas con evidencia de M365 activo. Sin M365 confirmado o probable → descarte automático antes de calcular score.

## Modos de operación

- **Modo A — empresa específica**: recibe un nombre de empresa y ejecuta el flujo completo (investigar → verificar M365 → puntuar → registrar → draft).
- **Modo B — búsqueda por segmento**: recibe sector + ciudad y propone hasta 5 candidatos con M365 activo para que Memo seleccione.
- **Modo C — búsqueda por caso de uso M365**: recibe un problema u oportunidad específica (ej. "empresas con Teams sin Power Automate") y busca candidatos donde ese caso aplica.
- **Modo Envío**: despacha correos pendientes marcados "Listo para enviar" en Notion.

## Flujo principal

1. Verificar duplicados en Notion (agente principal, inline).
2. Investigar empresa + detectar M365 → subagente `busqueda-prospectos` devuelve bloque con `M365_CONFIRMADO`.
3. Verificar prerrequisito M365: si `No encontrado` → descarte inmediato.
4. Calcular score ICP (agente principal, con `skills/scoring.md`).
5. Umbral: score ≥ 50 → continuar · score < 50 → descartar.
6. Registrar en Notion → subagente `insercion-notion`.
7. Generar borrador de mensaje (agente principal, con `skills/correo-contacto.md`).
8. Actualizar Notion con el draft → subagente `insercion-notion`.

## Archivos clave

- `CLAUDE.md` — instrucciones del agente: modos, flujo, permisos.
- `skills/busqueda.md` — protocolo de investigación web; detección M365 en sección global "Detección M365 activo".
- `skills/scoring.md` — prerrequisito M365 + criterios ICP (T/D/C/F).
- `skills/insercion-notion.md` — reglas de escritura en Notion (Pasos 0–5).
- `skills/correo-contacto.md` — estructura del mensaje de primer contacto con variantes M365.
- `.claude/agents/busqueda-prospectos.md` — subagente de investigación web.
- `.claude/agents/insercion-notion.md` — subagente de escritura en Notion.
- `firma-claryon.html` — firma HTML para correos.
- `scripts/gmail-send.ps1` — fallback de envío Gmail vía REST API (cuando mcp__gmail__* no carga).

## Estructura

```
claryon-prospectos/
├── .claude/
│   ├── agents/
│   │   ├── busqueda-prospectos.md
│   │   └── insercion-notion.md
│   └── settings.json
├── scripts/
│   └── gmail-send.ps1
├── skills/
│   ├── busqueda.md
│   ├── correo-contacto.md
│   ├── insercion-notion.md
│   └── scoring.md
├── CLAUDE.md
├── firma-claryon.html
└── README.md
```

## Requisitos

- `NOTION_TOKEN` en variables de entorno.
- MCP `notionApi` configurado en `.claude/settings.json`.
- MCP `gmail` configurado para Modo Envío.
- `~/.gmail-mcp/credentials.json` y `~/.gmail-mcp/gcp-oauth.keys.json` para el fallback PowerShell.
- `../ClaryonContext.md` — contexto global del pipeline (se lee al inicio de cada sesión).
