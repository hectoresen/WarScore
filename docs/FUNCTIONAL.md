# Funcionalidad actual — WarScore

**Corte:** 18/11/2026; última iteración visual sometida a prueba de cliente: **v83**. Fuentes: `addon/WarScore/Core/Stats.lua`, `UI/General.lua` y [contrato PvP](PVP_STATISTICS.md).

## Implementado
- Abrir ventana nativa con `/ws` o `/warscore`; tabs General y Hoy (Hoy todavía sin contenido funcional).
- Retrato, nombre, nivel y clase del personaje activo; ornamentos de facción, con arte de Horda y fallback para Alianza.
- Muertes con honor, muertes sufridas por otros jugadores y ratio HK/D histórico cuando la API dispone de cifras.
- Duelos ganados, BG jugados, BG ganados, porcentajes de victoria calculados con denominadores válidos y campo de batalla favorito por partidas; empates explícitos.
- Dos filas de tarjetas con assets ornamentales, iconos y cifras dinámicas.
- `/ws version` (iteración de UI; independiente del campo `Version: 0.1.0` del manifiesto), diagnósticos `/wsdiag`.

## No disponibles deliberadamente
- **KB/D**: el ID 1487 no ha sido validado como golpes de gracia *exclusivamente PvP*.
- **Rango PvP**: fuente no confirmada. El panel muestra «No disponible».
- Valores desconocidos no se sustituyen por datos ficticios; la normalización a cero de duelos vacíos es un caso específico contrastado.

## Pendiente
- Vista Hoy con día natural y snapshots parciales correctamente etiquetados.
- Navegación real multipersonaje y separación de datos actuales frente a cacheados.
- Historial de enfrentamientos, rivales por clase/facción, rachas y sesiones.
- Validación positiva de BG/duelos y semántica de rango/KB en el cliente.

Las capturas de la v83 y anteriores confirman el trabajo visual, **no** constituyen una certificación integral de APIs o clientes.
