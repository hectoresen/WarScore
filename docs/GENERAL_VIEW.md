# WarScore — Vista General: contexto y propuestas de diseño

> **ESTADO VISUAL: PREVIEW EN ITERACIÓN — DISEÑO NO APROBADO.** Las decisiones de producto recogidas aquí siguen vigentes, pero las propuestas estéticas no autorizan implementación. No modificar código de UI hasta aprobación expresa.
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

Diseñar un bloque secundario **por debajo** de los cinco indicadores principales, sin competir visualmente con ellos. Preparar el espacio y componentes de forma flexible; **no mostrar valores falsos**.

| Métrica | Estado para diseño | Nota técnica |
| --- | --- | --- |
| Golpes de gracia históricos (KB) | Candidata documentada, condicionada | Estadística ID `1487` (*Total Killing Blows*). Hay que confirmar que representa exclusivamente golpes finales PvP; no asumirlo. |
| Porcentaje de golpes de gracia | Derivada, condicionada | `KB PvP / HK × 100`; solo si KB corresponde realmente a PvP. |
| Rango PvP máximo | API documentada, pendiente de prueba | `GetPVPLifetimeStats()` ofrece un rango histórico; verificar su significado en Forever. |
| **Duelos ganados** | **Añadida al diseño, pendiente de ID Lua** | Estadística registrada por WoW; localizar ID exacto y lectura histórica en Forever. |
| **Duelos perdidos** | **Añadida al diseño, pendiente de ID Lua** | Misma validación que duelos ganados. |
| **Porcentaje de duelos ganados** | **Derivada, condicionada** | `ganados / (ganados + perdidos) × 100`; no mostrar si falta alguno de los contadores. |
| Victorias en campos de batalla | Candidata, pendiente de ID | No separar modalidades en el bloque principal. |
| Porcentaje de victorias en campos de batalla | Candidata, condicionada | Solo si existe también un denominador histórico fiable. |

**Decisión visual para duelos:** agrupar victorias y derrotas en una misma tarjeta o subapartado «Duelos», con el porcentaje de victorias como dato complementario si es calculable. Evitar que esta sección quite protagonismo a HK y los dos ratios.

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
- **Bloque de estadísticas complementarias:** mantenerlo visualmente separado y subordinado al bloque principal; contenido sujeto a validación técnica y decisiones existentes en este documento.
- **Datos de muestra:** pueden ser ficticios **solo en bocetos**, siempre identificados como tales.

**Pendiente de revisar conjuntamente:** grado de ornamentación, textura y marco, proporciones y tamaño del retrato, separación entre métricas, colocación final de los microcopies y tratamiento visual del bloque inferior. No considerar aprobada ninguna de estas elecciones hasta confirmación explícita.

## Referencia visual objetivo — boceto generado (2026-11-16)

**Estado: REFERENCIA DE ASPIRACIÓN VISUAL, NO DISEÑO APROBADO NI GARANTÍA TÉCNICA.**

Se ha generado en la conversación un boceto de la ventana General que el usuario desea conservar como referencia estética para futuras iteraciones. La imagen original está en la conversación de diseño; **este documento registra sus características, pero no constituye una copia de la imagen**.

Características que interesa preservar al evolucionar la propuesta:

- Ventana vertical con marco de metal oscuro, detalles dorados y esquinas ornamentales, evocando directamente la UI clásica de Warcraft.
- Cabecera **WarScore**, pestaña **General** visible y cierre en la esquina superior derecha.
- Retrato circular grande, centrado, con ilustración provisional de un personaje orco; nombre, nivel y clase justo debajo. En producción se sustituirá por el retrato real según posibilidades de Forever.
- Fondo oscuro texturizado, con elementos de ambientación de la Horda en los laterales del boceto (no necesariamente definitivos ni obligatorios para Alianza).
- **Muertes con honor**: título con adornos de laurel y gran cifra dorada, máximo foco de atención.
- **Ratio HK/D** y **ratio KB/D**: datos centrados y decrecientes en jerarquía; icono de ayuda junto a la etiqueta y microcopy descriptivo bajo la cifra.
- **Muertes PvP sufridas** al final del panel, con cifra roja apagada.
- Separadores dorados finos entre secciones. Sensación de panel integrado en el juego, no de aplicación web.

Los valores y el personaje del boceto son **ficticios**. La fidelidad de texturas, máscaras circulares, fuentes y retratos debe verificarse en WoW Forever antes de implementación. No modificar código ni tratar esta referencia como aprobada sin acuerdo posterior.
