# Desarrollo y empaquetado

Estructura basada en CraftAtlas: `addon/WarScore/` contiene la instalación completa; `docs/`, `openspec/` y `tools/` son exclusivos del repositorio.

## Flujo de cambios
1. Leer `AGENTS.md`, `docs/DEVELOPMENT_HANDOFF.md` y contratos relacionados.
2. Identificar cambios acotados y preservar assets/posiciones aprobados.
3. Aplicar el cambio en `addon/WarScore/`, actualizar documentación e iteración cuando proceda.
4. Ejecutar conversión, empaquetado y validación estructural.
5. Entregar `dist/WarScore.zip` y verificarlo en el cliente mediante `/reload`, `/ws version` y captura.
6. Documentar aceptación o defectos; no equiparar CI con pruebas de interfaz.

## Reproducir el build
```bash
python3 -m pip install Pillow
python3 tools/prepare_ratio_asset.py
python3 tools/prepare_card_asset.py
python3 tools/prepare_top_icons.py
python3 tools/prepare_bottom_icons.py
python3 tools/package_addon.py
```

Los generadores leen `docs/assets/` y escriben TGA bajo `addon/WarScore/Media/General/`. El empaquetador incluye solo TOC, Lua y TGA **referenciadas**. GitHub Actions conserva el ZIP verificado en `dist/`.

No se importan las reglas de ramas, PR, licenciamiento ni publicación de releases de CraftAtlas sin una decisión específica.


## Fuente cursiva integrada (v87)

La línea «x veces jugado» usa `addon/WarScore/Media/Fonts/Spectral-Italic.ttf` (Google Fonts; SIL OFL 1.1; licencia en `Media/Fonts/OFL.txt`). `python3 tools/prepare_italic_font.py` comprueba la huella Git del archivo y solo lo obtiene del repositorio fuente público si falta. El ZIP contiene la fuente real. No depende de que el cliente WoW incluya cursiva por defecto.
