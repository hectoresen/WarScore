# WarScore — Contexto temporal hasta el MVP

> **OBLIGATORIO PARA AGENTES:** leer este documento antes de proponer o implementar cambios. Es la fuente temporal de contexto y decisiones. Actualizarlo cuando se cierre una decisión o se descubra evidencia técnica. **Eliminarlo al completar el MVP**, trasladando antes a documentación estable solo lo que siga siendo útil.
>
> Estado: planificación / scaffold. Compatibilidad base documentada el 2026-11-16. No confundir una API documentada con una API probada en WoW Forever.

## 1. Propósito y restricciones

WarScore es un addon nativo de **World of Warcraft Forever** para consultar estadísticas PvP de personajes propios, especialmente su historial acumulado. Debe ejecutarse íntegramente dentro del cliente, sin servidores, servicios web, APIs remotas ni bases de datos externas. Lua y la API real del cliente son la base técnica; **Compatibilidad base documentada:** Forever 1.60.1, interfaz `16001`, familia de APIs Mainline moderna (no Classic Era). La compatibilidad de cada llamada concreta sigue pendiente.

El usuario quiere soporte **multipersonaje**: por defecto se muestra el personaje conectado, pero debe poder navegarse por otros personajes conocidos del addon. No atribuir a personajes desconectados información que el cliente no permita consultar; distinguir datos cacheados y actuales.

**Requisito no negociable:** las métricas principales deben abarcar **todo el historial del personaje desde su creación**, incluso si el addon se instala hoy. No sustituirlas silenciosamente por contadores locales desde la instalación. Si la API no expone un dato histórico, declararlo pendiente/no disponible en vez de inventarlo.

## 2. Vista General — decisiones de producto

Diseño de arriba a abajo, centrado y limpio:
1. Retrato **real del personaje activo**, circular, centrado en la parte superior (no avatar genérico, ni cuadrado, ni a un lado). Investigar `SetPortraitTexture` y el recorte/máscara circular disponible en la versión del cliente.
2. **Muertes con honor (HK)**: cifra protagonista y más grande. HK incluye participaciones en eliminaciones, no solo golpes finales.
3. **Ratio global HK/D**: destacado, pero menor que HK. `HK / muertes PvP sufridas`.
4. **Ratio golpes de gracia KB/D**: justo debajo, en menor tamaño. `golpes de gracia / muertes PvP sufridas`.
5. **Muertes sufridas en PvP**: más abajo, como estadística secundaria.

Se habló coloquialmente de dos «KDA», pero técnicamente deben etiquetarse **HK/D** y **KB/D**: no se dispone de asistencias desglosadas para calcular un KDA convencional. Definir presentación de división por cero (`—` o equivalente), no infinito.

La pestaña General **agrega todo el PvP**: mundo abierto, campos de batalla y cualquier modalidad. No fragmentar ni filtrar por modalidad en esta pantalla.

Datos ficticios solo para prototipos; nunca hacerlos pasar por datos reales.

## 3. Métricas secundarias candidatas

Debajo de los indicadores principales, investigar:
- Golpes de gracia históricos totales (KB).
- Porcentaje `KB / HK × 100` (si ambos contadores históricos están disponibles).
- Rango PvP máximo alcanzado, si existe en Forever.
- Victorias en campos de batalla y porcentaje de victorias (si se puede obtener también el total de partidas).
- Duelos ganados y perdidos.
- Estadísticas por clase enemiga, facción, rivales frecuentes, rachas, sesiones e historial de enfrentamientos.

**No incluirlas automáticamente en el MVP.** Validar primero qué datos son históricos y cuáles solo se pueden registrar desde la instalación. Las estadísticas de sesión y eventos son opcionales y siempre deben distinguirse de las históricas.

Los golpes de gracia no interesan como métrica protagonista; sí interesan como numerador del segundo ratio.

## 4. Investigación técnica y grado de certeza

Criterio acordado para agentes:
1. **Documentado**: función/contador concreto documentado para Lua; suficiente para planificar provisionalmente.
2. **Implementado**: código abierto de otro addon que lo usa; mayor confianza.
3. **Probado**: ejecución satisfactoria en Forever; confirmación funcional.

No bloquear el diseño por no alcanzar nivel 3, pero tampoco declarar un contador «validado» solo porque exista una función genérica.

Candidatos a investigar, sin asumir compatibilidad:
- `GetStatistic(statisticID)`: consulta estadísticas por ID; localizar **IDs concretos** de HK, KB, muertes causadas por jugadores, victorias y duelos. Verificar si devuelven históricos en Forever.
- `GetStatisticsCategoryList()`, `GetCategoryNumAchievements(categoryID)`, `GetAchievementInfo(categoryID, index)`: posible enumeración de estadísticas e IDs; comprobar firmas y disponibilidad en esta versión.
- `GetPVPLifetimeStats()`: posible acceso a datos PvP históricos/rango; verificar firma y semántica exactas.
- `SetPortraitTexture(texture, unit)`: candidato para retrato real del personaje conectado; confirmar soporte de máscara circular en el cliente.

Referencias iniciales para contrastar (no implican compatibilidad demostrada):
- https://warcraft.wiki.gg/wiki/API_GetStatistic
- https://warcraft.wiki.gg/wiki/Statistics
- https://github.com/xIGBClutchIx/ForeverPlusPlus/blob/main/docs/forever-api.md

**Advertencia:** durante la conversación se hicieron afirmaciones prematuras sobre acceso histórico en Forever. No considerarlas verificadas. Es necesario identificar API + ID de cada contador; después comprobar comportamiento real en Forever.

Registrar por cada contador: nombre, significado, API, ID/firma, versión, fuente, nivel de evidencia, si es histórico y resultado de prueba.

## 5. Arquitectura inicial sugerida (no cerrada)

Mantener Lua simple, modular y sin sobreingeniería:
- `Core/Bootstrap.lua`: inicialización y eventos.
- `Core/Stats.lua`: adaptador para APIs de estadísticas, normalización y ratios; separar fuente de datos de UI.
- `Core/Storage.lua`: SavedVariables para datos propios y snapshots de personajes (sin inventar históricos).
- `UI/General.lua`: vista General y retrato circular.

No implementar APIs inventadas. El scaffold puede dejar módulos preparados y funcionalidad pendiente. Determinar `Interface` del TOC y `SavedVariables` reales antes de distribuir.

## 6. Roadmap propuesto

### Fase 0 — Compatibilidad y descubrimiento
- [x] Identificar versión de cliente (`1.60.1`), TOC (`16001`) y familia API (Mainline moderna).
- [ ] Verificar APIs concretas de retrato y estadísticas, y restricciones de interfaz.
- Documentar fuentes, firmas e IDs de HK, KB, muertes PvP sufridas y rango.
- Diferenciar datos históricos disponibles de datos capturables solo a futuro.

### Fase 1 — MVP de la pestaña General
- Inicialización del addon y apertura/cierre de ventana.
- Retrato real circular y centrado del personaje conectado.
- HK histórico grande, HK/D, KB/D y muertes PvP históricas, en ese orden.
- Estados de carga/no disponible y tratamiento de denominador cero.
- Persistencia mínima y navegación multipersonaje si hay snapshots fiables.

### Fase 2 — Enriquecimiento
- Métricas secundarias documentadas y verificadas.
- Selector de personajes y actualización de snapshots.
- Mejoras visuales y experiencia de uso.

### Fase 3 — Evolución (no comprometida)
- Historial de combates, rivales, clases, facciones, rachas y sesiones cuando los eventos lo permitan.
- Distinguir claramente seguimiento desde instalación frente a históricos.

## 7. Hallazgos de compatibilidad (2026-11-16)

- Forever live: versión `1.60.1`, interfaz `16001`, producto `wowf`, carpeta `_forever_`; documentado por inspección de build 70755 (2026-11-03) en ForeverPlusPlus.
- Utiliza APIs de la familia Mainline moderna, no las de Classic Era; Lua 5.1 según implementaciones comunitarias.
- Hay restricciones modernas de valores secretos y acceso al registro de combate; no diseñar el historial detallado de encuentros suponiendo acceso a eventos de combate.
- Fuentes: https://github.com/xIGBClutchIx/ForeverPlusPlus/blob/main/docs/forever-api.md ; https://github.com/realworldbuilder/wowwrapped/blob/main/docs/addon-api.md ; https://foreverbase.org/en/addons/install/ ; https://forevermeta.me/es/guides/wow-forever-addons-interface
- La existencia de una función genérica no valida los IDs y valores históricos de cada estadística. Esta investigación continúa pendiente.

## 7A. IDs históricos encontrados (2026-11-16)

Evidencia específica de Wowhead Forever 1.60.1:
- `1487` — Total Killing Blows: https://www.wowhead.com/forever/achievement=1487/total-killing-blows
- `1501` — Total deaths from other players: https://www.wowhead.com/forever/achievement=1501/total-deaths-from-other-players
- `GetPVPLifetimeStats()` devuelve `lifetimeHonorableKills, lifetimeMaxPVPRank`; firma documentada en la API generada para camelot/Forever 1.60.1: https://wowlua.dev/api/global/GetPVPLifetimeStats
- `GetStatistic(1487)` y `GetStatistic(1501)` son las consultas candidatas, conforme a https://warcraft.wiki.gg/wiki/API_GetStatistic. El retorno es texto formateado: normalizar localización/separadores antes de calcular ratios.
- **Riesgo crítico:** «Total Killing Blows» podría incluir golpes finales contra criaturas PvE, no solo jugadores. No etiquetar `1487` como KB PvP ni utilizarlo en KB/D hasta comprobar su semántica específica en Forever. No sumar «World Killing Blows» y «Battleground Killing Blows» sin demostrar que World excluye PvE y que no hay solapamiento.
- `1501` explícitamente incluye muertes causadas por otros jugadores, por lo que encaja semánticamente con el denominador deseado.
- Estos IDs están publicados y son una base documental sólida; **todavía no hay prueba funcional de que GetStatistic devuelva sus valores en Forever**.
- Wowhead (2026-09-24) publica la lista completa de estadísticas disponibles en la interfaz Forever: https://www.wowhead.com/forever/news/statistics-pane-now-available-in-wow-forever-beta-383102

## 8. Ideas y preguntas abiertas

- ¿Puede la API de Forever recuperar realmente muertes PvP sufridas históricas, diferenciadas de muertes PvE?
- ¿Qué ID representa los golpes de gracia históricos? ¿Se contabilizan igual en todas las modalidades?
- ¿Se puede dibujar una máscara circular nativa o habrá que usar un marco/overlay visual?
- ¿Cómo representar el retrato de personajes desconectados sin falsificar su apariencia?
- ¿Cuál es la definición precisa de «rango PvP máximo» en Forever?
- ¿Hay estadísticas globales de campos de batalla y duelos con identificadores accesibles?
- ¿Cómo comunicar ausencia de una métrica histórica sin ofrecer cifras engañosas?

## 9. Alcance operativo durante arranque

Priorizar velocidad e iteración. **No configurar pipelines CI/CD, rulesets, políticas de contributors, validaciones obligatorias, PR templates ni burocracia de repositorio**. Cambios directos a `main` son aceptables en esta fase. Añadir pruebas manuales concretas solo cuando aporten valor a la compatibilidad del addon.

Este documento es **temporal**, no un contrato permanente. Eliminar tras completar el MVP.


## Investigación técnica: pestaña «Hoy» (2026-11-17)

**Definición funcional aprobada:** día natural del juego, no sesión de login. Cerrar y reabrir WoW no debe reiniciar la vista. La fuente de datos debe indicar el día al que corresponde y no inventar valores anteriores al seguimiento.

### API documentada para Forever 1.60.1

- `GetPVPSessionStats()` devuelve dos números; el **primero es las muertes con honor de hoy** según documentación de Blizzard (PlayerScript, camelot 1.60.1) y Warcraft Wiki. Aunque el nombre diga «Session», la documentación describe explícitamente el primer valor como «today». No asumir que el segundo representa honor exacto: su semántica es incierta.
- `GetPVPYesterdayStats()` devuelve estadísticas de honor de ayer; útil para diagnóstico, no imprescindible en la vista Hoy.
- `GetPVPLifetimeStats()` sigue siendo la fuente candidata para HK históricas de General.
- **Nivel de evidencia:** documentado para Forever 1.60.1, no probado en el cliente.

Fuentes:
- https://wowlua.dev/api/global/GetPVPSessionStats
- https://warcraft.wiki.gg/wiki/API_GetPVPSessionStats
- https://warcraft.wiki.gg/wiki/API_GetPVPYesterdayStats
- https://warcraft.wiki.gg/wiki/API_GetPVPLifetimeStats

### Estrategia propuesta para las demás métricas de Hoy

No se han identificado APIs diarias específicas para golpes de gracia PvP ni muertes PvP sufridas. Investigar primero si existen contadores diarios reales en Forever. En ausencia de ellos:
1. Guardar en SavedVariables snapshots **fechados por personaje** de los contadores históricos disponibles (IDs candidatos `1487` y `1501`).
2. Calcular diferencias respecto a una **línea base del mismo día**. Solo son diferencias válidas si existe una referencia fiable del inicio del día; si el primer snapshot se toma tarde, marcar el resultado como **parcial desde primera observación**, nunca como total del día.
3. No inferir que el cliente estuvo abierto durante todo el día. Mantener datos entre cierres y aperturas; persistencia en logout y eventos de guardado.
4. Elegir explícitamente fuente de calendario/reinicio (preferir día del servidor si coincide con el «hoy» del propio juego); investigar funciones de fecha y cambios de día, incluyendo sesión que cruza medianoche.
5. Los ratios diarios HK/D y KB/D solo se muestran si sus numeradores y denominador corresponden al **mismo intervalo completo y fiable**. No mezclar HK diarias completas con muertes parciales.
6. Si los contadores históricos disminuyen, no calcular deltas negativos: marcar discontinuidad y reinicializar la referencia con indicación al usuario.

**Pendientes:** confirmar en cliente el comportamiento real de `GetPVPSessionStats()` entre logins y a medianoche; identificar APIs de fecha/reinicio, IDs de duelos y campos de batalla; verificar que `1487` contabiliza exclusivamente KB PvP.


## Investigación adicional — estadísticas nativas Forever (2026-11-17)

**Hallazgo de alto valor:** Wowhead publicó el 24/09/2026 el inventario de estadísticas que la pestaña nativa de Forever 1.60.1 ya registra. Incluye explícitamente:
- Duelos ganados y perdidos.
- Campos de batalla jugados y ganados, además de partidas/victorias por campo.
- Golpes de gracia totales, de mundo y de campos de batalla; muertes con honor totales.
- Muertes totales causadas por otros jugadores y por facción opuesta.

Fuente principal: https://www.wowhead.com/forever/news/statistics-pane-now-available-in-wow-forever-beta-383102

**ID localizado:** `319` = *Duels won* en base de datos de Forever: https://www.wowhead.com/forever/achievement=319/duels-won . Pendiente de comprobar `GetStatistic(319)` dentro del cliente. **No extrapolar IDs** para duelos perdidos ni campos de batalla.

**Corrección de certeza:** que una estadística exista en el panel nativo **no demuestra** que el ID publicado funcione con `GetStatistic` ni que represente todos los eventos previos a su introducción. Probar lectura y semántica en Forever. El nombre `Total Killing Blows` (ID candidato 1487) aparece bajo la categoría *Killing Blows*, junto a *World Killing Blows* y *Battleground Killing Blows*, lo que apoya que sea PvP, pero confirmar experimentalmente antes de usarlo para KB/D.

**Plan de comprobación:** inspeccionar IDs exactos de duelos perdidos, BG jugados/ganados y World/BG KB; validar `GetStatistic` con datos visibles en el panel del personaje; comprobar persistencia y actualización al jugar; contrastar KB total frente a KB mundo+BG (sin asumir equivalencia si hay otras modalidades).


## Prueba real en cliente Forever — 2026-11-17

El usuario instaló WarScore y ejecutó `/wsdiag` dentro del juego. Salida literal (cada llamada muestra hasta cuatro retornos):

```
GetPVPLifetimeStats: 32 | 0 | nil | nil
GetPVPSessionStats: 0 | 0 | nil | nil
GetPVPYesterdayStats: 6 | 0 | nil | nil
GetStatistic(319): -- | false | 319 | nil
GetStatistic(1487): 882 | false | 1487 | nil
GetStatistic(1501): 8 | false | 1501 | nil
```

**Probado:** las tres funciones PvP responden y `GetStatistic` devuelve valores para los IDs 1487 y 1501. `319` devuelve `--`, por lo que **no está validado como contador de duelos ganados**. El segundo retorno de `GetStatistic` es `false` en los tres casos; investigar su significado antes de interpretar ese booleano.

**Alerta de semántica:** HK históricas = 32 mientras KB ID 1487 = 882. No usar 882 para KB/D hasta averiguar si cuenta PvE, distintos periodos o tiene otra semántica. El valor 8 del ID 1501 parece utilizable como candidato de muertes PvP históricas, pero contrastar con panel nativo.

**Siguiente diagnóstico:** imprimir nombre, descripción y categoría de los logros/estadísticas para IDs conocidos; enumerar estadísticas de duelos y BG con sus IDs reales; contrastar los valores visibles en panel de estadísticas; probar cambios diarios entre logins y cruce de medianoche.


## Prueba en cliente — categorías PvP y campos de batalla (2026-11-17)

El usuario ejecutó `/wsdiag list 21` y `/wsdiag list 153`:

- Categoría **21, Jugador contra Jugador**: ID `1501`, «Veces que te han matado otros jugadores» = **8**; ID `318`, «Veces que te ha matado la facción contraria» = **8**.
- Categoría **153, Campos de batalla**: ID `839`, «Campos de batalla jugados» = `--`; ID `840`, «Campos de batalla ganados» = `--`. Todos los demás contadores enumerados de esta categoría también devolvieron `--` (19 entradas en total).

**Interpretación:** IDs `839` y `840` identificados en la API del cliente; el valor `--` no equivale a cero ni demuestra que el contador sea inutilizable. Contrastar con la interfaz nativa y, si es posible, tras jugar un BG. HK/D provisional = `32 / 8 = 4,00` usando las respuestas de las APIs; no implica que las estadísticas tengan necesariamente el mismo horizonte histórico, que debe contrastarse.

**Siguiente prueba:** `/wsdiag list 137` (golpes de gracia), `/wsdiag list 122` (muertes), y captura/lectura del panel nativo de estadísticas para BG y KB. Revisar categoría `128` para duelos y KB si las anteriores no bastan.


## Prueba real — categorías de golpes de gracia y muertes (2026-11-17)

Salida de `/wsdiag list 137`:
- `1487` Golpes de gracia = **882**.
- `1488` Golpes de gracia del mundo = **702**.
- `1489` Continente con más número de golpes de gracia = **354 (Kalimdor)** (valor textual, no contador PvP directo).
- `1491` Golpes de gracia en campos de batalla = `--`.
- `1716` Campo de batalla con más número de golpes de gracia = `--`.
- `1495`, `1496`, `1497`, `64181` (KB por BG) = `--`.

Salida de `/wsdiag list 122`: `60` Muertes propias = **38** (no utilizar como muertes PvP).

**Hallazgo:** `1487` tiene desglose por mundo y campos de batalla, pero **882 KB frente a 32 HK** de `GetPVPLifetimeStats()` es una discrepancia fuerte. No afirmar aún que ambos contadores tengan el mismo horizonte temporal ni utilizar `1487` en KB/D. `1501` = 8 sigue siendo el candidato más específico para muertes sufridas en PvP. Los `--` no equivalen a cero.

**Prueba siguiente recomendada:** comprobar en el panel nativo las cifras HK históricas, KB, muertes PvP y, si hay historial, BG; registrar si el personaje ha participado en BG. Investigar también categoría `128` (víctimas) y `136` (HK) y la procedencia del total de HK (puede reflejar distintos periodos).


## Prueba real — categoría HK (2026-11-17)

`/wsdiag list 136` devolvió:
- `588` Muertes con honor = **32**, coincide con el primer retorno de `GetPVPLifetimeStats()`.
- `381` Muertes con honor en el mundo = **32**.
- `1458` Continente con más HK = **25 (Kalimdor)**.
- `382` HK en campos de batalla = `--`.
- `1719` BG con más HK = `--`.
- `1113`, `1114`, `1115`, `64180` HK por BG = `--`.

**Lectura:** las 32 HK históricas están reflejadas en el contador de mundo, sin registros numéricos de BG en esta prueba. Los `--` no se interpretan automáticamente como cero. La discrepancia de `1487` KB=882 frente a HK=32 sigue abierta; no calcular KB/D todavía.

**Diagnóstico corregido:** la categoría `128` estaba bloqueada por una lista de permitidas del propio addon, no por la API del juego. Habilitada en `Core/Diagnostics.lua` para próxima prueba.

## Prueba real — categoría Víctimas 128 (2026-11-17)

`/wsdiag list 128` devuelve `1197` «Muertes realizadas» = **3936** y `1198` «Cantidad de muertes que te han otorgado experiencia u honor» = **3687**. Son contadores generales de víctimas, no eliminaciones PvP demostradas: **no utilizarlos para KB/D**. Se completó la enumeración de categorías 21, 153, 137, 122, 136 y 128. Queda por explorar la categoría 154 (PvP mundo) y localizar la categoría del ID 319 (duelos). Preguntar si el personaje ha participado en BG antes de interpretar `--` como ausencia de partidas.

## Prueba real — duelos, categoría 154 (2026-11-17)

`/wsdiag list 154` muestra `319` «Duelos ganados» = `--` y `320` «Duelos perdidos» = `--`. El usuario confirma que **nunca ha jugado un duelo con ese personaje** y que la interfaz nativa de WoW muestra **0 ganados / 0 perdidos**. En este caso concreto, `--` corresponde a ausencia de actividad (0 en la UI). **No generalizar todavía** `--` a cero para cualquier ID sin contraste; diseñar normalización específica por estadística tras más pruebas. IDs 319 y 320 ya identificados y sus etiquetas verificadas en el cliente. Próximo paso útil: comparar valores antes/después de un duelo, y verificar si el personaje ha jugado BG; investigar la discrepancia 882 KB vs 32 HK.
