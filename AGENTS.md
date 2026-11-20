# WarScore — instrucciones para agentes

> Leer antes de modificar código, interfaz, documentación o assets. Fuente de verdad: **código vigente** y resultados observados en **WoW Forever**; las notas de iteraciones anteriores no prueban el comportamiento actual.

## Contexto
WarScore es un addon Lua nativo y local para WoW Forever (Interface 16001). Código instalable en `addon/WarScore/`: `Core/` consulta/normaliza datos, `UI/` presenta la interfaz, `Media/` contiene recursos visuales. `WarScore.toc` determina la carga. No añadir red, bases de datos remotas ni datos PvP inventados.

## Lecturas iniciales
1. [README.md](README.md) y [docs/INDEX.md](docs/INDEX.md).
2. [docs/PVP_STATISTICS.md](docs/PVP_STATISTICS.md) para evidencias y limitaciones de APIs.
3. [docs/GENERAL_VIEW.md](docs/GENERAL_VIEW.md) y [docs/GENERAL_VISUAL_SPEC.md](docs/GENERAL_VISUAL_SPEC.md) antes de tocar diseño.
4. [openspec/README.md](openspec/README.md) y el cambio OpenSpec correspondiente.
5. [docs/DEVELOPMENT_HANDOFF.md](docs/DEVELOPMENT_HANDOFF.md) para continuidad y pruebas históricas; no asumir que sus últimas notas siguen vigentes.

## Reglas innegociables
- **APIs:** no asumir compatibilidad con WoW Retail. Diferenciar identificada, probada en cliente y contrastada con la interfaz nativa. Valores desconocidos no son cero por defecto.
- **Datos actualizados:** al abrir General deben consultarse de nuevo los datos nativos. Se permiten optimizaciones de consultas redundantes, no una caché que presente datos obsoletos.
- **Diseño:** preservar arte, jerarquía, tamaños y posiciones aprobados. No redibujar ni sustituir recursos proporcionados por el propietario sin autorización. Pedir assets faltantes; se permite convertir/ajustar los originales sin alterar su contenido artístico.
- **Cambios:** no añadir características ni modificar comportamiento fuera del alcance aprobado; no confundir pruebas automatizadas con aceptación visual en el juego.
- **Documentación:** README para jugadores; detalles de IDs y pruebas en docs; entregas e iteraciones en el handoff, evitando trasladar historiales interminables a documentos de portada.
- **Contribuciones:** seguir [CONTRIBUTING.md](CONTRIBUTING.md). Código y documentación originales bajo MIT; consultar [ASSET_LICENSES.md](ASSET_LICENSES.md) antes de reutilizar recursos gráficos.
- **Gobernanza:** no aplicar automáticamente normas de otro repositorio (CraftAtlas, reglas de PR, automerge, etc.).

## Control de PR y merge — exclusivo del propietario

- Los agentes y colaboradores **pueden crear ramas, hacer commits en esas ramas, abrir y actualizar pull requests**, responder comentarios y corregir errores de CI.
- **PROHIBIDO para agentes:** fusionar PRs, activar o programar auto-merge, ejecutar `gh pr merge`, llamar a APIs de merge, activar `--auto`, hacer push directo a `main` o usar bypass de reglas para fusionar. No cerrar una PR como sustituto del merge.
- **Solo el propietario humano (@hectoresen) revisa y ejecuta manualmente el merge.** Que CI esté verde, que exista una aprobación anterior o que el agente use credenciales con permisos Admin **no autoriza** a fusionar.
- Si el agente tiene habilitada una herramienta que pueda fusionar, **no utilizarla**. Entregar el enlace a la PR, pruebas PASS/FAIL/NOT RUN y riesgos, y detenerse esperando la decisión humana.
- Las PRs generadas por agentes deben quedarse abiertas. No habilitar automatismos de fusión en workflows, bots, scripts, instrucciones o herramientas de agente.

**Límite de seguridad:** estas instrucciones son una política de trabajo; una cuenta o token con permisos administrativos todavía podría técnicamente hacer bypass. Configurar los agentes con una identidad independiente y permisos reducidos es necesario para una barrera efectiva.

## OpenSpec — flujo obligatorio para cambios funcionales
1. Explorar código, evidencia y specs existentes.
2. Crear propuesta mediante CLI de OpenSpec, documentar alcance, diseño, requisitos verificables, tareas y riesgos.
3. **Esperar aprobación explícita del propietario** antes de implementar.
4. Implementar y comprobar; indicar PASS, FAIL o NOT RUN por prueba.
5. Sincronizar documentación y verificar mediante CLI.
6. **Archivar con el comando oficial solo tras aceptación y validación.** El archivado debe consolidar los requisitos en `openspec/specs/`. No mover carpetas a mano ni fingir ejecución de comandos.

Los cambios previos al uso disciplinado de OpenSpec pueden reconstruirse como **documentación retrospectiva**, etiquetada expresamente como tal; nunca atribuirles aprobaciones, ejecuciones de CLI o QA inexistentes.

Comandos y condiciones: [openspec/README.md](openspec/README.md). Para sincronización: [skills/documentation-sync/SKILL.md](skills/documentation-sync/SKILL.md).

## Entrega y verificación
- Comprobar sintaxis, referencias de texturas y la carpeta instalable `addon/WarScore/`. El ZIP versionado se genera únicamente durante la publicación manual de una release.
- Indicar versión/commit y separar claramente «verificado offline», «verificado en cliente» y «pendiente».
- Si se cambia funcionalidad, entregar el código actualizado en la rama para probar en el juego y solicitar aceptación antes de cerrar la spec. Los agentes **nunca** deben ejecutar el workflow manual de publicación de releases.
