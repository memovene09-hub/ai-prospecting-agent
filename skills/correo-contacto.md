# Skill: Mensaje de Primer Contacto

## Canal según contacto disponible

| Situación | Canal |
|---|---|
| Hay correo (personal o genérico) | Email |
| Solo teléfono, sin correo | WhatsApp |
| Correo + teléfono | Email — WhatsApp queda como segundo toque si no responde en 7 días |
| Sin correo ni teléfono | No generar — marcar `Info limitada = YES`, notificar a Memo |

---

## Saludo

Siempre exactamente: `Hola, equipo de [Empresa],`

Sin excepciones — nunca usar el nombre del contacto, aunque esté disponible.

---

## Mapeo Nivel de observación → Ángulo de correo (campo Notion)

| Condición | Ángulo de correo |
|-----------|-----------------|
| M365 confirmado + herramientas M365 subutilizadas | M365 desperdiciado |
| M365 confirmado + señales de proceso manual dominantes | Procesos manuales |
| M365 confirmado + empresa en crecimiento sin estructura clara | Crecimiento sin sistema |

El ángulo elegido aquí es el valor que `insercion-notion.md` usa para el campo `Ángulo de correo`.

---

## Asunto del email

Tres variantes únicamente. Elegir según la señal dominante de C2:

| Cuándo usar | Asunto |
|---|---|
| Señal dominante es M365 subutilizado — Teams o M365 activo pero procesos manuales sin Power Automate / Power Apps | `¿Están aprovechando todo lo que ya tienen en Microsoft 365?` |
| Señal dominante es procesos manuales o Excel sin automatización (M365 probable, no confirmado) | `¿Cuánto tiempo invierte [Empresa] en tareas que podrían automatizarse?` |
| Cualquier otro caso | `Una pregunta sobre las operaciones en [Empresa]` |

No generar asuntos nuevos. No agregar prefijo de marca.

---

## Regla de observación — go/no-go antes de construir el correo

Antes de redactar, clasificar la observación de C2:

- **Nivel A** — señal específica y verificable con evidencia M365:
  - "[Empresa] usa Microsoft Teams / Office 365 pero gestiona [proceso] por WhatsApp o email informal"
  - "Equipo en LinkedIn lista Teams/Office 365 pero sin Power Apps, Power Automate ni Power BI visible"
  - "Job posting pide manejo de Excel avanzado pero sin mención de Power BI ni Power Platform"
  - "Reseñas mencionan demoras o errores en seguimiento a pesar de tener infraestructura M365"
  → **usar directamente con asunto variante 1** si M365 confirmado, variante 2 si probable.

- **Nivel B** — señal real pero genérica sobre M365:
  - "Tiene M365 activo pero no hay automatizaciones visibles en LinkedIn o web"
  - "Múltiples áreas sin SharePoint ni portal interno evidente"
  → **usar con asunto variante 3** (`Una pregunta sobre las operaciones en [Empresa]`).

- **Nivel C** — sin señal concreta de subutilización M365 → **NO construir correo. NO enviar.** Marcar en Notion: `Correo enviado = NO`, `Comentarios = "Sin observación suficiente para contacto"`. Notificar a Memo y detener el flujo para este prospecto.

---

## Cuerpo del email

El cuerpo es un bloque de texto continuo. Sin saltos de línea entre oraciones. El único salto permitido es una línea en blanco antes del CTA.

```
Hola, equipo de [Empresa],

[OBSERVACIÓN EN NEGRITAS]. En Claryon ayudamos a empresas como [Empresa] a ordenar y automatizar sus procesos operativos — sin cambiar todo de golpe ni depender de sistemas caros. El resultado típico: menos tiempo en tareas manuales y más visibilidad sobre lo que pasa en el negocio.

¿Tiene 20 minutos esta semana para una llamada rápida?
```

**Restricciones:**
- Sin links en el cuerpo · Sin listar servicios · Sin precios
- La firma se agrega automáticamente al enviar — no incluirla en el draft. El agente la toma de `firma-claryon.html` (parte HTML) y agrega una línea de texto plano (`— Equipo Claryon | claryonmx@gmail.com | claryon.mx`) en la parte plain.

---

## Mensaje de WhatsApp

Mismo cuerpo, saludo y reglas de observación que el email. Diferencias:
- Sin asunto
- Emoji opcional al final del CTA en sectores informales — nunca en saludo ni cierre
- Límite de 160 palabras