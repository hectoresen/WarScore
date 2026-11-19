# WarScore — Vista General: contexto y propuestas de diseño

> **ESTADO VISUAL: VISTA GENERAL IMPLEMENTADA Y AVANZADA HASTA UI v126 (2026-11-19).** El boceto objetivo sigue siendo una referencia de largo plazo, no un asset runtime. Las propuestas y jerarquías históricas de este documento se conservan como contexto; la implementación real y la evidencia se encuentran en `addon/WarScore/UI/General.lua`, `docs/PVP_DATA_CATALOG.md` y `docs/DEVELOPMENT_HANDOFF.md`.
>
> Documento vivo para el agente de UI/UX. Leer junto a `docs/MVP_CONTEXT.md`. Actualizar este archivo cuando se confirme, descarte o cambie una métrica. **No implica que la API haya sido probada en el cliente.**
>
> Última actualización del estado: 2026-11-19.

> **Estado técnico actual:** Honor actual (`1792`), rango PvP y Rank Points (`C_MajorFactions` `2800`) ya están integrados en General. La vista de Ajustes permite seleccionar idioma y el icono de minimapa abre/cierra la ventana y conserva su posición. Para la disponibilidad real de cada dato prevalece `docs/PVP_DATA_CATALOG.md`.

## Jerarquía visual acordada (obligatoria)

1. **Retrato real del personaje activo**, centrado arriba, recortado circularmente; no avatar genérico, ni imagen cuadrada o lateral. La API candidata es `SetPortraitTexture`; verificar el soporte de máscara circular de Forever.
2. **Muertes con honor históricas (HK)**, la cifra más grande y protagonista.
3. **HK/D**, segundo dato más visible: HK históricas / muertes PvP sufridas históricas.
4. **Muertes PvP sufridas históricas**, en rojo y junto al bloque de ratios. KB/D no se muestra porque no existe una fuente confirmada de golpes de gracia contra jugadores enemigos.
5. **Estadísticas secundarias**, con menor jerarquía visual y sin sustituir los datos históricos principales.

Toda la vista General agrega PvP de cualquier modalidad; **sin filtros de mundo abierto/campos de batalla**. Las estadísticas principales deben cubrir el historial del personaje desde su creación, independientemente de cuándo se instaló WarScore.

Los términos HK/D y KB/D son técnicamente más precisos que «KDA». Si el denominador es cero o el dato no está disponible, mostrar un estado neutral (`—`), no un ratio ficticio.

## Sección inferior — estadísticas complementarias

Diseñar un bloque secundario **por debajo** de los cinco indicadores principales, sin alterar la composición ya propuesta para ellos. En la siguiente iteración del boceto, destacar en esta zona **duelos totales ganados** y **número total de campos de batalla jugados**; ambos son contadores históricos deseados, pero su disponibilidad en la API de Forever está pendiente de verificación. Preparar el espacio y componentes de forma flexible; **no mostrar valores falsos**.

| Métrica | Estado para diseño | Nota técnica |
| --- | --- | --- |
| Golpes de gracia históricos (KB) | **No confirmada como métrica PvP** | `1487/1488/1491` están en categoría 137 bajo `Víctimas`; sus valores no son utilizables como golpes contra la facción rival. |
| Porcentaje de golpes de gracia | **No disponible** | No calcular `KB/D` hasta encontrar un contador específico de golpes contra jugadores enemigos. |
| Rango PvP / Rank Points | **Implementado; fuente confirmada en Forever** | `C_MajorFactions.GetMajorFactionProgressionInfo(2800)` aporta nivel y progreso; la barra gráfica permanece desactivada. |
| **Duelos totales ganados** | **Implementado; valor positivo pendiente** | ID `319` identificado; devuelve `--` en el personaje probado y `0` en la UI nativa sin duelos. |
| **Duelos perdidos** | **Implementado; valor positivo pendiente** | ID `320`; necesita un caso real para validar lectura positiva. |
| **Porcentaje de duelos ganados** | **Derivada, condicionada** | `ganados / (ganados + perdidos) × 100`; no mostrar si falta alguno de los contadores. |
| **Campos de batalla totales jugados** | **Implementado; probado con valor positivo** | ID `839`; primera BG observada con valor `1`. |
| Victorias en campos de batalla | **Implementado; valor positivo pendiente** | ID `840`; la primera BG probada fue perdida y devolvió `--`. |
| Porcentaje de victorias en campos de batalla | **Implementado; condicionado** | Solo es evidencia fiable tras validar una victoria positiva. |

**Actualización de diseño (2026-11-16):** en la siguiente preview, añadir una zona inferior diferenciada con **duelos totales ganados** y **campos de batalla totales jugados**, con números legibles pero secundarios. Las restantes métricas candidatas de esta tabla no se incorporan automáticamente al boceto.

**Propuesta anterior sobre duelos, aún por revisar:** agrupar victorias y derrotas en una misma tarjeta o subapartado «Duelos», con el porcentaje de victorias si es calculable. La nueva prioridad explícita son los **duelos ganados**; no incorporar automáticamente derrotas ni porcentajes.

**Rango PvP:** el segundo boceto de referencia lo muestra debajo del retrato y antes de HK, como placa/ribbon ornamental. Esa composición ya está implementada; el nivel y Rank Points proceden de la major faction `2800`.

## Semáforo de evidencia

- **Documentado:** existen API e identificador publicados (viable para prototipado).
- **Implementado:** encontrado uso concreto en código de terceros.
- **Probado:** confirmado en el cliente Forever.

El diseñador puede preparar componentes para métricas documentadas o candidatas, pero **no tratarlas como funcionalidad garantizada**. Diferenciar prototipos con datos ficticios de implementaciones reales.

### Fuentes iniciales

- `GetStatistic(id)`: https://warcraft.wiki.gg/wiki/API_GetStatistic
- Estadística `1487`: https://www.wowhead.com/forever/achievement=1487/total-killing-blows
- Estadística `1501`: https://www.wowhead.com/forever/achievement=1501/total-deaths-from-other-players
- Contexto técnico: `docs/MVP_CONTEXT.md`

## Coordinación entre agentes

- **Agente técnico:** investiga compatibilidad, semántica e IDs; actualiza esta tabla cuando cambie la evidencia.
- **Agente de diseño:** consulta este archivo antes de diseñar o implementar la pantalla; respeta la jerarquía visual y deja preparada una sección inferior extensible.
- Las decisiones visuales nuevas deben acordarse con el usuario; no añadir métricas por iniciativa propia al MVP.

## Preview visual en iteración (NO APROBADA)

Las siguientes son **ideas para explorar**, no decisiones de diseño cerradas ni instrucciones de implementación:

- **Dirección estética tentativa:** ventana compacta y vertical inspirada en paneles nativos de WoW, con fondo oscuro texturizado, bordes dorados discretos, tipografía acorde al juego y separadores sutiles; evitar apariencia de dashboard web o abundancia de tarjetas.
- **Retrato durante el prototipado:** mostrar dentro del marco circular una ilustración provisional de un personaje de Warcraft para dar identidad visual a los bocetos. **Es solo un placeholder visual**, nunca un sustituto definitivo del retrato real del personaje. En producción investigar y usar la API de retrato disponible en Forever, sin asumir máscaras circulares funcionales.
- **HK:** cifra grande en dorado y centrada, claramente predominante.
- **HK/D y KB/D:** apilados verticalmente, con HK/D más destacado; incluir un **microcopy aclaratorio** de tamaño pequeño, gris/beige y jerarquía baja, colocado al lado del dato o debajo (ubicación aún por decidir):
  - HK/D: «Muertes con honor / Muertes PvP sufridas».
  - KB/D: «Golpes de gracia / Muertes PvP sufridas».
- **Muertes PvP sufridas:** parte inferior del bloque principal; cifra secundaria, posiblemente en rojo apagado.
- **Bloque de estadísticas complementarias:** añadir debajo del bloque principal dos indicadores visuales: **duelos totales ganados** y **campos de batalla totales jugados**, sin cambiar lo que ya figura por encima. Mantenerlo subordinado, con separadores ornamentales discretos. Disponibilidad histórica pendiente de verificación.
- **Rango PvP:** la placa bajo el nombre/nivel/clase y antes de HK ya está implementada con datos de `2800`; queda pendiente validar niveles superiores y la progresión visual con valores positivos.
- **Datos de muestra:** pueden ser ficticios **solo en bocetos**, siempre identificados como tales.

**Pendiente de revisar conjuntamente:** grado de ornamentación, textura y marco, proporciones y tamaño del retrato, separación entre métricas, colocación final de los microcopies y tratamiento visual del bloque inferior. No considerar aprobada ninguna de estas elecciones hasta confirmación explícita.

## Referencia visual objetivo — boceto generado (2026-11-16)

**Estado actualizado: SEGUNDO BOCETO ELEGIDO COMO REFERENCIA VISUAL PRINCIPAL. Máxima fidelidad como objetivo; no constituye aprobación de implementación ni garantía de compatibilidad técnica.**

El **segundo boceto generado en esta conversación (2026-11-16)**, que incorpora rango PvP y dos indicadores inferiores, es la referencia elegida por el usuario. **Intentar reproducirlo con la mayor fidelidad posible** en proporciones, texturas, contornos, tipografía, iluminación, iconos, jerarquía y separadores. No simplificarlo por preferencia personal: adaptar solo cuando una limitación demostrada de WoW Forever lo exija. La imagen original está en la conversación; **este documento conserva una descripción textual, no adjunta aún el archivo gráfico al repositorio**.

Características que interesa preservar al evolucionar la propuesta:

- Ventana vertical con marco de metal oscuro, detalles dorados y esquinas ornamentales, evocando directamente la UI clásica de Warcraft.
- Cabecera **WarScore**, pestañas contiguas **General** y **Hoy** (la segunda se incorporará en la próxima iteración), y cierre en la esquina superior derecha.
- Retrato circular grande, centrado, con ilustración provisional de un personaje orco; nombre, nivel y clase justo debajo. En producción se sustituirá por el retrato real según posibilidades de Forever.
- Fondo oscuro texturizado, con elementos de ambientación de la Horda en los laterales del boceto (no necesariamente definitivos ni obligatorios para Alianza).
- **Rango PvP**: placa ornamental debajo de la identidad del personaje y antes de HK, tal como aparece en el segundo boceto; denominación e histórico por verificar.
- **Muertes con honor**: título con adornos de laurel y gran cifra dorada, máximo foco de atención.
- **Ratio HK/D** y **ratio KB/D**: en el segundo boceto aparecen en **dos columnas contiguas** con separador vertical; mantener HK/D visualmente más importante. Cada uno tiene icono de ayuda junto a la etiqueta y microcopy bajo el valor. Esta presentación visual sustituye provisionalmente la anterior disposición apilada, pendiente de validación final.
- **Muertes PvP sufridas** en rojo apagado, justo encima de la sección complementaria.
- **Pie complementario** enmarcado, en dos columnas: **duelos ganados** y **campos de batalla jugados**, con iconos e indicadores de menor peso.
- Separadores dorados finos entre secciones. Sensación de panel integrado en el juego, no de aplicación web.

Los valores y el personaje del boceto son **ficticios**. La fidelidad de texturas, máscaras circulares, fuentes y retratos debe verificarse en WoW Forever antes de implementación. No modificar código ni tratar esta referencia como aprobada sin acuerdo posterior.

## Nueva pestaña «Hoy» — alcance inicial (2026-11-16)

**Decisión de producto:** añadir una segunda pestaña etiquetada exactamente **«Hoy»**, inmediatamente **a la derecha de «General»**, con estética y estructura de navegación coherentes con el segundo boceto objetivo.

- **General:** muestra estadísticas PvP **históricas/acumuladas** del personaje, conforme a las restricciones de disponibilidad y evidencia técnica ya descritas.
- **Hoy:** mostrará **estadísticas PvP correspondientes exclusivamente al día actual**, no los acumulados históricos. No trasladar automáticamente los totales históricos a esta pestaña.
- **Pendiente de diseño y aprobación:** métricas concretas, disposición interna de «Hoy», si se usa historial obtenido de una API diaria o seguimiento local, persistencia, momento exacto de reinicio diario (hora local / servidor) y tratamiento de periodos sin seguimiento. Evitar inventar datos anteriores a la instalación si no son recuperables.
- La incorporación de la pestaña no debe cambiar la distribución de las estadísticas de «General» más allá del espacio de navegación requerido.

**Nota para agentes:** documentar aquí nuevas decisiones cuando se acuerden; no implementar ninguna de las dos pestañas a partir del boceto sin autorización explícita.

## Actualización técnica para «Hoy» (2026-11-17)

- **HK del día:** API específica documentada en Forever 1.60.1: `GetPVPSessionStats()` (primer retorno). Se describe como HK de «hoy», incluso aunque el nombre diga «Session». Pendiente de prueba en el cliente; no usar restas de históricos si funciona.
- **Muertes PvP sufridas / golpes de gracia del día:** no se han identificado APIs diarias equivalentes. Posible seguimiento por snapshots de históricos con SavedVariables, pero puede ofrecer **datos parciales** cuando no hay línea base del comienzo del día.
- **Ratios diarios:** no calcular mezclando HK completas con muertes/KB parciales. Mostrar «—» o un estado de seguimiento parcial si los intervalos no son comparables.
- **Persistencia:** el día no termina al cerrar sesión. Resolver cambio de fecha según calendario del juego y persistir por personaje.
- **Estado de diseño:** estas decisiones funcionales no aprueban la implementación visual ni alteran el boceto objetivo.

Fuentes: https://wowlua.dev/api/global/GetPVPSessionStats ; https://warcraft.wiki.gg/wiki/API_GetPVPSessionStats ; https://warcraft.wiki.gg/wiki/API_GetPVPYesterdayStats


## Evidencia adicional — métricas de General (2026-11-17)

Wowhead confirma que la pestaña de estadísticas **nativa de WoW Forever 1.60.1** incluye *Duels won*, *Duels lost*, *Battlegrounds played*, *Battlegrounds won*, *Total Killing Blows*, *World Killing Blows*, *Battleground Killing Blows*, *Total Honorable Kills* y *Total deaths from other players*. Esto eleva la certeza de **existencia del contador**, pero **no** valida aún su lectura desde Lua ni su historial completo anterior al lanzamiento de las estadísticas.

- **Duelos ganados/perdidos:** IDs `319`/`320` identificados y conectados; falta probar valores positivos tras jugar duelos.
- **BG jugados/ganados:** IDs `839`/`840` conectados; `839` ya tiene valor positivo probado y `840` necesita una victoria real para validar su lectura.
- **Golpes de gracia PvP:** la categoría nativa desglosa mundo/BG y total; confirmar semántica del ID `1487` antes de calcular KB/D.
- **Diseño:** mantener el pie de la referencia con duelos ganados y BG jugados; no añadir automáticamente las otras métricas.

Fuentes: https://www.wowhead.com/forever/news/statistics-pane-now-available-in-wow-forever-beta-383102 ; https://www.wowhead.com/forever/achievement=319/duels-won


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

## Prueba real — duelos, categoría 154 (2026-11-17)

`/wsdiag list 154` muestra `319` «Duelos ganados» = `--` y `320` «Duelos perdidos» = `--`. El usuario confirma que **nunca ha jugado un duelo con ese personaje** y que la interfaz nativa de WoW muestra **0 ganados / 0 perdidos**. En este caso concreto, `--` corresponde a ausencia de actividad (0 en la UI). **No generalizar todavía** `--` a cero para cualquier ID sin contraste; diseñar normalización específica por estadística tras más pruebas. IDs 319 y 320 ya identificados y sus etiquetas verificadas en el cliente. Próximo paso útil: comparar valores antes/después de un duelo, y verificar si el personaje ha jugado BG; investigar la discrepancia 882 KB vs 32 HK.

## Contraste con interfaz nativa — 2026-11-17

El usuario confirma en el panel nativo de WoW Forever: «Veces que te han matado otros jugadores» **8**, «Veces que te ha matado la facción contraria» **8**, «Muertes con honor» **32**, «Muertes con honor en el mundo» **32**. Coinciden con `GetStatistic(1501)=8`, `GetStatistic(318)=8`, `GetStatistic(588)=32` y `GetStatistic(381)=32`. HK/D calculable para este personaje: **32/8 = 4,00**.

También confirma **cero duelos realizados** y que el panel muestra 0 ganados/0 perdidos aunque `GetStatistic(319)` y `(320)` devuelvan `--`. **No ha jugado ningún campo de batalla**, lo que es coherente con los `--` de IDs 839 y 840; aún no está contrastado el valor numérico del panel BG. No puede hacer duelos ahora: no bloquear el desarrollo por esta prueba.

**Pendiente crítico:** contrastar `GetStatistic(1487)=882` golpes de gracia con el panel nativo y explicar por qué supera las 32 HK; no calcular KB/D con ese contador hasta resolverlo. La coincidencia de estadísticas históricas entre API y panel en este personaje no garantiza automáticamente la cobertura de toda la vida del personaje en otros casos.

## Decisión aprobada — ampliación de General (2026-11-17)

**ÚNICAS cinco métricas nuevas autorizadas para la vista General** (además de las ya acordadas):

1. **BG ganados:** `GetStatistic(840)`.
2. **Win rate BG:** `GetStatistic(840) / GetStatistic(839) × 100`, si hay partidas y datos válidos.
3. **Win rate duelos:** `GetStatistic(319) / (GetStatistic(319) + GetStatistic(320)) × 100`, si hay duelos y datos válidos.
4. **Campo de batalla favorito:** BG con mayor número de partidas disputadas, usando IDs 53 (Valle de Alterac), 55 (Cuenca de Arathi), 52 (Garganta Grito de Guerra) y 64179 (Islas Lanza Negra).
5. **Veces jugado el BG favorito:** valor del contador correspondiente.

Presentar estas métricas en la **zona secundaria inferior** y mantener intacta la composición principal y el boceto de referencia. Esto define alcance funcional, **no aprueba una nueva maqueta**. No añadir las otras métricas propuestas (HK mundo, HK BG, duelos perdidos como tarjeta independiente, etc.) a General. Reservar nuevas estadísticas para futuras pestañas.

**Sin actividad:** mostrar `—` en porcentajes y BG favorito cuando no exista denominador o partidas; no inventar porcentaje 0%. En empate de partidas máximas, no elegir arbitrariamente un favorito: mostrar empate o estado explícito pendiente de decisión visual. IDs de BG identificados en el cliente pero todavía sin valores positivos probados.

## Referencia de implementación de alta fidelidad (2026-11-17)

El usuario ha seleccionado el **boceto ampliado de General con dos filas de métricas secundarias** como referencia objetivo. La traducción visual a medidas, tokens, capas, assets y componentes nativos de WoW está especificada en **[`docs/GENERAL_VISUAL_SPEC.md`](GENERAL_VISUAL_SPEC.md)**. Hay además una **[guía vectorial de coordenadas](assets/general-layout-guide.svg)** (no es el arte final). **La imagen PNG original todavía no está subida al repositorio**: el documento indica su ruta objetivo y no debe confundirse la guía SVG con el boceto. Mantener la implementación en estado pendiente de aprobación; no simplificar el diseño por comodidad. La imagen solo contiene una pestaña General, pero la navegación final también debe incluir Hoy según decisión previa.
