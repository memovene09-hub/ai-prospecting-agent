# Skill: Búsqueda de Prospectos

Ejecutado por el subagente `busqueda-prospectos`. El agente principal nunca ejecuta este skill directamente — lo delega.

**Herramientas activas:** WebSearch + WebFetch

## Fuentes de búsqueda activas

| Fuente | Herramienta | Cuándo usarla |
|---|---|---|
| Google (búsqueda general) | `WebSearch` | Siempre primero — nombre, web, señales |
| Sitio web de la empresa | `WebFetch` | Cuando WebSearch devuelve URL |
| Google Maps (HTML público) | `WebFetch` a maps.google.com | Reseñas, teléfono, dirección |
| LinkedIn (HTML público) | `WebFetch` a linkedin.com/company/... | Tamaño, descripción — resultado limitado sin login |
| DENUE | `WebFetch` a inegi.org.mx | Empresas sin presencia digital |
| Directorios sectoriales | `WebFetch` a Caintra, Canaco, Canirac | Sectores industriales y comerciales |

Si una fuente no devuelve datos → anotar "no encontrado" y continuar con las demás.

---

## Restricción global

Este skill nunca aplica `skills/scoring.md`. El score lo calcula el agente principal.

---

## Detección M365 activo (obligatorio en todos los modos)

**Objetivo:** confirmar si la empresa ya tiene Microsoft 365 antes de continuar. Sin confirmación o indicios, el scoring descartará automáticamente.

WebSearch: `"[nombre empresa]" "Microsoft Teams" OR "Office 365" OR "SharePoint" [CIUDAD]`
WebSearch: `"[nombre empresa]" "Microsoft 365" OR "Power Apps" OR "Power Automate" [CIUDAD]`
WebSearch: `site:linkedin.com/in "[nombre empresa]" "Microsoft Teams" OR "Office 365" OR "SharePoint"`

Si la empresa tiene página de empleo o sección de careers:
WebFetch: [URL de empleo] → buscar requisitos que mencionen M365, Teams, SharePoint, Power Platform

**Registrar:**
- `M365_CONFIRMADO`: `Confirmado` si hay evidencia directa en cualquiera de las búsquedas · `Probable` si el perfil es compatible (empresa +15 empleados en servicios o manufactura sin mención de Google Workspace u otra alternativa) · `No encontrado` si no hay señal
- `M365_FUENTE`: URL o plataforma donde se encontró la evidencia (o "no detectado")
- `M365_SENAL_APROVECHAMIENTO`: señales de subutilización encontradas — procesos manuales, WhatsApp para operaciones, Excel sin BI, sin automatización visible — o "ninguna"

Si `M365_CONFIRMADO = No encontrado` → incluir en el bloque tal cual. El agente principal aplicará descarte por prerrequisito.

---

## Modo A — investigar empresa específica

### Paso 1 — Búsqueda general
WebSearch: "[nombre empresa] [CIUDAD] México"
WebSearch: "[nombre empresa] [CIUDAD] contacto correo"
Extraer: nombre oficial, dirección, teléfono, URL web, categoría, señales de dolor visibles.

### Paso 2 — Web de la empresa
Si el paso anterior devolvió URL:
WebFetch: [URL de la empresa]
Buscar: nombres de contacto, correos, teléfonos, cómo atienden clientes, si tienen sistema online, fecha de última actualización.

### Paso 3 — LinkedIn
WebSearch: "site:linkedin.com/company [nombre empresa] [CIUDAD]"
WebFetch: [URL de LinkedIn si se encuentra]
Extraer: tamaño declarado, industria, descripción, empleados con cargos directivos.

### Paso 3b — Detectar M365 activo

→ Aplicar la sección **Detección M365 activo** al inicio del archivo.

---

### Paso 4 — Reseñas y señales

WebSearch: "[nombre empresa] [CIUDAD] reseñas opiniones"
WebSearch: "[nombre empresa] [CIUDAD] site:rankeando.com OR site:mexicoo.mx OR site:yelp.com"

Para cada URL de directorio encontrada → WebFetch y extraer:
- Calificación general (estrellas)
- Texto de reseñas de clientes — especialmente quejas sobre demoras, errores, falta de seguimiento, procesos lentos
- Número total de reseñas

Si ningún directorio devuelve reseñas con texto → anotar "Sin reseñas con texto disponibles" y continuar.

### Paso 5 — Buscar contacto decisor

**5a — Nombres desde LinkedIn:**
WebSearch: `site:linkedin.com/in "[nombre empresa]" director OR gerente OR dueño OR CEO OR socio`
→ Los snippets de Google muestran nombre + cargo sin necesitar login. Anotar todos los nombres encontrados.

**5b — Cruzar nombre con correo:**
Por cada nombre encontrado en 5a:
WebSearch: `"[nombre completo]" "[nombre empresa]" correo OR email`
WebSearch: `"[nombre completo]" "[nombre empresa]" contacto`
→ A veces aparece en directorios, notas de prensa, o en la propia web de la empresa.

**5c — Correo genérico como último recurso:**
Si 5a y 5b no dieron correo personal → buscar en la web de la empresa:
WebSearch: `"[nombre empresa]" correo OR email contacto [CIUDAD]`
→ Tomar el primer correo genérico encontrado (info@, contacto@, ventas@, admin@, hola@)

**Jerarquía de contacto:**
1. Dueño o Director General con correo personal
2. Gerente de Operaciones o Administración con correo personal
3. Cualquier nombre identificado + correo genérico
4. Solo correo genérico sin nombre
5. Solo teléfono → canal = WhatsApp

Si se encuentran múltiples contactos → registrar el de mayor jerarquía. Anotar los demás en OBSERVACIONES.

---

## Modo B — búsqueda por segmento

Recibe: sector + ciudad + tamaño aproximado.
Objetivo: encontrar hasta 5 candidatos nuevos.
WebSearch: "[sector] [CIUDAD] empresa mediana"
WebSearch: "[sector] [CIUDAD] empresa"
WebSearch: "[sector] [CIUDAD] contacto OR directorio"

Para cada candidato encontrado:
WebFetch: [URL del sitio web]
WebSearch: "[nombre empresa] LinkedIn empleados"

### Detectar M365 por candidato (obligatorio)

→ Aplicar la sección **Detección M365 activo** al inicio del archivo por cada candidato.
Candidatos con `No encontrado` se incluyen en la tabla marcados con ⚠️ Sin M365.

### Búsqueda de contacto en LinkedIn (obligatoria por empresa)

Para cada candidato, intentar encontrar un contacto con nombre + cargo:
1. WebSearch: `site:linkedin.com/in "[nombre empresa]" (director OR dueño OR gerente OR CEO OR socio) [CIUDAD]`
2. WebFetch a la página de la empresa en LinkedIn si se encontró URL (resultado limitado sin login — anotar lo que se obtenga)

Jerarquía de contacto objetivo: Dueño / CEO / Director General → Gerente de Operaciones → cualquier gerente → correo genérico del sitio.

Registrar en el bloque por candidato:
- `CONTACTO_NOMBRE`: nombre completo o "no encontrado"
- `CONTACTO_CARGO`: cargo o "no encontrado"
- `CONTACTO_CORREO`: correo personal o genérico o "no encontrado"
- `CONTACTO_FUENTE`: dónde se encontró (LinkedIn / web / directorio)

Si se encuentran múltiples contactos → registrar el de mayor jerarquía. Anotar los demás en OBSERVACIONES.

Filtrar: empresas ya en `🏭 Clientes`, cadenas nacionales, empresas con +100 empleados evidentes.
Si menos de 5 candidatos nuevos → cambiar términos de búsqueda o ampliar zona. Máximo 3 intentos.

**Después de recopilar datos:**
Devolver los datos al agente principal.

**Presentar tabla a Memo:**

| # | Empresa | Zona | Tamaño | M365 | Contacto LinkedIn | Canal | Señal principal | Score |
|---|---------|------|--------|------|-------------------|-------|-----------------|-------|
| 1 | [nombre] | [zona] | [banda + ✅ confirmado / ⚠️ estimado] | ✅ / ⚠️ Probable / ❌ | [Nombre · Cargo] o "No encontrado" | Email / WhatsApp | [señal más fuerte] | [X]/100 |

Desglose por empresa:

[Nombre] — T:[x]/25 · D:[x]/30 · C:[x]/25 · F:[x]/20

---

## Modo C — búsqueda por caso de uso M365

Recibe un problema, proceso o herramienta M365 específica (ej. "empresas con Teams que no tienen Power Automate", "manufactura con M365 sin Power BI").

### Paso 1 — Deducir sectores de búsqueda

Carril activo: **S2 · Microsoft 365** — siempre.

| Tipo de señal recibida | Sectores prioritarios |
|---|---|
| Automatización de procesos / aprobaciones | Manufactura, Servicios profesionales |
| Reportes y visibilidad (Power BI) | Comercio con múltiples áreas, Distribución |
| Gestión de información / SharePoint | Servicios profesionales, Construcción |
| Comunicación y coordinación de equipos | Cualquier sector con +15 empleados y múltiples áreas |

Si la señal no encaja exactamente → notificar a Memo y usar el sector más probable.

### Paso 2 — Buscar y presentar candidatos

Misma lógica que Modo B: recopilar con WebSearch + WebFetch. Para detección M365 → ver **Detección M365 activo** al inicio del archivo.

Encabezar con: `Modo C — S2 · Microsoft 365 | Caso de uso: [descripción recibida]`

---

## Output estructurado — Modo A

Al finalizar la investigación, devolver exactamente este bloque. Sin texto antes ni después.
EMPRESA: [nombre oficial]
GIRO: [Alimentos / Servicios / Comercio / Manufactura / Tecnologías / Construcción / Salud / Transporte y Logística / Educación]
CIUDAD: [GDL / Jalisco / Otro MX / Extranjero]
DIRECCION: [dirección completa o "no encontrada"]
TELEFONO_EMPRESA: [número o "no encontrado"]
WEB: [URL o "no encontrada"]
LINKEDIN: [URL o "no encontrado"]
TAMANIO_ESTIMADO: [1–15 / 16–50 / 51–100 / No verificado]
FUENTE_TAMANIO: [cómo se estimó]
CONTACTO_NOMBRE: [nombre completo o "no encontrado"]
CONTACTO_CARGO: [cargo o "no encontrado"]
CONTACTO_CORREO: [correo o "no encontrado"]
CONTACTO_TELEFONO: [teléfono personal o "no encontrado"]
CONTACTO_FUENTE: [dónde se encontró]
SENIALES_DOLOR:

[señal — fuente: WebSearch / web / LinkedIn / Google Maps]
[Si ninguna: "Sin señales de dolor digital identificadas"]

RESENAS_RELEVANTES:

[cita o paráfrasis — fuente: Google Maps / directorios]
[Si ninguna: "Sin reseñas relevantes detectadas"]

PRESENCIA_DIGITAL: [web propia / solo Maps / solo Facebook / solo directorio / sin presencia]
SERVICIO_ORIGEN: [S2 · Microsoft 365 — siempre]
M365_CONFIRMADO: [Confirmado / Probable / No encontrado]
M365_FUENTE: [URL o plataforma donde se detectó, o "no detectado"]
M365_SENAL_APROVECHAMIENTO: [señales de subutilización detectadas o "ninguna"]
OBSERVACIONES: [datos adicionales o "ninguna"]
