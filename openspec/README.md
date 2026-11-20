# OpenSpec en WarScore

Este directorio gestiona el diseño y seguimiento verificable de cambios. **No es un changelog automático ni un lugar donde mover documentación retrospectiva sin validación.** Las especificaciones consolidadas viven en `openspec/specs/`; los cambios activos, en `openspec/changes/`; los aceptados y archivados, en `openspec/changes/archive/`.

## Flujo estricto con CLI

Requisitos: Node.js compatible y `@fission-ai/openspec` instalado. Ejecutar desde la raíz del repositorio. Antes de actuar, consultar `openspec --help` y la ayuda de cada subcomando de la versión instalada.

```bash
# Preparar herramienta (una vez por entorno)
npm install -g @fission-ai/openspec@latest
openspec --version
openspec list

# Para un cambio nuevo
openspec new change <nombre>
openspec status --change <nombre>
# Crear/editar proposal.md, design.md, specs/<capacidad>/spec.md y tasks.md
openspec validate <nombre> --strict

# Tras implementación, pruebas y aceptación documentadas
openspec archive <nombre> --yes
openspec validate --all --strict
```

La sintaxis y las opciones deben confirmarse en la versión instalada; **no declarar un paso PASS sin ejecutarlo**. El archivado oficial valida las specs, las integra en `openspec/specs/` y mueve la carpeta a `openspec/changes/archive/`. No trasladar manualmente a `archive/` y no usar `--no-validate` para forzar el cierre.

## Criterios de aprobación y cierre

1. **Explore:** revisar `AGENTS.md`, implementación y evidencia real.
2. **Propose:** requisitos comprobables, límites y escenarios; detenerse a esperar aprobación del propietario.
3. **Apply:** implementar solo lo aprobado.
4. **Verify:** pruebas estáticas y en WoW Forever cuando corresponda. Documentar PASS/FAIL/NOT RUN; el código implementado no demuestra por sí solo aceptación en cliente.
5. **Sync:** comparar la implementación con requisitos, actualizar README/docs y registrar resultados en `tasks.md`.
6. **Archive:** ejecutar CLI únicamente si la propuesta está aceptada y las comprobaciones exigidas están cerradas, indicando cualquier excepción expresamente aprobada.

## Aprobación y merge en GitHub

La aprobación de una propuesta OpenSpec **no es autorización para fusionar una PR**. Agentes y colaboradores pueden preparar, revisar técnicamente y actualizar PRs; la fusión de cualquier PR es manual y exclusiva del propietario humano (@hectoresen). Está prohibido activar auto-merge, ejecutar comandos/APIs de merge o usar bypass. Consulta [AGENTS.md](../AGENTS.md).

## Estado de los cambios heredados

- `feat001-general-pvp-dashboard`: implementación y muchas iteraciones visuales registradas, pero el `tasks.md` conserva verificaciones pendientes y la spec incluye decisiones antiguas. Reconciliar con el código y conseguir aceptación explícita antes de archivar.
- `feat002-localization`: español/inglés implementados, pero su checklist mantiene prueba manual pendiente. Validar con el cliente y registrar aceptación antes de archivar.

**No renombrar ni archivar estos cambios automáticamente** hasta comprobarlos. Un cierre retroactivo debe decir expresamente qué evidencia histórica se ha revisado y qué no se puede demostrar.

Más detalles técnicos: [documentación de OpenSpec](https://github.com/Fission-AI/OpenSpec/blob/main/docs/cli.md). <https://github.com/Fission-AI/OpenSpec>
