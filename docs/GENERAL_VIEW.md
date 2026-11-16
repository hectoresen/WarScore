# WarScore — Contrato de diseño: vista General

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
