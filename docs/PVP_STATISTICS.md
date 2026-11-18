# WarScore — Contrato técnico de estadísticas PvP

> Documento permanente para futuras implementaciones. Basado en pruebas manuales en WoW Forever 1.60.1 (Interface 16001), 2026-11-17. Consultar también `docs/GENERAL_VIEW.md` para la presentación visual y `docs/MVP_CONTEXT.md` mientras exista el MVP.
>
> **Evidencia:** «probado» = llamada ejecutada dentro del cliente; «contrastado» = valor comparado con la pestaña nativa del juego; «identificado» = ID enumerado por el cliente pero aún sin valor positivo probado. No confundir estos niveles.

## Fuente y acceso

- `GetStatistic(id)` devuelve en su primer resultado un **texto**, no necesariamente un número; puede ser `"--"`. Normalizar antes de operar y no asumir que `"--"` siempre significa cero.
- `GetPVPLifetimeStats()`: primer resultado = HK históricas; en la prueba devuelve `32`. Segundo resultado `0`: significado de rango aún por confirmar.
- `GetPVPSessionStats()`: primer resultado documentado como HK de «hoy»; prueba puntual `0`. Falta verificar persistencia entre logins y cambio de día.
- `GetPVPYesterdayStats()`: primer resultado `6` en prueba puntual.
- Todas las estadísticas históricas de la vista General deben proceder de API nativa, no de acumulaciones desde la instalación del addon.

## Contrato de métricas

| Métrica | ID / fuente | Valor de prueba | Evidencia | Uso |
| --- | --- | --- | --- | --- |
| HK históricas | `588` / `GetPVPLifetimeStats()` | 32 / 32 | Contrastado con panel nativo | Principal de General |
| HK mundo abierto | `381` | 32 | Contrastado | Desglose |
| HK campos de batalla | `382` | -- | Identificado, sin partidas | Desglose |
| Muertes sufridas por otros jugadores | `1501` | 8 | Contrastado | Denominador HK/D |
| Muertes sufridas por facción contraria | `318` | 8 | Contrastado | Desglose, **no** eliminaciones realizadas |
| Duelos ganados | `319` | -- (panel 0) | Contrastado sin duelos | General |
| Duelos perdidos | `320` | -- (panel 0) | Contrastado sin duelos | Complementaria |
| BG jugados | `839` | -- | Identificado; personaje nunca jugó BG | General |
| BG ganados | `840` | -- | Identificado; personaje nunca jugó BG | Complementaria |
| Golpes de gracia totales | `1487` | 882 | Probado, semántica PvP **no resuelta** | No calcular KB/D |
| Golpes de gracia mundo | `1488` | 702 | Probado, semántica pendiente | No calcular KB/D |
| Golpes de gracia BG | `1491` | -- | Identificado | Pendiente |
| Muertes propias totales | `60` | 38 | Probado | **No** usar como muertes PvP |
| Víctimas totales | `1197` | 3936 | Probado | **No** usar como KB PvP |
| Víctimas con experiencia u honor | `1198` | 3687 | Probado | **No** usar como KB PvP |

### Campos de batalla — desglose histórico

| Campo | Partidas | Victorias | HK | Golpes de gracia |
| --- | --- | --- | --- | --- |
| Valle de Alterac | `53` | `49` | `1113` | `1495` |
| Cuenca de Arathi | `55` | `51` | `1114` | `1496` |
| Garganta Grito de Guerra | `52` | `105` | `1115` | `1497` |
| Islas Lanza Negra | `64179` | `64176` | `64180` | `64181` |

IDs enumerados mediante `/wsdiag list 153`, `136` y `137`. Todos devuelven `--` para este personaje, que **no ha participado en campos de batalla**. Su funcionamiento con valores positivos queda pendiente.

## Reglas de cálculo

- **HK/D histórico** = `GetStatistic(588) / GetStatistic(1501)`, o HK desde `GetPVPLifetimeStats()` si está disponible y coincide. En prueba: `32 / 8 = 4.00`.
- **Porcentaje victorias BG** = `BG ganados / BG jugados * 100`, global o por BG, únicamente con ambos valores numéricos y denominador positivo.
- **Porcentaje duelos ganados** = `ganados / (ganados + perdidos) * 100`, si hay duelos y ambos contadores son fiables.
- **Denominador cero o datos desconocidos:** mostrar estado neutro `—`, nunca infinito.
- **KB/D:** bloqueado hasta aclarar por qué `1487=882` mientras HK=32; no atribuir automáticamente los 882 a golpes finales contra jugadores.
- **Normalización de `--`:** el panel nativo muestra 0 duelos ganados/perdidos para el personaje sin duelos, aunque la API devuelve `--`. Normalizar a cero **solo por contador y caso contrastado**, no universalmente.

## Vista Hoy

- **Día natural**, persistente al cerrar y reabrir WoW, no sesión de login.
- HK de hoy: primer retorno de `GetPVPSessionStats()`, pendiente de verificar tras relog y medianoche.
- Para muertes PvP y otras métricas sin API diaria, snapshots por personaje y fecha en SavedVariables. Si el primer snapshot ocurre a mitad de día, marcar «parcial desde primera observación».
- **Nunca mezclar** HK de día completo con muertes parciales para un ratio diario.
- Datos de personajes desconectados: solo últimos snapshots guardados, identificados como cacheados.

## Diagnósticos y pendientes

- `Core/Diagnostics.lua` implementa `/wsdiag`, `/wsdiag detail`, `/wsdiag categories`, `/wsdiag list <categoría>` y `/wsdiag daily`.
- Categorías relevantes: `21` PvP, `136` HK, `137` KB, `153` BG, `154` PvP mundo (duelos), `128` víctimas, `122` muertes.
- Validar valores tras el primer duelo/BG cuando sea posible, sin bloquear MVP.
- Verificar si `1487` incluye PvE, representa otro periodo o hay una discrepancia en el servidor; comparar con el panel nativo.
- Verificar el rango PvP y comportamiento diario entre sesiones y cambio de fecha.
- Verificar semántica histórica anterior a la activación de estadísticas del servidor.

## Restricciones de implementación

- Separar consultas/normalización de UI en `Core/Stats.lua`; persistencia en `Core/Storage.lua`.
- Evitar dependencias remotas y datos históricos inventados.
- El diseño de `docs/GENERAL_VIEW.md` es una **preview en iteración**; no modificarlo unilateralmente.
- Tras MVP, trasladar decisiones técnicas útiles aquí antes de eliminar `docs/MVP_CONTEXT.md`.

## Alcance aprobado de General — ampliación (2026-11-17)

Además de las métricas previamente aprobadas, **solo** incorporar: (1) BG ganados ID 840, (2) win rate BG = 840/839×100, (3) win rate duelos = 319/(319+320)×100, (4) BG favorito por máximo de partidas entre IDs 53/55/52/64179, y (5) partidas jugadas del BG favorito. Todos en bloque inferior secundario; no alterar composición principal ni tratar esta decisión como aprobación de nueva maqueta. Sin partidas/duelos, ratios y favorito no disponibles (`—`). Empates en máximo: no desempatar arbitrariamente. El resto de métricas se reservan para futuras pestañas. Fuente de verdad visual: `docs/GENERAL_VIEW.md`.


## Nueva evidencia de cliente — 2026-11-18 (v84)

Tras jugar una BG (perdida), se ha observado en la ventana General: HK históricas 92, muertes PvP 14, HK/D 6,57, BG jugados 1, BG ganados 0, favorito Garganta Grito de Guerra. El diagnóstico posterior devuelve `GetPVPLifetimeStats() = 92, 0`, `GetPVPSessionStats() = 60, 0`, `GetPVPYesterdayStats() = 0, 0`, `GetStatistic(319) = "--"`, `GetStatistic(1487) = 1021`, y `GetStatistic(1501) = 14`. Esto confirma las lecturas observadas de HK y muertes actuales, pero **no** demuestra que HK de sesión equivalga a HK del día natural ni que 1487 sea exclusivo de PvP. La partida perdida aporta un primer caso positivo para BG jugados, aunque otros IDs, victorias y distintos BG siguen requiriendo contraste.
