# WarScore

**WarScore** es un addon PvP local para **World of Warcraft Forever** (TOC Interface `16001`). No requiere servidores, cuentas ni servicios externos.

**Estado:** MVP en desarrollo. La pantalla **General** y sus assets se han iterado mediante capturas reales hasta **UI v83**. La pestaña **Hoy** está pendiente; la compatibilidad y semántica de cada estadística requieren comprobación independiente.

## Instalación

**[Descargar WarScore.zip listo para instalar](https://github.com/hectoresen/WarScore/raw/refs/heads/main/dist/WarScore.zip)**. Descomprímelo en `World of Warcraft/_forever_/Interface/AddOns/`; debe quedar `Interface/AddOns/WarScore/WarScore.toc`. No utilices el ZIP automático de código fuente de GitHub. También puedes copiar **solo** `addon/WarScore/` desde un clon.

En el juego usa `/reload`, `/ws` o `/warscore` para abrir General, `/ws version` para consultar la iteración visual y `/wsdiag` para diagnósticos nativos.

## Funcionalidad actual

General muestra retrato real, nivel/clase, muertes con honor, muertes PvP sufridas, ratio HK/D, duelos ganados, BG jugados y ganados, win rates y BG favorito cuando las APIs aportan valores adecuados. **KB/D y rango PvP** se presentan como no disponibles, porque sus datos no están suficientemente verificados. No se inventan datos históricos.

## Estructura (siguiendo CraftAtlas)

```text
addon/WarScore/          # Única carpeta instalable
  WarScore.toc
  Core/                  # Inicio, estadísticas, SavedVariables, diagnósticos
  UI/                    # Interfaz nativa de WoW
  Media/General/         # Arte y texturas TGA
docs/                    # Funcionalidad, arquitectura, instalación, diseño, QA
openspec/                # Especificaciones y propuestas
tools/                   # Conversión de assets y empaquetado
.github/workflows/       # Build y validación automática
dist/WarScore.zip        # Artefacto instalable
```

**La ruta interna del addon instalado no cambia**; las texturas siguen resolviéndose como `Interface\\AddOns\\WarScore\\Media\\...`.

## Documentación

- [Funcionalidad](docs/FUNCTIONAL.md) y [contrato PvP](docs/PVP_STATISTICS.md)
- [Arquitectura](docs/ARCHITECTURE.md), [desarrollo](docs/DEVELOPMENT.md) e [instalación](docs/INSTALLATION.md)
- [Vista General](docs/GENERAL_VIEW.md) y [especificación visual](docs/GENERAL_VISUAL_SPEC.md)
- [Handoff e iteraciones](docs/DEVELOPMENT_HANDOFF.md), [flujo OpenSpec](openspec/README.md)

## Empaquetado

Instala Pillow (`python3 -m pip install Pillow`) y ejecuta los generadores `tools/prepare_ratio_asset.py`, `prepare_card_asset.py`, `prepare_top_icons.py`, `prepare_bottom_icons.py`, seguidos de `python3 tools/package_addon.py`. GitHub Actions ejecuta y valida este flujo automáticamente al cambiar runtime y herramientas. Su resultado contiene una sola carpeta raíz `WarScore/` sin documentación ni scripts.
