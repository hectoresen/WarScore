---
name: documentation-sync
description: Reconcile WarScore implementation, verified tests, current specifications and public documentation before acceptance or OpenSpec archiving.
---

# Sincronización documental de WarScore

1. Leer `AGENTS.md`, `README.md`, el cambio OpenSpec aprobado, `docs/PVP_STATISTICS.md`, `docs/GENERAL_VIEW.md`, `docs/GENERAL_VISUAL_SPEC.md` y los Lua afectados.
2. Comparar cada requisito verificable con el código. Distinguir **implementado**, **probado offline**, **probado en cliente Forever**, **aceptado por propietario** y **NOT RUN**.
3. Mantener el README sencillo para jugadores. Llevar IDs de APIs, retornos y semántica a `docs/PVP_STATISTICS.md`; las funcionalidades futuras a `docs/PVP_DATA_CATALOG.md`.
4. Revisar compatibilidad nativa, formatos/licencias de assets, fuentes, datos ausentes, traducciones, rango PvP, KB/D y navegación.
5. Actualizar `tasks.md` únicamente con evidencia comprobable. Nunca inferir QA del cliente desde una maqueta o una inspección estática.
6. Ejecutar validaciones OpenSpec con la CLI instalada, registrar comando y resultado real. Si la CLI no está disponible, registrar **NOT RUN**, no sustituir por un movimiento manual de carpetas.
7. Archivar mediante `openspec archive <nombre> --yes` **únicamente tras aceptación**, con integración de requisitos en `openspec/specs/`. Ejecutar verificación posterior.
8. Informar de ficheros cambiados, PASS/FAIL/NOT RUN, aceptación en cliente y pendientes.

Consultar `openspec/README.md` para el flujo exacto. No trasladar automáticamente reglas de repositorios ajenos.
