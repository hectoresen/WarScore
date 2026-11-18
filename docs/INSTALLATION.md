# Instalación y verificación de WarScore

Descarga [el ZIP instalable](https://github.com/hectoresen/WarScore/raw/refs/heads/main/dist/WarScore.zip), no el archivo de código fuente que GitHub ofrece automáticamente.

Descomprime en `World of Warcraft/_forever_/Interface/AddOns/` hasta obtener **`Interface/AddOns/WarScore/WarScore.toc`**. El ZIP ya contiene la carpeta `WarScore/`; evita una doble carpeta.

Si trabajas desde el repositorio, copia **`addon/WarScore/`** a `Interface/AddOns/`. Sobrescribe la versión anterior.

## Prueba
1. Activa WarScore en los addons del cliente.
2. Ejecuta `/reload`, `/ws version` (iteración UI 83 tras la reorganización) y `/ws`.
3. Comprueba retrato, marcos, métricas y dos filas de tarjetas sin errores Lua.
4. Comprueba `/wsdiag` si necesitas inspeccionar el acceso a datos.
5. Usa una captura real para confirmar alineación. Build correcto y aspecto aceptado son evidencias distintas.

**Advertencia:** la pestaña Hoy no está implementada como vista de día natural; KB/D y rango PvP carecen de fuente fiable.
