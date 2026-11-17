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

WarScore uses a lightweight OpenSpec workflow adapted from CraftAtlas. Start with [AGENTS.md](AGENTS.md) and [openspec/README.md](openspec/README.md). The first [General dashboard proposal](openspec/changes/feat001-general-pvp-dashboard/proposal.md) has **owner approval and an initial implementation in progress**, pending native-client tests and visual assets. The permanent [PvP statistics contract](docs/PVP_STATISTICS.md) and [visual reconstruction specification](docs/GENERAL_VISUAL_SPEC.md) define its data and appearance targets.

## Initial General view (in progress)

Install the addon under `_forever_/Interface/AddOns/WarScore/` and run `/ws` or `/warscore` to open the **unverified native UI prototype**. It reads lifetime HK, PvP deaths, HK/D, duel and BG counters and derived rates from local Forever APIs. KB/D and PvP rank are intentionally unavailable. Hoy is a nonfunctional placeholder. The ornamental reference textures are **not yet implemented**; the in-game UI has **not yet been tested**. Use `/wsdiag` for existing API diagnostics.
