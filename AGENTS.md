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
- **Gobernanza:** no aplicar automáticamente normas de otro repositorio (CraftAtlas, reglas de PR, automerge, etc.).

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
- Comprobar sintaxis/paquete, referencias de texturas y que `dist/WarScore.zip` tenga `WarScore/` como única carpeta raíz.
- Indicar versión/commit y separar claramente «verificado offline», «verificado en cliente» y «pendiente».
- Si se cambia funcionalidad, aportar ZIP instalable y solicitar aceptación en el juego antes de cerrar la spec.
