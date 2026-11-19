# WarScore — Contrato técnico de estadísticas PvP

> Documento permanente para futuras implementaciones. Basado en pruebas manuales en WoW Forever 1.60.1 (Interface 16001), 2026-11-17. Consultar también `docs/GENERAL_VIEW.md` para la presentación visual y `docs/MVP_CONTEXT.md` mientras exista el MVP.
>
> **Evidencia:** «probado» = llamada ejecutada dentro del cliente; «contrastado» = valor comparado con la pestaña nativa del juego; «identificado» = ID enumerado por el cliente pero aún sin valor positivo probado. No confundir estos niveles.

## Fuente y acceso

- `GetStatistic(id)` devuelve en su primer resultado un **texto**, no necesariamente un número; puede ser `"--"`. Normalizar antes de operar y no asumir que `"--"` siempre significa cero.
- `GetPVPLifetimeStats()`: primer resultado = HK históricas; el segundo retorno devuelve `0` (`RankNone`) en el personaje probado. `UnitPVPRank()` y `GetPVPRankProgress()` no existen en Forever.
- `GetPVPSessionStats()`: devuelve HK y DK de la sesión; prueba actual `2 | 0`. No llamarlo «Hoy» hasta validar relog y cambio de fecha.
- `GetPVPYesterdayStats()`: devuelve HK y DK del día anterior; prueba actual `0 | 0`.
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
| Golpes de gracia generales | `1487` | 1021 | **Probado; categoría 137 cuelga de Víctimas** | No usar como KB PvP |
| Golpes de gracia del mundo | `1488` | 828 | **Probado; semántica PvP no demostrada** | No usar como KB PvP |
| Continente con más golpes de gracia | `1489` | 458 (Kalimdor) | **Probado; categoría general** | No usar como desglose PvP |
| Golpes de gracia BG | `1491` | -- | Identificado; categoría general | No usar como KB PvP |
| BG con más golpes de gracia | `1716` | -- | Identificado; categoría general | No usar como desglose PvP |
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
- **KB/D PvP:** no hay un contador histórico confirmado para golpes de gracia contra jugadores de la facción rival. `1487/1488/1491` pertenecen a categoría 137, cuyo padre es `Víctimas` (128), y sus magnitudes no son coherentes con HK; no usarlos para KB/D.
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
## Evidencia nueva — auditoría de categorías PvP en Forever (2026-11-18)

El usuario ejecutó `/wsdiag` y las categorías 21, 136, 137, 153 y 154 en WoW Forever 1.60.1. Esta sección conserva los resultados observados y sirve como inventario para futuras gráficas; no implica que todas las métricas deban entrar en la vista General actual.

### Retornos PvP directos

```text
GetPVPLifetimeStats: 34 | 0 | nil | nil
GetPVPSessionStats: 2 | 0 | nil | nil
GetPVPYesterdayStats: 0 | 0 | nil | nil
```

- HK históricas: `34`.
- Segundo retorno de lifetime: `0`, compatible con `RankNone` para este personaje; `UnitPVPRank` y `GetPVPRankProgress` son nil.
- Sesión actual: `2` HK y `0` DK.
- Ayer: `0` HK y `0` DK.

### Categorías observadas

- PvP general: `1501=10` muertes por otros jugadores; `318=10` muertes por la facción contraria.
- HK: `588=34` total; `381=34` mundo; `1458=27 (Kalimdor)` continente dominante.
- Golpes de gracia: `1487=1021` total; `1488=828` mundo; `1489=458 (Kalimdor)` continente dominante.
- Battlegrounds: 19 contadores para partidas/victorias globales, partidas/victorias por BG y objetivos de Alterac, Warsong, Arathi e Islas Lanza Negra; todos `--` por ausencia de historial BG.
- Duelos: `319` ganados y `320` perdidos; ambos `--`, contrastados como `0/0` en la UI nativa.

La categoría 137 solo confirma que son estadísticas generales llamadas «Golpes de gracia»; no confirma que sean golpes de gracia contra jugadores. La jerarquía observada (`137` bajo `128 Víctimas`) y la discrepancia con HK impiden usarlas como KB PvP.

### Posibles gráficos futuros

- HK/KB de mundo frente a battlegrounds.
- Continente dominante de HK y golpes de gracia.
- KB/D junto a HK/D, solo si se obtiene una fuente específica de golpes contra jugadores enemigos.
- Victorias/partidas y porcentaje por battleground.
- Objetivos capturados, defendidos y devueltos por BG.
- Actividad de sesión y día anterior.
- Evolución local diaria/semanal mediante SavedVariables, si se aprueba ese alcance.

## Evidencia nueva — primera actividad BG observada (2026-11-18)

Tras actividad real en battleground, el usuario volvió a ejecutar las categorías 128, 122, 136 y 137.

### Resultado confirmado

- Muertes con honor totales `588`: **92**.
- HK en mundo `381`: **34**.
- HK en battlegrounds `382`: **58**.
- BG con más HK `1719`: **58 en Garganta Grito de Guerra**.
- HK por BG: Warsong `1115=58`; Alterac `1113=--`; Arathi `1114=--`; Islas Lanza Negra `64180=--`.

La suma `34 HK mundo + 58 HK BG = 92 HK totales` es coherente y confirma que el desglose mundo/BG funciona en Forever. También queda validado que `1719` puede alimentar un indicador de battleground dominante.

### Estadísticas generales adicionales

- `1197` Muertes realizadas: **4517**.
- `1198` Muertes que otorgaron experiencia u honor: **4174**.
- `60` Muertes propias: **46**.

Estos tres contadores pertenecen a categorías generales y no deben presentarse automáticamente como KB PvP, HK ni muertes PvP. Las muertes propias `60` tampoco sustituyen a `1501`, que sigue siendo el contador específico de muertes causadas por otros jugadores.

### Inconsistencia pendiente

La categoría 137 continúa devolviendo `1487=1021`, `1488=828` y `1491=--`, a pesar de que ya existen `58` HK de battleground. Al estar bajo `Víctimas`, estos contadores deben tratarse como generales y no como golpes de gracia PvP.

## Evidencia nueva — primera partida BG registrada (2026-11-18)

Tras completar una partida, la categoría 153 devolvió:

- `839` BG jugados: **1**.
- `52` partidas de Garganta Grito de Guerra: **1**.
- `395` banderas capturadas en Garganta Grito de Guerra: **1**.
- `840` BG ganados: `--`.
- `105` victorias en Garganta Grito de Guerra: `--`.
- `586` banderas devueltas: `--`.
- El resto de BG y objetivos: `--`.

Esto confirma que el addon puede detectar historial positivo de partidas y objetivos de Warsong. La combinación `1 partida / -- victorias` probablemente representa una derrota o una victoria aún no registrada, pero debe compararse con el panel nativo antes de normalizar `--` a cero. No generalizar la conversión de `840` o `105` sin esa comparación.

La categoría 137 continúa sin cambios (`1487=1021`, `1488=828`, `1491=--`); una partida BG con HK y una bandera capturada no permite interpretar esos contadores como KB PvP.

## Evidencia nueva — actividad PvP de sesión tras BG (2026-11-18)

Nueva salida de `/wsdiag`:

```text
GetPVPLifetimeStats: 92 | 0 | nil | nil
GetPVPSessionStats: 60 | 0 | nil | nil
GetPVPYesterdayStats: 0 | 0 | nil | nil
GetStatistic(1487): 1021 | false | 1487 | nil
GetStatistic(1501): 14 | false | 1501 | nil
```

- Las HK históricas `92` coinciden con la suma documentada de mundo `34` + BG `58`.
- Las HK de sesión subieron de `2` a `60` durante la misma sesión, confirmando que `GetPVPSessionStats()` representa actividad de sesión y no debe etiquetarse como «Hoy» sin validar el reinicio diario.
- Las HK de ayer siguen en `0`.
- Las muertes PvP específicas `1501` ahora son `14`.
- `1487` continúa en `1021`; no cambia con esta evidencia y KB/D sigue pendiente.

## Evidencia nueva — honor actual expuesto por Forever (2026-11-18)

La prueba ejecutada con `/wsdiag honor` devolvió:

```text
UnitHonor(player): 0 | nil | nil | nil
UnitHonorMax(player): 5500 | nil | nil | nil
UnitHonorLevel(player): 1 | nil | nil | nil
GetInspectHonorData: 0 | 0 | 0 | 0
APIs de solicitud de honor no disponibles
```

### Conclusión

- `UnitHonor("player")` funciona en Forever y devuelve el **honor actual acumulado/gastable**: `0` en el personaje probado.
- `UnitHonorMax("player")` funciona y devuelve el máximo del rango/nivel actual: `5500`.
- `UnitHonorLevel("player")` funciona y devuelve el nivel de honor: `1`.
- Puede calcularse progreso de honor como `UnitHonor / UnitHonorMax`, siempre que el máximo sea positivo.
- No es un total histórico de honor ganado: el honor actual puede gastarse y volver a cero.
- `GetInspectHonorData()` devuelve cuatro ceros en esta prueba y las APIs `NotifyInspect`/`RequestInspectHonorData` no están disponibles; no usarlo para honor de hoy/ayer hasta una futura validación específica.

La etiqueta recomendada para UI es **Honor actual**, no «Honor total». La primera gráfica segura sería `Honor actual / máximo del nivel`, acompañada de `Nivel de honor`.

## Evidencia nueva — moneda de Honor de Forever (2026-11-18)

El usuario ejecutó `/wsdiag currencies` en WoW Forever 1.60.1 y obtuvo:

```text
WarScore Monedas PvP del personaje
WarScore Entradas de monedas: 2
WarScore 2. Puntos de honor | cantidad 252 | max 25000 | ID 1792
```

La fuente correcta para el saldo de Honor de Forever es la moneda `Puntos de honor`, ID `1792`, leída mediante `C_CurrencyInfo.GetCurrencyListInfo()`. `UnitHonor("player")` devolvía `0` en el mismo personaje y no debe utilizarse para representar el saldo mostrado en la UI. El rango PvP y los Rank Points siguen pendientes de localizar; `UnitHonorLevel("player")` no se interpreta como rango PvP.

## Plan de comprobación — rango PvP y Rank Points

`/wsdiag rank` prueba `GetPVPLifetimeStats()`, las funciones clásicas de rango (`UnitPVPRank`, `GetPVPRankInfo`, `GetPVPRankProgress`) y candidatos de `C_PvP`. Debe compararse con `/wsdiag currencies` para detectar una posible moneda llamada Rank Points. `UnitHonorLevel("player")` se conserva como dato separado y no se interpreta como rango PvP.

Nueva pista pendiente de validación en cliente: el código de interfaz de Forever puede modelar el rango como la major faction `2800` (PvP Rank Points), con progreso consultable mediante `C_MajorFactions.GetMajorFactionProgressionInfo(2800)`. El diagnóstico también prueba `C_Reputation.GetFactionDataByID(2800)` y las monedas relacionadas `3468`/`3473`; esta pista no se considera confirmada hasta obtener una salida real del personaje.

Primera salida real de `/wsdiag rank`: `renownLevel=0`, `renownReputationEarned=25`; `C_CurrencyInfo(3468)` aparece como «Puntos de rango» con cantidad `0`, y `C_CurrencyInfo(3473)` como «Renombre - Rango de JcJ» con cantidad `0` y máximo `7`. El código de la pestaña PvP de Forever confirma que `renownLevel` es el rango y que `renownReputationEarned` es el valor de Rank Points mostrado en la interfaz; `renownLevelThreshold` es el objetivo del siguiente rango. El nivel `0` se presenta como sin rango; el rango 1 empieza en el título `PVP_RANK_5_<facción>` (Explorador/Scout en Horda). `PVP_RANK_0_<facción>` pertenece al enum legacy y no debe usarse como rango 1.


## Decisión funcional de producto — v89 (2026-11-18)

El propietario confirma que no se puede recuperar una fuente fiable de golpes de gracia **contra jugadores** en Forever; la tarjeta KB/D se retira de la vista General. En su lugar se muestra el total de **muertes PvP sufridas** desde `GetStatistic(1501)`, en rojo. La sección secundaria central pasa a **HONOR** y debe consultar la moneda `1792` para mostrar el saldo actual gastable, `—` si la API no responde. Esta métrica **no** representa el honor total ganado a lo largo de la vida del personaje. HK/D se mantiene sin cambios. La retirada del indicador visual no implica eliminar evidencia histórica ni afirmar que los contadores generales de KB sean PvP.


## Fuente de Honor vigente en General — v93 (2026-11-18)

La implementación de General consulta **exclusivamente la moneda 1792**, identificada en `/wsdiag currencies` como `Puntos de honor`. La API `C_CurrencyInfo.GetCurrencyListInfo(index)` recibe **índice de lista**, no ID de moneda; localizar la fila mediante `GetCurrencyListSize()` y `info.currencyTypesID` o `info.currencyID` igual a `1792`. Lecturas observadas: cantidad 252, máximo 25000. Mostrar `252 / 25.000`, con `—` si falta la moneda o el máximo. Este saldo es gastable, no honor histórico. `UnitHonor()`, `UnitHonorMax()` y `GetInspectHonorData()` quedan explícitamente descartadas como fuentes del saldo principal.
