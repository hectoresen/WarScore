# Índice de documentación de WarScore

Punto de entrada a la documentación del addon PvP para **WoW Forever**. Cada enlace incluye una breve descripción. Para conocer el estado real de una función, contrasta la documentación con `addon/WarScore/` y las pruebas en el cliente: algunas especificaciones y notas conservan versiones anteriores de la interfaz.

## Introducción y producto

- [README principal](../README.md) — Qué es WarScore, cómo instalarlo y comandos principales.
- [Funcionalidad actual](FUNCTIONAL.md) — Inventario de funciones implementadas y limitaciones; **revisar contra el código vigente** porque incluye referencias antiguas.
- [Catálogo de datos y vistas PvP](PVP_DATA_CATALOG.md) — Estadísticas disponibles, propuestas de «Hoy», «Ayer» y «Estadísticas → Mundo abierto», más líneas de investigación.
- [Contrato técnico de estadísticas PvP](PVP_STATISTICS.md) — APIs, IDs, resultados reales, reglas de cálculo y verificaciones pendientes (datos diarios y HK por continente).
- [Contexto del MVP](MVP_CONTEXT.md) — Decisiones y restricciones temporales del producto; conservar hasta su consolidación en documentos permanentes.

## Interfaz y diseño

- [Vista General](GENERAL_VIEW.md) — Composición, decisiones de diseño y contexto de iteraciones de la pantalla General.
- [Especificación visual de General](GENERAL_VISUAL_SPEC.md) — Referencias estéticas, medidas, componentes, texturas y criterios de fidelidad; es una **especificación de referencia**, no una captura del estado actual.

## Arquitectura, desarrollo y entrega

- [Arquitectura](ARCHITECTURE.md) — Distribución del código Lua, responsabilidades por módulo y contratos técnicos.
- [Desarrollo y empaquetado](DEVELOPMENT.md) — Flujo de trabajo, generación de assets, construcción y validación del ZIP instalable.
- [Instalación y verificación](INSTALLATION.md) — Instalación en WoW Forever, comandos de diagnóstico y pruebas manuales.
- [Handoff de desarrollo](DEVELOPMENT_HANDOFF.md) — Contexto para retomar iteraciones, acuerdos de QA y registro de continuidad; **puede contener referencias históricas**.
- [Contrato de agentes](../AGENTS.md) — Instrucciones de trabajo y límites para agentes que modifican el proyecto.
- [Skill de sincronización documental](../skills/documentation-sync/SKILL.md) — Comprobaciones para mantener especificaciones, código, pruebas y documentación coherentes.

## OpenSpec: propuestas, decisiones y tareas

- [Guía OpenSpec](../openspec/README.md) — Proceso para proponer, aprobar, implementar y verificar cambios.

### feat001 — Panel PvP General

- [Propuesta](../openspec/changes/feat001-general-pvp-dashboard/proposal.md) — Motivación y alcance del panel PvP.
- [Diseño](../openspec/changes/feat001-general-pvp-dashboard/design.md) — Decisiones de implementación y estructura propuesta.
- [Especificación](../openspec/changes/feat001-general-pvp-dashboard/specs/general-dashboard/spec.md) — Requisitos verificables del panel.
- [Tareas](../openspec/changes/feat001-general-pvp-dashboard/tasks.md) — Seguimiento de implementación y comprobaciones.

### feat002 — Localización

- [Propuesta](../openspec/changes/feat002-localization/proposal.md) — Objetivos y alcance del soporte multilingüe.
- [Diseño](../openspec/changes/feat002-localization/design.md) — Decisiones técnicas de localización.
- [Especificación](../openspec/changes/feat002-localization/specs/localization/spec.md) — Comportamientos y requisitos de idioma.
- [Tareas](../openspec/changes/feat002-localization/tasks.md) — Actividades y validaciones pendientes o realizadas.

## Cómo elegir la fuente correcta

- **Estado real del addon:** código actual en `addon/WarScore/` y evidencia de pruebas dentro de Forever.
- **Significado y fiabilidad de los datos PvP:** `PVP_STATISTICS.md`.
- **Qué mostrar ahora o en futuras pestañas:** `FUNCTIONAL.md` y `PVP_DATA_CATALOG.md`, contrastados con el código.
- **Diseño visual:** `GENERAL_VIEW.md` y `GENERAL_VISUAL_SPEC.md`.
- **Cambios en curso o aprobados:** `openspec/changes/` y su evidencia de aceptación.

> Este índice organiza documentos existentes; no declara implementadas funcionalidades futuras ni convierte APIs candidatas en APIs validadas.
