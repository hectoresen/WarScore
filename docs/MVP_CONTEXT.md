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
