# WarScore — funcionalidad implementada

> Referencia funcional a fecha **20/11/2026**. Para el estado exacto, consultar siempre `addon/WarScore/`. Este documento describe lo implementado, no equivale a aceptación de todas las combinaciones de cliente.

## General

WarScore abre una ventana nativa desplazable y muestra el personaje activo (retrato, nombre, clase y nivel).

| Datos presentados | Origen / interpretación |
| --- | --- |
| Muertes con honor (HK) | Histórico proporcionado por las estadísticas nativas de Forever. |
| Muertes PvP sufridas | Contador histórico de muertes causadas por otros jugadores. |
| Ratio HK/D | HK totales divididas por muertes PvP sufridas; no se calcula con denominador inválido. |
| Honor | **Saldo actual** de la moneda de honor de Forever (no honor histórico ganado); cantidad y máximo cuando están disponibles. |
| Rango PvP y puntos de rango | Progresión nativa de rango de Forever; rango actual, siguiente rango y puntos hacia el siguiente. |
| Duelos | Victorias y porcentaje de victorias, cuando hay datos utilizables. |
| Campos de batalla | Partidas jugadas, victorias, porcentaje de victorias y campo favorito por partidas jugadas. |

No hay un contador fiable confirmado de **golpes de gracia exclusivamente PvP** para mostrar KB/D. La interfaz no inventa estadísticas históricas cuando la API carece de datos. Algunos valores desconocidos se presentan de manera neutra; los criterios exactos están en [PVP_STATISTICS.md](PVP_STATISTICS.md).

## Navegación y preferencias

- Acceso desde `/ws`, `/warscore` o **icono en el minimapa**.
- Icono arrastrable alrededor del minimapa, con posición guardada en las preferencias locales; clic izquierdo para mostrar/ocultar.
- **Ajustes** desde el engranaje o `/ws settings`.
- Cambio entre **español e inglés**, desde Ajustes o `/ws lang es` / `/ws lang en`, con persistencia tras `/reload`.
- Estilo visual **Classic Forever** actualmente fijo; otros estilos no están implementados.
- Pestaña **Estadísticas** visible como marcador de futura funcionalidad avanzada.

## Origen, persistencia y compatibilidad

Los datos de rendimiento se consultan en APIs nativas de **WoW Forever 1.60.1 (Interface 16001)**. Las cifras históricas proceden del cliente, no de contadores acumulados desde la instalación del addon. Al abrir la vista General, se consultan nuevamente. No necesita servidores o servicios web; `WarScoreDB` guarda preferencias locales.

Para IDs, pruebas y limitaciones: [PVP_STATISTICS.md](PVP_STATISTICS.md). Para propuestas de las futuras pestañas: [PVP_DATA_CATALOG.md](PVP_DATA_CATALOG.md).

## Comandos

| Comando | Comportamiento |
| --- | --- |
| `/ws` o `/warscore` | Abre General. |
| `/ws settings` | Abre Ajustes. |
| `/ws lang es` / `/ws lang en` | Cambia de idioma. |
| `/ws version` | Informa de la iteración visual. |
| `/wsdiag` | Inspección técnica de APIs para diagnóstico. |

## Pendiente (no implementado)

Estadísticas avanzadas por mundo abierto/BG, desglose por continente, historial propio de encuentros, navegación multipersonaje, y disponibilidad de métricas diarias sin snapshots. Estos elementos requieren investigación, spec y aprobación por separado.

La documentación de iteraciones anteriores permanece en [DEVELOPMENT_HANDOFF.md](DEVELOPMENT_HANDOFF.md) como evidencia histórica, no como fotografía del estado actual.
