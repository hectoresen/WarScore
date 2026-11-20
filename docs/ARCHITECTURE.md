# Arquitectura de WarScore

WarScore es un addon **Lua nativo, local y sin dependencias remotas** para WoW Forever (Interface 16001). La única carpeta instalable está en `addon/WarScore/`.

| Archivo/directorio | Responsabilidad |
| --- | --- |
| `WarScore.toc` | Manifiesto, orden de carga y declaración de `WarScoreDB`. |
| `Core/Bootstrap.lua` | Inicialización del addon durante `ADDON_LOADED`. |
| `Core/Storage.lua` | Acceso a preferencias/SavedVariables; navegación multipersonaje pendiente. |
| `Core/Localization.lua` | Catálogos español/inglés, preferencias y notificación de cambios. |
| `Core/Stats.lua` | Acceso protegido a estadísticas nativas, normalización y ratios. |
| `Core/Diagnostics.lua` | Herramientas manuales de inspección mediante `/wsdiag`. |
| `UI/General.lua` | Interfaz General/Ajustes, textos, texturas y comandos. |
| `UI/Minimap.lua` | Botón arrastrable y persistencia de posición alrededor del minimapa. |
| `Media/` | Recursos gráficos y fuente con sus archivos de licencia. |

## Contratos

- Las cifras históricas proceden de **APIs nativas**, no de un registro de combates construido por el addon.
- La interfaz lee los valores disponibles de nuevo al abrir General. No utilizar caché de métricas que pueda ocultar cambios recientes.
- Los datos desconocidos mantienen semántica de desconocido, salvo excepciones contrastadas.
- La moneda de honor actual es distinta del rango PvP y del honor histórico ganado.
- No usar estadísticas generales de golpes de gracia como si fueran exclusivamente PvP.
- La UI preserva el diseño y los assets del propietario; cambios visuales necesitan validación específica en cliente.

## Construcción y entrega

`tools/package_addon.py` construye `dist/WarScore.zip` con una única raíz `WarScore/` y contenido instalable. CI valida estructura/paquete, pero no puede certificar el resultado en WoW Forever.

Lee también [DEVELOPMENT.md](DEVELOPMENT.md) y [PVP_STATISTICS.md](PVP_STATISTICS.md).
