# WarScore — Vista General: contexto y propuestas de diseño

> **ESTADO VISUAL: REFERENCIA OBJETIVO ELEGIDA, AÚN SIN APROBACIÓN PARA IMPLEMENTAR.** El usuario ha elegido el segundo boceto generado como referencia visual principal; debe reproducirse con la máxima fidelidad técnicamente posible. Las decisiones de producto siguen vigentes y no se autoriza modificar la UI hasta aprobación expresa.
>
> Documento vivo para el agente de UI/UX. Leer junto a `docs/MVP_CONTEXT.md`. Actualizar este archivo cuando se confirme, descarte o cambie una métrica. **No implica que la API haya sido probada en el cliente.**
>
> Última actualización: 2026-11-16.

## Jerarquía visual acordada (obligatoria)

1. **Retrato real del personaje activo**, centrado arriba, recortado circularmente; no avatar genérico, ni imagen cuadrada o lateral. La API candidata es `SetPortraitTexture`; verificar el soporte de máscara circular de Forever.
2. **Muertes con honor históricas (HK)**, la cifra más grande y protagonista.
3. **HK/D**, segundo dato más visible: HK históricas / muertes PvP sufridas históricas.
4. **KB/D**, más pequeño y justo debajo del HK/D: golpes de gracia PvP históricos / muertes PvP sufridas históricas.
5. **Muertes PvP sufridas históricas**, en la zona inferior del bloque principal.

Toda la vista General agrega PvP de cualquier modalidad; **sin filtros de mundo abierto/campos de batalla**. Las estadísticas principales deben cubrir el historial del personaje desde su creación, independientemente de cuándo se instaló WarScore.

Los términos HK/D y KB/D son técnicamente más precisos que «KDA». Si el denominador es cero o el dato no está disponible, mostrar un estado neutral (`—`), no un ratio ficticio.

## Sección inferior — estadísticas complementarias

Diseñar un bloque secundario **por debajo** de los cinco indicadores principales, sin alterar la composición ya propuesta para ellos. En la siguiente iteración del boceto, destacar en esta zona **duelos totales ganados** y **número total de campos de batalla jugados**; ambos son contadores históricos deseados, pero su disponibilidad en la API de Forever está pendiente de verificación. Preparar el espacio y componentes de forma flexible; **no mostrar valores falsos**.

| Métrica | Estado para diseño | Nota técnica |
| --- | --- | --- |
| Golpes de gracia históricos (KB) | Candidata documentada, condicionada | Estadística ID `1487` (*Total Killing Blows*). Hay que confirmar que representa exclusivamente golpes finales PvP; no asumirlo. |
| Porcentaje de golpes de gracia | Derivada, condicionada | `KB PvP / HK × 100`; solo si KB corresponde realmente a PvP. |
| Rango PvP (histórico / máximo por definir) | **Posición visual por decidir: quizá entre datos principales**; API pendiente de prueba | Investigar `GetPVPLifetimeStats()`, confirmar significado y disponibilidad real en Forever. No moverlo aún al bloque principal sin aprobar la nueva jerarquía. |
| **Duelos totales ganados** | **Prioridad en el nuevo bloque inferior; pendiente de ID Lua y prueba** | Confirmar ID, acceso y lectura histórica en Forever. |
| **Duelos perdidos** | **Añadida al diseño, pendiente de ID Lua** | Misma validación que duelos ganados. |
| **Porcentaje de duelos ganados** | **Derivada, condicionada** | `ganados / (ganados + perdidos) × 100`; no mostrar si falta alguno de los contadores. |
| **Campos de batalla totales jugados** | **Prioridad en el nuevo bloque inferior; pendiente de ID Lua y prueba** | Se solicitan **partidas disputadas**, no solamente victorias; confirmar contador histórico accesible en Forever. |
| Victorias en campos de batalla | Candidata, pendiente de ID | No separar modalidades en el bloque principal. |
| Porcentaje de victorias en campos de batalla | Candidata, condicionada | Solo si existe también un denominador histórico fiable. |

**Actualización de diseño (2026-11-16):** en la siguiente preview, añadir una zona inferior diferenciada con **duelos totales ganados** y **campos de batalla totales jugados**, con números legibles pero secundarios. Las restantes métricas candidatas de esta tabla no se incorporan automáticamente al boceto.

**Propuesta anterior sobre duelos, aún por revisar:** agrupar victorias y derrotas en una misma tarjeta o subapartado «Duelos», con el porcentaje de victorias si es calculable. La nueva prioridad explícita son los **duelos ganados**; no incorporar automáticamente derrotas ni porcentajes.

**Rango PvP:** el segundo boceto de referencia lo muestra debajo del retrato y antes de HK, como placa/ribbon ornamental. Es la **ubicación objetivo de la preview**, sujeta a la disponibilidad y semántica real del dato en Forever.

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
- **Rango PvP:** en la referencia visual elegida aparece como placa bajo el nombre/nivel/clase y antes de HK. Mantener esa composición en la preview; significado histórico y viabilidad aún pendientes.
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
