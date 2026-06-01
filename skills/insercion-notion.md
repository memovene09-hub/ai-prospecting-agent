# Skill: Inserción en Notion

**Regla absoluta:** Clientes primero, Contactos después. El registro de Contactos necesita el URL del registro de Clientes para vincularse.

---

## Bases de datos

**🏭 Clientes** — Database ID: `89b807c3-ed38-82f1-9864-071fbf4bf8b5`
**👤 Contactos** — Database ID: `fe4807c3-ed38-8389-abb7-875a76b3c0c7`

---

## Paso 0 — Verificar duplicados

Buscar el nombre de la empresa en `🏭 Clientes`.

| Situación | Acción |
|---|---|
| Existe + `Correo enviado = NO` | Notificar, mostrar score y draft pendiente, esperar instrucción de Memo |
| Existe + `Correo enviado = YES` | Notificar fecha e intentos previos, no procesar, sugerir revisar seguimiento |
| Existe + `Estado = Inactivo` | Notificar motivo de descarte previo, preguntar si reabrir |
| No existe | Continuar con el flujo |

En Modo B y C: filtrar automáticamente las ya registradas antes de presentar candidatos.

---

## Paso 1 — Crear registro en 🏭 Clientes

### Campos obligatorios

| Campo | Valor | Fuente |
|---|---|---|
| `Nombre de la empresa` | Nombre oficial | `EMPRESA` del bloque |
| `Estado del Cliente` | `Prospecto` | Siempre fijo al crear |
| `Fuente` | `Agente AI` | Siempre fijo al crear |
| `Giro` | Select más cercano | `GIRO` del bloque — ver valores válidos abajo |
| `Ciudad` | Select | `CIUDAD` del bloque — ver valores válidos abajo |
| `Score ICP` | Número 0–100 | Score calculado |
| `Tamaño estimado` | Select | `TAMANIO_ESTIMADO` del bloque |
| `Tier recomendado` | Select | Siempre `Microsoft` — carril activo del agente |
| `Áreas de Oportunidad` | Multi-select | Derivado de señales de dolor y fit detectados |
| `Info limitada` | `YES` si tamaño = "No verificado" o sin contacto · `NO` si datos completos | Calculado |
| `Web / LinkedIn` | URL | `WEB` o `LINKEDIN` del bloque |
| `Teléfono empresa` | Número | `TELEFONO_EMPRESA` del bloque |
| `Canal de contacto` | Select | `Email` si hay correo · `WhatsApp` si solo teléfono |
| `Mensaje generado` | `NO` | Siempre NO al crear |
| `Correo enviado` | `NO` | Siempre NO al crear |
| `Intentos de contacto` | `0` | Siempre 0 al crear |
| `Ángulo de correo` | Select | Ver regla abajo |
| `Comentarios` | Resumen ejecutivo | Ver formato abajo |

### Valores válidos por campo

**Giro:** `Alimentos` · `Servicios` · `Comercio` · `Manufactura` · `Tecnologías` · `Construcción` · `Salud` · `Transporte y logística` · `Educación`
→ Si no encaja → usar `Servicios`, anotar el giro real en `Comentarios` y notificar a Memo al reportar.

**Ciudad:** `GDL` · `Jalisco` · `Otro MX` · `Extranjero`

**Tamaño estimado:** `1–15` · `16–50` · `51–100` · `No verificado`

**Tier recomendado:** `Microsoft` · `Económico` · `Por definir`

**Canal de contacto:** `Email` · `WhatsApp` · `Visita presencial` · `LinkedIn` · `Llamada` · `Instagram DM`

**Estado del Cliente:** `Prospecto` · `Análisis` · `Diagnóstico` · `Negociación` · `En desarrollo` · `Terminado` · `Inactivo`
→ Al crear: siempre `Prospecto`.

**Áreas de Oportunidad (multi-select):** `Centralizar información` · `Control de inventarios` · `Comunicación con clientes` · `Registro de entradas y salidas` · `Procesos manuales` · `Generador de cotizaciones` · `Recordatorios automáticos` · `Gestión de proyectos` · `Seguimiento a clientes` · `Reportes y visibilidad` · `Automatización de ventas` · `Gestion de personal / RH`

**Regla de selección de Áreas de Oportunidad:**
- Señal de subutilización M365 (herramientas externas) → `Centralizar información` + `Gestión de proyectos`
- Señal de proceso manual/cotización por WhatsApp → `Procesos manuales` + `Automatización de ventas`
- Sin SharePoint/OneDrive detectado → `Centralizar información`
- Sin Power BI/reportes → `Reportes y visibilidad`
- Señal de equipo en crecimiento sin estructura → `Gestión de proyectos` + `Seguimiento a clientes`

Máximo 4 áreas por registro. Si no hay señal directa para un área, no incluirla.

**Motivo de descarte:** `Sin M365` · `Sin contacto` · `Fuera de tamaño` · `Ya tiene sistema` · `Sin presupuesto` · `No respondió` · `Score ICP bajo` · `Otro`
→ `Sin M365` requiere agregar esa opción en Notion si no existe. El agente lo usa en Paso 1b — nunca en Paso 1 (prospectos aprobados).

**Ángulo de correo:** `M365 desperdiciado` · `Procesos manuales` · `Crecimiento sin sistema`

| Cuándo usar | Valor |
|---|---|
| `M365_CONFIRMADO = Confirmado` + señales de herramientas M365 específicas subutilizadas (Power Apps, Power Automate, Power BI) | `M365 desperdiciado` |
| Señal dominante de C2 es procesos manuales, WhatsApp como sistema, cotizaciones manuales, Excel sin automatización | `Procesos manuales` |
| Señal de crecimiento reciente sin digitalización visible (sin sistema, sin software de gestión) | `Crecimiento sin sistema` |
| Sin señal clara (Nivel C de correo) | Dejar vacío |

Ver tabla de mapeo en `skills/correo-contacto.md` — el criterio dominante es el tipo de señal que activó el nivel A/B en la observación.

### Formato del campo Comentarios

```
[Descripción del negocio en 1 línea]. [Pain point principal de subutilización M365].
S2 · Microsoft 365 — [herramientas aplicables: Power Apps / Power Automate / Power BI / SharePoint] · $[rango estimado] MXN
```

Ejemplo:
```
Distribuidora de materiales en Zapopan, ~25 empleados. Usan Teams pero aprueban pedidos por WhatsApp sin trazabilidad.
S2 · Microsoft 365 — Power Automate + SharePoint · $500/hr (~40–60 hrs estimadas)
```

### Campos que NO se llenan al crear

`Respondió` · `Motivo de descarte` · `Fecha último contacto` · `Contactos` · `Página de proyecto` · `Cotizaciones` · `Oportunidades` · `Movimientos` · `Propietario` · `Fecha de creación` · `ID` · `Listo para enviar` — Memo lo marca = YES para activar el Modo Envío; el agente nunca lo toca al crear

---

## Paso 1b — Registrar descarte en 🏭 Clientes

Ejecutar cuando el agente principal indica acción = `"registrar descarte"`.
No ejecutar Paso 2 ni Paso 3 después de este paso.

### Campos a llenar

| Campo | Valor | Fuente |
|---|---|---|
| `Nombre de la empresa` | Nombre oficial | `EMPRESA` del bloque (o nombre recibido si bloque incompleto) |
| `Estado del Cliente` | `Descartado` | Siempre fijo para descarte |
| `Motivo de descarte` | Ver tabla abajo | Según razón del descarte |
| `Fuente` | `Agente AI` | Siempre fijo |
| `Score ICP` | Score calculado | `0` si el descarte fue por prerrequisito M365 antes de calcular |
| `Giro` | Select más cercano | `GIRO` del bloque si disponible — omitir si bloque incompleto |
| `Ciudad` | Select | `CIUDAD` del bloque si disponible — omitir si bloque incompleto |
| `Tamaño estimado` | Select | `TAMANIO_ESTIMADO` si disponible — omitir si no hay datos |
| `Info limitada` | `YES` si descarte por M365 o sin contacto · `NO` en otro caso | Calculado |
| `Comentarios` | Razón del descarte en 1 línea + desglose score | Ver formato abajo |

### Motivo de descarte según razón

| Razón del descarte | Motivo a registrar |
|---|---|
| `M365_CONFIRMADO = No encontrado` | `Sin M365` |
| Score < 50 · falla dominante en C1 (tamaño fuera de banda) | `Fuera de tamaño` |
| Score < 50 · falla dominante en C3 (sin contacto identificado) | `Sin contacto` |
| Score < 50 · cualquier otra razón | `Score ICP bajo` |

### Formato del campo Comentarios para descarte

```
[Razón concreta en 1 línea]. Score [X]/100 — T:[x] D:[x] C:[x] F:[x].
```

Ejemplo — descarte M365:
```
Sin evidencia de M365 activo en ninguna fuente. Score 0 — prerrequisito no cumplido.
```

Ejemplo — descarte por score:
```
Empresa de +100 empleados, fuera de banda objetivo. Score 28/100 — T:0 D:18 C:10 F:0.
```

---

## Paso 2 — Escribir el cuerpo de la página

Estructura fija. Siempre en este orden — no omitir secciones aunque estén vacías.

```markdown
## Contexto del negocio
[Qué hace la empresa, cómo opera, zona, años de operación si se encontró]

## Señales detectadas
- [Señal — fuente: Maps / LinkedIn / web / Facebook]
[Si ninguna: "Sin señales de dolor digital identificadas"]

## Pain points principales
1. [Pain con evidencia concreta]
[Si sin evidencia: "Por confirmar en diagnóstico"]

## Por qué aplica Claryon
**Servicio:** S2 · Microsoft 365
**Herramientas aplicables:** [Power Apps / Power Automate / Power BI / SharePoint / Teams como plataforma — solo las relevantes]
**Tier:** Microsoft
[2–3 líneas explicando qué procesos subutilizados se pueden resolver sobre su M365 ya activo.]

## Desglose del score ICP
| Criterio | Puntos | Evidencia |
|---|---|---|
| Tamaño estimado | [X]/25 | [justificación] |
| Señales de dolor | [X]/30 | [señales encontradas] |
| Accesibilidad contacto | [X]/25 | [qué se encontró] |
| Fit con Claryon | [X]/20 | [servicios aplicables] |
| **Total** | **[X]/100** | |

## Cómo encontrar el contacto
**Búsquedas Google (copiar y pegar):**
- `"[Nombre empresa]" Guadalajara contacto correo`
- `"[Nombre empresa]" Guadalajara director dueño LinkedIn`
- `"[Nombre empresa]" site:linkedin.com`

**Links directos:**
- [Google Maps](https://www.google.com/maps/search/[Nombre+empresa]+Guadalajara)
- [LinkedIn búsqueda](https://www.linkedin.com/search/results/companies/?keywords=[Nombre+empresa]+Guadalajara)
- [Búsqueda web](https://www.google.com/search?q="[Nombre+empresa]"+Guadalajara+contacto)

**Correo genérico probable:** `info@[dominio].com` / `contacto@[dominio].com`
**Notas de búsqueda:** *Memo anota aquí lo que encuentre*

## Mensaje de contacto
[Se completa en el Paso 4 — después de generar el draft]

## Log de actividad
| Fecha | Acción | Resultado | Siguiente paso |
|---|---|---|---|
| [YYYY-MM-DD] | Registro inicial — claryon-prospectos | Score [X]/100 · Prospecto registrado | Enviar mensaje de contacto — cuando responda, Memo cambia Estado a `Análisis` para activar claryon-implementador |

## Mis notas
*Espacio para notas personales de Memo — el agente nunca escribe aquí*

## Mis ideas para la propuesta
*El agente nunca escribe aquí*

## Validaciones pendientes
- [ ] Verificar tamaño real
- [ ] Confirmar contacto identificado
[Agregar validaciones específicas según lo que faltó en la investigación]
```

---

## Paso 3 — Crear registro en 👤 Contactos

Solo si `CONTACTO_NOMBRE` o `CONTACTO_CORREO` están presentes en el bloque. Si ambos son "no encontrado" → omitir este paso.

| Campo | Valor | Regla |
|---|---|---|
| `Nombre` | Nombre completo | Si no hay → "Por identificar" |
| `Puesto` | Select más cercano | Ver jerarquía abajo |
| `Correo Electrónico` | Correo encontrado | Puede ser genérico |
| `Teléfono` | Teléfono personal | Diferente al de empresa |
| `Empresa` | URL del registro de Clientes recién creado | Vincula el contacto con la empresa |
| `Contacto principal` | `YES` | Siempre al crear desde el agente |
| `Comentarios` | Cómo se encontró | Ej: "Identificado en sección Nosotros del sitio web" |

**Jerarquía de puestos:**
`CEO` · `Dueño` · `Director General` · `Gerente de Operaciones` · `Gerente Comercial` · `Representante legal` · `Administrador / Contador` · `Chalán` · `Otro`

- Dueño / Propietario / Socio → `Dueño`
- CEO / Director / Presidente → `CEO` o `Director General`
- Gerente / Jefe de área → `Gerente de Operaciones` o `Gerente Comercial` según contexto
- Contador / Administrador → `Administrador / Contador`
- Operativo sin cargo claro → `Chalán`
- Desconocido → `Otro`, anotar en Comentarios

Después de crear el contacto → actualizar el campo `Contactos` en el registro de Clientes con la URL del contacto recién creado.

---

## Paso 4 — Actualizar tras generar el draft

Ejecutar después de que el agente principal genere el mensaje con `skills/correo-contacto.md`.

Actualizar en `🏭 Clientes`:
```
Mensaje generado = YES
```

Agregar fila al Log de actividad:
```
| [YYYY-MM-DD] | Draft generado | [Canal] · Score [X] | Pendiente envío — el agente procede cuando Memo marca Listo para enviar = YES |
```

Agregar al cuerpo de la página en la sección "Mensaje de contacto", reemplazando el placeholder `[Se completa en el Paso 4 — después de generar el draft]` — no dejar ambos:

```markdown
## Mensaje de contacto
**Canal:** [Email / WhatsApp]
**Fecha generado:** [YYYY-MM-DD]

---
📋 ASUNTO (solo Email):
[asunto exacto]

📋 CUERPO (negritas aplicadas, sin firma):
[cuerpo completo del mensaje]
---
```

El agente actualiza `Correo enviado = YES` únicamente en el Modo Envío, después de confirmar envío exitoso vía Gmail API — ver Paso 5.

---

## Paso 5 — Actualizar tras envío exitoso (Modo Envío)

Ejecutar por el agente principal después de cada envío confirmado por Gmail API.

Actualizar en `🏭 Clientes`:
```
Correo enviado = YES
Fecha último contacto = [YYYY-MM-DD de hoy]
Intentos de contacto = [valor anterior + 1]
```

Agregar fila al Log de actividad:
```
| [YYYY-MM-DD] | Correo enviado | Email · Score [X] | Esperar respuesta |
```

Si el envío falla después de un reintento:
```
Correo enviado = NO
Comentarios = "Error de envío — revisar"
```
Notificar a Memo y detener el flujo para ese prospecto.
