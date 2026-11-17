# WarScore

Addon de estadísticas PvP para World of Warcraft Forever.

WarScore pretende mostrar el historial PvP completo de cada personaje, con una vista general centrada en las muertes con honor, dos ratios de combate y las muertes sufridas.

> Proyecto en fase de investigación y construcción del MVP. Las APIs específicas de Forever requieren validación en el cliente.

## Desarrollo

Consulta [docs/MVP_CONTEXT.md](docs/MVP_CONTEXT.md) antes de modificar el proyecto. Es el documento temporal de decisiones, hipótesis, análisis y roadmap; se eliminará al cerrar el MVP.

## Estructura

- `WarScore.toc`: manifiesto del addon (versión de interfaz pendiente de confirmar).
- `Core/`: inicialización, lectura de datos y persistencia local.
- `UI/`: interfaz de usuario.
- `docs/MVP_CONTEXT.md`: contexto temporal para agentes.

No hay servicios externos, CI ni reglas de contribución por ahora.

## Spec-driven development

WarScore uses a lightweight OpenSpec workflow adapted from CraftAtlas. Start with [AGENTS.md](AGENTS.md) and [openspec/README.md](openspec/README.md). The first [General dashboard proposal](openspec/changes/feat001-general-pvp-dashboard/proposal.md) is a **draft awaiting owner approval**; no UI implementation has been authorized or started by this proposal. The permanent [PvP statistics contract](docs/PVP_STATISTICS.md) and [visual reconstruction specification](docs/GENERAL_VISUAL_SPEC.md) define its data and appearance targets.
