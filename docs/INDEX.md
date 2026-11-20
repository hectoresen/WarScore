# Documentación de WarScore

Guía para encontrar las referencias del addon PvP para **WoW Forever**. El [README principal](../README.md) es la portada para jugadores; aquí se mantienen los detalles técnicos, decisiones e historial de desarrollo.

- [Estado de publicación](PUBLICATION_CHECKLIST.md) — Auditoría de exposición pública, pendientes de licencia, QA y archivado OpenSpec.

## Producto y estadísticas
- [Funcionalidad actual](FUNCTIONAL.md) — Qué funciona realmente en General, Ajustes, el minimapa y los comandos.
- [Catálogo de datos y futuras vistas](PVP_DATA_CATALOG.md) — Propuestas para Estadísticas, Mundo abierto, BG, duelos y líneas de investigación; algunas referencias históricas aún usan «Hoy».
- [Contrato de estadísticas PvP](PVP_STATISTICS.md) — Fuentes nativas, pruebas realizadas, reglas de cálculo y APIs pendientes.
- [Contexto del MVP](MVP_CONTEXT.md) — Restricciones y decisiones iniciales; consultar como **histórico**.

## Diseño
- [Vista General](GENERAL_VIEW.md) — Evolución de la composición y criterios funcionales/visuales.
- [Especificación visual](GENERAL_VISUAL_SPEC.md) — Medidas, texturas y referencias aprobadas o pendientes; contrastar contra el código actual.

## Desarrollo y distribución
- [Arquitectura](ARCHITECTURE.md) — Módulos Lua, persistencia local, datos, idiomas y minimapa.
- [Desarrollo](DEVELOPMENT.md) — Construcción de assets y empaquetado.
- [Instalación](INSTALLATION.md) — Pasos para jugadores y smoke test en el cliente.
- [Handoff e iteraciones](DEVELOPMENT_HANDOFF.md) — Registro **histórico extenso** de decisiones y capturas; no sustituye la versión actual.
- [Instrucciones para agentes](../AGENTS.md) — Contrato de desarrollo, preservación de assets y aprobación.
- [Sincronización documental](../skills/documentation-sync/SKILL.md) — Auditoría de código, specs y evidencias.

## OpenSpec
- [Guía y comandos de OpenSpec](../openspec/README.md) — Flujo estricto de propuesta, implementación, verificación, sincronización y archivado.

### Cambios activos heredados — no archivados
- **General PvP:** [propuesta](../openspec/changes/feat001-general-pvp-dashboard/proposal.md) · [diseño](../openspec/changes/feat001-general-pvp-dashboard/design.md) · [spec](../openspec/changes/feat001-general-pvp-dashboard/specs/general-dashboard/spec.md) · [tareas y evidencias](../openspec/changes/feat001-general-pvp-dashboard/tasks.md). Implementado con iteraciones posteriores; pendientes de revisión y cierre formal.
- **Localización:** [propuesta](../openspec/changes/feat002-localization/proposal.md) · [diseño](../openspec/changes/feat002-localization/design.md) · [spec](../openspec/changes/feat002-localization/specs/localization/spec.md) · [tareas](../openspec/changes/feat002-localization/tasks.md). Español/inglés implementados; aceptación y archivado pendientes.

## Elegir la fuente de verdad
- **Qué hace hoy WarScore:** `addon/WarScore/` + [funcionalidad](FUNCTIONAL.md).
- **Qué significa cada dato:** [contrato PvP](PVP_STATISTICS.md).
- **Qué podría hacerse después:** [catálogo](PVP_DATA_CATALOG.md).
- **Cómo validar o archivar cambios:** [OpenSpec](../openspec/README.md) + evidencias reales del cliente.

> No confundir una propuesta o una iteración antigua con una funcionalidad terminada, y no dar por ejecutadas pruebas ni comandos no comprobados.
