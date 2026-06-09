# ClaryonContext.md
> Fuente de verdad para todos los agentes del sistema Claryon.
> Versión: 1.0 — Mayo 2026
> Actualizar este archivo cuando cambie información de la empresa, servicios o contacto.

---

## Identidad de la empresa

**Nombre:** Claryon / Claryon S.A. de C.V.
**Sitio web:** claryon.mx
**Correo de contacto:** claryonmx@gmail.com
**Equipo:**
- Guillermo Venegas (Memo) — Co-fundador · WhatsApp: 3325060092
- Leonardo Rodríguez (Leo) — Co-fundador · WhatsApp: 3335783253

**Tipo de empresa:** Consultoría de transformación digital para MIPYMEs en México
**Región actual:** Guadalajara, Jalisco — expansión futura a todo México y EUA
**Capacidad operativa:** 2 personas, 15–20 hrs/semana disponibles
**Estado actual (Mayo 2026):** Cliente activo: Doña Chicha (entrega 9 mayo). Objetivo: cerrar nuevo cliente antes del 31 de mayo.

---

## Propuesta de valor

Claryon ayuda a MIPYMEs mexicanas a ordenar y automatizar sus procesos operativos — sin cambiar todo lo que ya tienen funcionando. Cada solución se construye a partir de un diagnóstico real, adaptada al presupuesto y tamaño del cliente.

**Diferenciador clave:** Sin paquetes fijos. Sin soluciones genéricas. El precio refleja el alcance real del proyecto.

**Metodología:** Diagnóstico → Propuesta → Implementación → Soporte / Retainer

---

## Servicios propios (Catálogo V2.0 — Mayo 2026)

**Modelo de cobro:** S1 precio fijo · S2/S3/S4 por hora a $500 MXN/hr · Todos incluyen 1 mes de garantía post-entrega.

**S1 — Diagnóstico de TI** · $3,500 MXN fijo
Análisis estructurado de procesos, herramientas, flujos e información. Incluye encuesta previa + hasta 6 hrs de sesiones con el dueño u operador clave.
Entregable: propuesta técnica y comercial con mapa de procesos, oportunidades priorizadas y estimación de inversión.
Si el cliente acepta el proyecto → los $3,500 se abonan al total. Si no acepta → Claryon conserva el pago. Siempre se cobra.

**S2 — Microsoft Environment** · $500/hr
Implementación sobre ecosistema Microsoft 365. Herramientas: Power Apps, Power Automate, Power BI, SharePoint, Dataverse, Power Pages, Copilot Studio.
Tres niveles: flujo o herramienta independiente · sistema integral por módulo (QMS, RRHH, Gestión Documental, módulo custom) · limpieza y preparación de datos.
Las licencias Microsoft corren por cuenta del cliente. Duración: 4–12 semanas.
**Prioridad: servicio principal junto con S3.**

**S3 — Agentes de IA + Automatización** · $500/hr
Agentes inteligentes con Claude como cerebro y n8n como orquestador. Interfaz vía WhatsApp, web o sistema interno.
Se puede contratar: agente individual · paquete agente + flujos + interfaz · automatización sin IA (solo flujos n8n).
Costos recurrentes del cliente: Claude API (~$500–$3,000 MXN/mes) + WhatsApp Business API si aplica.
Duración: 2–8 semanas.
**Prioridad: servicio principal junto con S2.**

**S4 — Odoo** · $500/hr *(opción alternativa)*
ERP completo cuando el diagnóstico indica que el cliente necesita un sistema integrado de fábrica. Módulos: CRM, Ventas, Inventario, Compras, Contabilidad, Manufactura, RH, Sitio web.
Activar solo cuando S2 o S3 no sean la solución más eficiente. Duración: 6–14 semanas.

**Servicios congelados — activación futura:**
- Tier Ágil (Notion + n8n): hasta primer caso piloto ejecutado
- Retainer mensual: hasta confirmar disponibilidad operativa
- Estrategia de Marca / Organizacional: subcontratados, proyecto a proyecto

---

## Cliente objetivo (ICP)

**Tipo de empresa:** MIPYME mexicana en etapa de crecimiento o con procesos manuales evidentes.
**Tamaño:** 1 a 100 personas. Prioridad: 16–50 personas (Banda 2).
**Región:** Guadalajara y Jalisco como foco principal. Cualquier ciudad de México es válida.
**Sector:** Cualquiera — la señal importa más que el sector.
**Presencia digital:** Realidad A (web básica, Google Maps, redes) o Realidad B (solo directorios, sin web propia).

**Señales de que es un buen prospecto — cualquiera de estas aplica:**
- Procesos manuales y repetitivos visibles (Excel, WhatsApp, papel, libretas)
- Información no centralizada — vive en correos, hojas o en la cabeza del dueño
- Crecimiento reciente sin digitalización — nuevas sucursales, más empleados, más volumen
- Falta de automatización en tareas que se repiten diariamente
- Sin sistema de gestión visible (sin ERP, CRM, ni portal de clientes)

**Empresas que NO aplican:**
- Empresas con ERP establecido (SAP, Oracle, Odoo completo) — ya tienen sistema
- Más de 100 personas — ciclo de venta demasiado largo para etapa actual
- Sin ninguna señal de dolor digital identificable

---

## Tier por tamaño de empresa

| Banda | Tamaño | Tier recomendado | Ticket estimado | Prioridad |
|---|---|---|---|---|
| Banda 1 | 1–15 personas | Económico (Notion, Appsheets) | Bajo | Media |
| Banda 2 | 16–50 personas | Microsoft o Económico | Medio | Alta — foco actual |
| Banda 3 | 51–100 personas | Microsoft (Power Platform) | Alto | Media |

---

## Base de datos Notion — referencias

**Tabla principal:** 🏭 Clientes
URL colección: `collection://89b807c3-ed38-82f1-9864-071fbf4bf8b5`

**Tabla de contactos:** 👤 Contactos
URL colección: `collection://fe4807c3-ed38-8389-abb7-875a76b3c0c7`

**Arquitectura:**
- El registro en Clientes es la fuente de verdad de datos (propiedades, score, estado, booleanos).
- La página de proyecto (campo `Página de proyecto`) existe solo cuando el cliente responde — la crea el Agente 2.
- `claryon-prospectos` solo escribe en la tabla Clientes y en la tabla Contactos. Nunca crea páginas en Operaciones.

---
## Tono de comunicación

- Directo y claro — sin lenguaje corporativo ni frases genéricas
- Cercano pero profesional — como hablaría un consultor de confianza, no una agencia
- Específico — siempre menciona algo concreto del cliente, nunca mensajes genéricos
- Sin presión — el objetivo del primer contacto es abrir una conversación, no vender
- En español mexicano — natural, amable, sin formalismos innecesarios
---