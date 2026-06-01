# Skill: Scoring ICP

## Prerrequisito — M365 activo

Verificar `M365_CONFIRMADO` del bloque de búsqueda **antes de calcular cualquier criterio**.

| M365_CONFIRMADO | Acción |
|---|---|
| `Confirmado` | Continuar con scoring normal |
| `Probable` | Continuar — forzar `Info limitada = YES` — aplicar penalización en C4 |
| `No encontrado` | Descarte inmediato · Score 0 · Razón: "Sin evidencia de M365" |

---

## Regla de clasificación de señales M365

Las señales de subutilización M365 (herramientas externas que duplican funciones incluidas en la licencia: ClickUp/Planner, Airtable/Lists, Slack/Teams, Dropbox/SharePoint, etc.) van EXCLUSIVAMENTE al criterio C4 (Fit M365).
Para el criterio C2 (Dolor digital) se requiere señal de proceso manual o caótico en fuente directa (reseña, vacante, web) independiente de M365. La misma señal no puede sumar en C2 y en C4.

---

## Criterios — score total sobre 100 pts

### Criterio 1 — Tamaño (hasta 25 pts)

| Banda | Tamaño | Puntos |
|---|---|---|
| Banda 2 | 16–50 personas | 25 pts |
| Banda 1 | 1–15 personas | 20 pts |
| Banda 3 | 51–100 personas | 15 pts |
| No verificado | No se pudo estimar | 8 pts — marcar `Info limitada = YES` |
| Fuera de rango | +100 personas | 0 pts — descartar |

Usar el valor de `TAMANIO_ESTIMADO` y `FUENTE_TAMANIO` del bloque de búsqueda.

---

### Criterio 2 — Señales de dolor digital (hasta 30 pts)

Sumar puntos por cada señal encontrada. Requiere fuente verificable — no inferencias vagas.

| Señal | Puntos | Fuente esperada |
|---|---|---|
| "Cotiza por WhatsApp", "llámanos", sin sistema online | +15 pts | Web, Facebook, Instagram |
| Reseñas mencionan demoras, errores, falta de seguimiento | +15 pts | Google Maps, Facebook |
| Sin portal de clientes, sin trazabilidad, todo manual | +10 pts | Web completa |
| Empleados en LinkedIn sin mencionar ningún software | +10 pts | Perfiles LinkedIn |
| Crecimiento reciente sin digitalización visible | +10 pts | LinkedIn empresa, Maps, noticias |
| Web anticuada (+5 años) o sin actualizaciones | +5 pts | Copyright, blog, diseño |

Si no se encontró ninguna señal → 0 pts. No asumir dolor sin evidencia del bloque de búsqueda.

---

### Criterio 3 — Accesibilidad del contacto (hasta 25 pts)

Usar `CONTACTO_NOMBRE`, `CONTACTO_CORREO`, `CONTACTO_TELEFONO` del bloque de búsqueda.

| Situación | Puntos |
|---|---|
| Nombre + correo personal identificado | 25 pts |
| Nombre identificado + correo genérico | 15 pts |
| Solo correo genérico sin nombre | 10 pts |
| Solo teléfono — sin correo | 5 pts |
| Sin ningún dato de contacto | 0 pts — marcar `Info limitada = YES` |

Correos genéricos válidos: info@, contacto@, ventas@, admin@, hola@

---

### Criterio 4 — Fit Microsoft 365 (hasta 20 pts)

Evaluar potencial de implementación sobre la plataforma M365 del prospecto (Power Apps / Power Automate / Power BI / SharePoint / Teams como plataforma operativa).

| Situación | Puntos |
|---|---|
| M365 confirmado + 2+ señales claras de subutilización | 20 pts |
| M365 confirmado + 1 señal de subutilización | 12 pts |
| M365 probable (no confirmado) + señales de subutilización | 8 pts |
| M365 probable sin señales de subutilización claras | 3 pts |
| Sin evidencia de M365 | 0 pts — ya descartado por prerrequisito |

**Señales de subutilización válidas** (requieren fuente verificable):
- Procesos operativos manuales en empresa que ya usa Teams / Office 365
- Aprobaciones, cotizaciones o seguimiento vía WhatsApp o email informal
- Excel como único sistema de reportes (sin Power BI)
- Job postings o perfiles LinkedIn sin mención de Power Apps / Power Automate
- Múltiples áreas sin SharePoint compartido ni flujos automatizados visibles

---

## Cálculo y reporte

```
Score total = C1 + C2 + C3 + C4   (máximo 100)
```

Reportar siempre con desglose y evidencia:
```
Score ICP: [X]/100
  T:[pts]/25 — [justificación y fuente]
  D:[pts]/30 — [señales encontradas con fuente]
  C:[pts]/25 — [qué contacto se encontró]
  F:[pts]/20 — [servicio(s) aplicables y por qué]
```

## Umbrales

| Score | Acción |
|---|---|
| ≥ 50 | Continuar: registrar en Notion + generar draft |
| < 50 | Descarte: mostrar razón, NO registrar |

**Reglas de integridad:**
- No redondear al alza para alcanzar 50.
- Si una señal es ambigua → asignar el puntaje menor.
