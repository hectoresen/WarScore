# WarScore — catálogo de datos PvP y vistas

> Catálogo funcional y técnico de los datos que WarScore puede mostrar, de los que se han comprobado en WoW Forever y de los que quedan como investigación futura.
>
> Cliente de referencia: WoW Forever 1.60.1 / Interface 16001. Última auditoría real: 2026-11-18.

## Cómo leer este documento

| Estado | Significado |
| --- | --- |
| **Confirmado** | API o estadística ejecutada en Forever y significado contrastado. |
| **Confirmado con límites** | Funciona, pero solo cubre una sesión, fecha, partida o caso concreto. |
| **Candidato** | API plausible o documentada, todavía no probada en Forever. |
| **No disponible** | Probada sin datos útiles o API ausente. |
| **Descartado** | El valor existe, pero no representa la métrica buscada. |

Regla: `--` significa desconocido hasta demostrar en la UI nativa que equivale a cero para esa estadística concreta.

## 1. Vista General — diseño actual

La vista General representa el historial PvP acumulado del personaje activo. No mezcla datos de sesión, diarios ni snapshots locales.

| Métrica | Fuente | Estado | Uso |
| --- | --- | --- | --- |
| Muertes con honor totales | `588` / `GetPVPLifetimeStats()` | **Confirmado** | Principal |
| Muertes PvP sufridas | `1501` | **Confirmado** | Principal/secundaria |
| Muertes por facción contraria | `318` | **Confirmado** | Desglose |
| HK/D | `588 / 1501` | **Confirmado** | Ratio; `—` sin denominador |
| Duelos ganados | `319` | **Confirmado con límites** | Secundaria |
| Duelos perdidos | `320` | **Confirmado con límites** | Secundaria |
| Duelos jugados | `319 + 320` | **Derivable con límites** | Ambos contadores fiables |
| BG jugados | `839` | **Confirmado** | Secundaria |
| BG ganados | `840` | **Confirmado con límites** | Contrastar `--`/cero |
| Win rate BG | `840 / 839` | **Condicionada** | Partidas fiables |
| BG favorito por partidas | `53`, `55`, `52`, `64179` | **Confirmado con límites** | Empates explícitos |
| HK en mundo | `381` | **Confirmado** | Desglose |
| HK en BG | `382` | **Confirmado** | Desglose |
| Continente dominante de HK | `1458` | **Confirmado** | Desglose |
| Honor actual | `C_CurrencyInfo.GetCurrencyListInfo()` → ID `1792` | **Confirmado** | Prueba: `252 / 25.000`; no usar `UnitHonor()` |
| Máximo de honor actual | `UnitHonorMax("player")` | **Confirmado** | Barra actual/máximo |
| Nivel de honor | `UnitHonorLevel("player")` | **Confirmado** | Etiqueta secundaria |

### Excluidos de General

- KB PvP histórico contra jugadores enemigos: no hay contador confirmado.
- `1487`, `1488`, `1491`: golpes de gracia generales bajo `137 Víctimas`; no usarlos como KB PvP.
- KB/D y rango PvP actual/progreso: no disponibles en el cliente probado.
- Honor histórico total ganado: no identificado; la fuente confirmada es el saldo de moneda `1792`.
- HK/DK de sesión o ayer: pertenecen a otras vistas.

## 2. Posible ventana «Hoy»

`GetPVPSessionStats()` acumula desde el inicio de sesión: pasó de 2 a 60 HK en una misma sesión. No llamarlo «Hoy» sin validar reinicio diario.

| Métrica | Fuente | Estado |
| --- | --- | --- |
| HK de sesión | primer retorno de `GetPVPSessionStats()` | **Confirmado con límites** |
| DK de sesión | segundo retorno | **Confirmado con límites** |
| Muertes PvP de sesión | Sin API confirmada | **No disponible** |
| KB PvP de sesión | Sin API confirmada | **No disponible** |
| Honor actual | Moneda ID `1792` mediante `C_CurrencyInfo.GetCurrencyListInfo()` | **Confirmado**, prueba `252/25.000` |
| Honor ganado hoy | `GetInspectHonorData()` | **No validado** |

Opciones honestas: llamar temporalmente a la vista «Sesión» o construir «Hoy» mediante snapshots locales y marcarla parcial desde la primera observación.

## 3. Posible ventana «Ayer»

| Métrica | Fuente | Estado | Limitación |
| --- | --- | --- | --- |
| HK de ayer | primer retorno de `GetPVPYesterdayStats()` | **Confirmado con límites** | Falta probar un día positivo |
| DK de ayer | segundo retorno | **Confirmado con límites** | Falta probar un día positivo |
| Honor de ayer | `GetInspectHonorData()` | **No validado** | Cuatro ceros en la prueba |
| Muertes PvP de ayer | Sin API | **No disponible** | Solo snapshots futuros |
| KB PvP de ayer | Sin API | **No disponible** | Solo tracking futuro |

## 4. Estadísticas avanzadas — battlegrounds

La categoría 153 expone 19 estadísticas. La primera BG real validó `839=1`, `52=1` y `395=1`.

| Battleground | Partidas | Victorias | HK | Objetivos |
| --- | --- | --- | --- | --- |
| Valle de Alterac | `53` | `49` | `1113` | Torres defendidas `393`; capturadas `394` |
| Cuenca de Arathi | `55` | `51` | `1114` | Bases invadidas `64348`; defendidas `64349` |
| Garganta Grito de Guerra | `52` | `105` | `1115` | Banderas capturadas `395`; devueltas `586` |
| Islas Lanza Negra | `64179` | `64176` | `64180` | Bases `64350`/`64351`; banderas `64352` |
| Total | `839` | `840` | `382` | — |

Los golpes de gracia de la categoría `137` no se consideran KB PvP en esta tabla.

Gráficos posibles: partidas/victorias por BG, win rate, HK por BG, BG dominante y objetivos capturados/defendidos/devueltos.

## 5. Estadísticas avanzadas — duelos

| Métrica | Fuente | Estado |
| --- | --- | --- |
| Duelos ganados | `319` | **Confirmado con límites** |
| Duelos perdidos | `320` | **Confirmado con límites** |
| Duelos jugados | `319 + 320` | **Derivable** |
| Win rate | `319 / (319 + 320)` | **Condicionada** |

En el personaje probado `319/320` devuelve `--`, pero la UI nativa muestra `0/0`. No generalizar sin más casos.

## 6. Estadísticas avanzadas — arenas

No se encontraron categorías de arenas en las 26 categorías enumeradas y no se han validado APIs de arena en Forever.

| Futuro a investigar | Posible fuente | Estado |
| --- | --- | --- |
| Arenas 2v2 jugadas/ganadas | `GetInspectArenaData(1)` | **Candidato, no probado** |
| Arenas 3v3 jugadas/ganadas | `GetInspectArenaData(2)` | **Candidato, no probado** |
| Arenas 5v5 jugadas/ganadas | `GetInspectArenaData(3)` | **Candidato, no probado** |
| Rated BG jugadas/ganadas | `GetInspectArenaData(4)` | **Candidato, no probado** |
| Rating por bracket | API de inspección/scoreboard | **Candidato, no probado** |
| Win rate, muertes y KB por arena | Derivadas/scoreboard | **No probado** |

## 7. Datos de una partida actual

`GetBattlefieldScore()` puede devolver en una BG concreta nombre, KB de la partida, HK, muertes, honor ganado, facción, daño y sanación. No reconstruye el histórico anterior.

| Uso | Estado |
| --- | --- |
| Resumen de BG actual | **Candidato; diagnóstico pendiente** |
| Guardar histórico local de BG futuras | **Candidato** |
| Reconstruir BG anteriores | **No disponible** |
| Histórico mundial completo de KB PvP | **No disponible confirmado** |

## 8. Categorías auditadas

Forever devolvió 26 categorías. Las relevantes son:

- `21` Jugador contra Jugador.
- `136` Muertes con honor.
- `137` Golpes de gracia bajo `128 Víctimas`.
- `153` Campos de batalla.
- `154` Mundo bajo PvP, actualmente duelos.
- `128` Víctimas; `122` Muertes; `124` BG bajo Muertes; `126` Mundo bajo Muertes; `135` Criaturas.

`1197` muertes realizadas, `1198` muertes que otorgan experiencia/honor y `60` muertes propias son contadores generales, no PvP enemigo.

## 9. Backlog de investigación

1. Probar `/wsdiag battlefield` durante y justo después de una BG; el diagnóstico intenta `C_PvP.GetScoreInfoByPlayerGuid()` y deja `GetBattlefieldScore()` como fallback.
2. Integrar la moneda de Honor `1792` en la UI y mostrar el máximo `25.000` cuando esté disponible.
3. Identificar la fuente de Rank Points/rango PvP; mantener «No disponible» hasta validarla.
4. Probar `GetPVPThisWeekStats()` y `GetPVPLastWeekStats()` desde el addon.
5. Investigar `GetInspectArenaData()` y APIs de arenas en Forever.
6. Validar cambio de fecha para HK/DK de ayer.
7. Contrastar `--` y cero en victorias, duelos y objetivos con la UI nativa.

## Fuente técnica

La evidencia literal y las decisiones de normalización permanecen en [PVP_STATISTICS.md](PVP_STATISTICS.md). Este catálogo organiza el producto por vistas; no sustituye las pruebas del cliente.
