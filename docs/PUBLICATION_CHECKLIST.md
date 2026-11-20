# WarScore — auditoría de publicación (20/11/2026)

## Estado

**Repositorio público; presentación pública condicionada.** Esta revisión comprueba estructura, documentación y coherencia básica con el código accesible. No incluye ejecución en WoW Forever, escaneo completo de credenciales a través de todos los commits ni validación real de OpenSpec.

## Realizado en esta revisión

- README para jugadores y enlaces de documentación ya disponibles.
- `AGENTS.md`: instrucciones actualizadas según comportamiento, requisitos de evidencia y OpenSpec estricto.
- `docs/FUNCTIONAL.md`, `ARCHITECTURE.md`, `INSTALLATION.md`, `INDEX.md`: información obsoleta sustituida/organizada.
- `openspec/README.md`, `config.yaml`, skill documental: flujo de propuesta, CLI, validación y archivado; sin afirmar pasos no ejecutados.
- Eliminados dos `:Zone.Identifier` de Windows e incluida exclusión para futuras incorporaciones.

## Pendientes antes de promocionar el repositorio

- [ ] **Licencia:** GitHub no declara una licencia para el repositorio. Elegir expresamente una para el código y aclarar las condiciones del arte y la atribución de terceros. No publicar con expectativas de reutilización sin resolverlo.
- [ ] **Descripción de GitHub:** actualmente promete `daily performance`. Cambiar por una descripción centrada en General, estadísticas PvP históricas, honor, duelos y BG; la vista Estadísticas aún está pendiente.
- [ ] **ZIP:** reconstruir y comprobar `dist/WarScore.zip` desde la versión final; ejecutar smoke test en Forever (incluido minimapa, idiomas, ajustes y datos tras reabrir).
- [ ] **OpenSpec feat001:** reconciliar spec y tareas antiguas con la implementación, comprobar excepciones y registrar aceptación.
- [ ] **OpenSpec feat002:** cerrar la prueba manual de idioma y la aceptación.
- [ ] **CLI de OpenSpec:** ejecutar validación real, archivar mediante comando oficial y comprobar que los requisitos quedan en `openspec/specs/`. No hacer movimiento manual de carpetas.
- [ ] **Recursos antiguos:** auditar referencias de TGA y empaquetado antes de borrar assets legados; conservar originales/licencias y evitar romper versiones ya distribuidas.
- [ ] **Historial sensible:** realizar una búsqueda de secretos en el historial completo, no solo por nombres de archivos presentes.
- [ ] **Documentos históricos:** mantener `DEVELOPMENT_HANDOFF.md` y tareas antiguas como evidencia técnica, diferenciados de guías actuales.

## Comandos previstos para un entorno con CLI

```bash
npm install -g @fission-ai/openspec@latest
openspec --version
openspec list
openspec validate feat001-general-pvp-dashboard --strict
openspec validate feat002-localization --strict
# Solo después de reconciliar requisitos y obtener aceptación:
openspec archive feat001-general-pvp-dashboard --yes
openspec archive feat002-localization --yes
openspec validate --all --strict
```

**Estado de comandos en esta auditoría: NOT RUN.** La CLI no está instalada en el entorno de ejecución disponible y la instalación por red no es posible. No atribuir estos comandos a la revisión actual.

## Política para histórico retrospectivo

Se pueden redactar especificaciones de funcionalidades ya existentes, siempre que cada una declare **reconstrucción retrospectiva**, fuente en el código, pruebas realmente observadas y aceptación pendiente donde proceda. No simular que el cambio se desarrolló inicialmente bajo OpenSpec. Archivar únicamente con la CLI y evidencia verificable.

## Resultado

La documentación pública es significativamente más coherente. **No declarar aún las dos specs heredadas como archivadas ni la publicación como release plenamente validada.**
