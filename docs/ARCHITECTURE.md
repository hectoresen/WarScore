# Arquitectura de WarScore

**La fuente instalable está en `addon/WarScore/`.** El runtime no se conecta a servicios externos.

| Archivo | Responsabilidad |
| --- | --- |
| `WarScore.toc` | Manifiesto, SavedVariables `WarScoreDB`, orden de carga |
| `Core/Bootstrap.lua` | `ADDON_LOADED`, inicialización |
| `Core/Storage.lua` | Reserva de persistencia local; multipersonaje completo pendiente |
| `Core/Stats.lua` | Consulta y normalización de estadísticas, ratios, BG favorito |
| `Core/Diagnostics.lua` | Diagnósticos de APIs mediante `/wsdiag` |
| `UI/General.lua` | Frames, texturas, retrato, cifras dinámicas y comandos |
| `Media/General/` | Texturas TGA e iconografía del propietario |

El manifiesto usa rutas relativas a su propio directorio. Las texturas mantienen rutas **en el juego**, `Interface\\AddOns\\WarScore\\Media\\...`, que no cambian al reorganizar Git.

## Contratos
- Solo APIs nativas de WoW Forever con lecturas protegidas y valores desconocidos neutros.
- Métricas históricas desde el cliente, no desde contadores inventados por el addon.
- No calcular KB/D ni mostrar rango PvP hasta conocer sus fuentes reales.
- No copiar capas Domain/Infrastructure/Features de CraftAtlas sin necesidad: se adopta su **estructura de entrega**, no su complejidad funcional.

## Entrega
`tools/package_addon.py` lee `addon/WarScore/WarScore.toc`, resuelve los Lua y las texturas referenciadas, y crea `dist/WarScore.zip` con un único directorio `WarScore/`. Las transformaciones gráficas escriben bajo `addon/WarScore/Media/General/`. CI valida ZIP y listado de archivos; las capturas del cliente validan por separado el resultado visual.
