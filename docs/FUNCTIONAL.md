# Funcionalidad actual — WarScore

**Corte:** 19/11/2026; versión actual de UI: **v126**. Fuentes: `addon/WarScore/Core/Stats.lua`, `UI/General.lua` y [contrato PvP](PVP_STATISTICS.md).

## Implementado
- Comandos públicos: `/ws` abre General, `/ws version` muestra la versión, `/ws lang en|es` cambia el idioma y `/ws settings` abre Ajustes. `/warscore` se conserva como alias compatible de `/ws`.
- `/wsdiag` se conserva como comando técnico separado para validar APIs y estadísticas dentro del cliente.
- La vista incluye General y Ajustes; Hoy todavía no tiene contenido funcional.
- Retrato, nombre, nivel y clase del personaje activo; ornamentos de facción, con arte de Horda y fallback para Alianza.
- Muertes con honor, **honor actual gastable** (API `UnitHonor("player")`), muertes sufridas por otros jugadores y ratio HK/D histórico cuando la API dispone de cifras.
- Duelos ganados, BG jugados, BG ganados, porcentajes de victoria calculados con denominadores válidos y campo de batalla favorito por partidas; empates explícitos.
- Dos filas de tarjetas con assets ornamentales, iconos y cifras dinámicas.
- `/ws version` (iteración de UI; independiente del campo `Version: 0.1.0` del manifiesto), `/ws lang en|es`, `/ws settings` y diagnósticos técnicos `/wsdiag`.

## No disponibles deliberadamente
- **KB/D**: retirado de la pantalla General por no existir una fuente confirmada de golpes de gracia *exclusivamente PvP*. El ID 1487 es de categoría general y no se utiliza.
- **Rango PvP**: fuente confirmada en `C_MajorFactions.GetMajorFactionProgressionInfo(2800)`; la UI muestra rango y Rank Points cuando la API responde, con «No disponible» solo como fallback.
- Valores desconocidos no se sustituyen por datos ficticios; la normalización a cero de duelos vacíos es un caso específico contrastado.

## Pendiente
- Vista Hoy con día natural y snapshots parciales correctamente etiquetados.
- Navegación real multipersonaje y separación de datos actuales frente a cacheados.
- Historial de enfrentamientos, rivales por clase/facción, rachas y sesiones.
- Validación positiva de BG/duelos y semántica de rango/KB en el cliente.

Las capturas de la v83 y anteriores confirman el trabajo visual, **no** constituyen una certificación integral de APIs o clientes.


## Cambio de distribución — UI v89 (2026-11-18)

La sección central muestra **HONOR** (actual, no histórico, obtenido con `UnitHonor("player")`) en dorado; la columna derecha del marco de ratios, donde antes aparecía KB/D, muestra **MUERTES PvP SUFRIDAS** en rojo con el valor de `GetStatistic(1501)`. La fórmula HK/D se conserva y todas las demás tarjetas permanecen intactas. Validación visual en cliente pendiente.


## Corrección del saldo de honor — UI v93 (2026-11-18)

General muestra `HONOR` como `cantidad / máximo`, leyendo la moneda **1792** mediante la lista `C_CurrencyInfo.GetCurrencyListInfo(index)` y comprobación de ID. Ejemplo probado por diagnósticos: `252 / 25.000`. Ya no usa `UnitHonor`, porque devolvía 0 en el mismo personaje. Cuando no está disponible muestra `—`. Se conserva el carácter de saldo actual, no histórico. También se restaura el botón de cierre v90 y se recoloca el único engranaje justo debajo de la X.
