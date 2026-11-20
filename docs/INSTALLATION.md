# Instalación y comprobación — WarScore

## Para jugadores

1. Descarga **[WarScore.zip](https://github.com/hectoresen/WarScore/raw/refs/heads/main/dist/WarScore.zip)**, no el ZIP automático del código fuente de GitHub.
2. Extrae el contenido en `World of Warcraft/_forever_/Interface/AddOns/`.
3. Comprueba que existe `Interface/AddOns/WarScore/WarScore.toc`. El ZIP ya incluye `WarScore/`: evita crear `WarScore/WarScore/`.
4. Activa el addon en WoW Forever y ejecuta `/reload` si ya estás dentro del juego.
5. Abre el panel con `/ws` o el botón del minimapa.

## Comprobación rápida

- General muestra el retrato, nombre, nivel y estadísticas PvP disponibles sin errores Lua.
- Compara muertes con honor, muertes PvP y honor con las pantallas nativas correspondientes de WoW Forever.
- Haz clic en el botón del minimapa, arrástralo y comprueba su posición tras `/reload`.
- Abre Ajustes y cambia entre español e inglés; comprueba que se mantiene tras recargar.
- Verifica el botón cerrar y el retorno de Ajustes a General.

Si alguna API no devuelve datos, WarScore no debe presentar cifras inventadas. La pestaña **Estadísticas** es una funcionalidad prevista, todavía no implementada.

## Para colaboradores

- Copia `addon/WarScore/` directamente desde un clon o genera el ZIP con `python3 tools/package_addon.py`.
- `/ws version` muestra la iteración visual; `/wsdiag` ofrece diagnósticos de APIs.
- Las pruebas de empaquetado o sintaxis **no sustituyen** la validación visual y de datos dentro del cliente.
- Ver [desarrollo](DEVELOPMENT.md), [contrato PvP](PVP_STATISTICS.md) y [OpenSpec](../openspec/README.md).
