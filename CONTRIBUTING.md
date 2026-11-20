# Contribuir a WarScore

¡Gracias por ayudar a mejorar WarScore! Aceptamos informes de errores, propuestas, traducciones, documentación y pull requests. El **código y la documentación originales se publican bajo MIT**; consulta [LICENSE](LICENSE) y las excepciones de recursos en [ASSET_LICENSES.md](ASSET_LICENSES.md).

## Antes de empezar

Lee el [README](README.md), [AGENTS.md](AGENTS.md), la [documentación](docs/INDEX.md) y las [normas de OpenSpec](openspec/README.md). Comprueba si ya hay un issue o PR sobre tu idea.

WarScore funciona en **WoW Forever** y depende de sus APIs nativas. Una función de WoW Retail puede no funcionar aquí. No propongas datos inventados ni asumas que las métricas históricas se pueden reconstruir desde cero.

## Cómo contribuir

1. Abre un issue o comenta uno existente para describir el problema o la mejora. Para cambios de comportamiento, acordaremos el alcance antes de implementarlo.
2. Haz un fork y crea una rama descriptiva, por ejemplo `fix/honor-display`, `feat/battleground-details` o `docs/installation`.
3. Para nuevas funcionalidades, cambios relevantes de API o interfaz, sigue el flujo de [OpenSpec](openspec/README.md): propuesta, diseño, requisitos y tareas; **espera aprobación explícita del mantenedor antes de implementar**. Si la CLI no está disponible, indícalo y no simules validaciones.
4. Aplica cambios pequeños. Conserva el diseño visual aprobado, usa las APIs reales de Forever y actualiza las traducciones y documentación afectadas.
5. Ejecuta las pruebas que puedas y documenta lo no ejecutado. Para cambios visibles en juego, incluye el resultado de las comprobaciones en WoW Forever, versión del cliente y capturas cuando corresponda.
6. Abre una **pull request hacia `main`**, enlaza el issue y la spec cuando existan y cumplimenta la plantilla. **Deja la PR abierta para que @hectoresen la revise y fusione manualmente.** Aunque las comprobaciones estén correctas, no puedes habilitar auto-merge ni fusionar por tu cuenta.

Las correcciones menores de documentación no necesitan inventar una spec funcional. Los requisitos de revisión son una **política de contribución**, no una afirmación de que el repositorio tenga actualmente reglas de protección de ramas o CI obligatorios.

## Política de revisión y fusión

- **Todas las PRs** (funcionalidad, corrección, documentación o automatización) deben quedar abiertas después de su preparación y validación.
- **La fusión la realiza exclusivamente @hectoresen de manera manual**, después de revisar el cambio. Nadie debe activar auto-merge, ejecutar comandos o APIs de merge, ni saltarse protecciones de `main` en nombre del propietario.
- Los agentes que trabajen con la identidad o credenciales del propietario también están sujetos a esta prohibición. Para imponerla técnicamente, deben usarse credenciales separadas y sin capacidad de bypass.
- Pasar CI significa que una PR está lista para revisión; **no significa autorización para fusionarla**.
- En la entrega, incluye enlace a la PR, resumen, pruebas ejecutadas y pendientes. Espera la decisión del propietario.

## Qué revisar

- **Datos PvP:** precisión, valores no disponibles y no confundir honor actual, muertes con honor o puntos de rango.
- **Interfaz y assets:** respetar las posiciones y los originales suministrados. Antes de agregar gráficos o fuentes, facilitar autor, licencia y fuente de procedencia. Revisar [ASSET_LICENSES.md](ASSET_LICENSES.md).
- **Idiomas:** mantener español e inglés coherentes.
- **Pruebas:** diferenciar verificación offline, pruebas en Forever y aceptación visual del propietario.
- **Publicación:** no modificar manualmente el ZIP de distribución; seguir [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md).

## Informar problemas

Usa las plantillas de **Bug report** y **Feature request**. Para vulnerabilidades, consulta [SECURITY.md](SECURITY.md). Participa respetando el [código de conducta](CODE_OF_CONDUCT.md).

**Idioma:** se aceptan issues y contribuciones en español o inglés; los identificadores técnicos y nuevas especificaciones pueden redactarse en inglés para facilitar colaboración internacional.
