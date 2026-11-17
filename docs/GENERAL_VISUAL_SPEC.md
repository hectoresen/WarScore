# WarScore — General: especificación visual de alta fidelidad

**Estado:** referencia visual seleccionada por el usuario, especificación de reconstrucción para implementación futura. **NO implica aprobación de implementación actual.** No alterar la UI existente sin autorización. Complementa `docs/GENERAL_VIEW.md` y `docs/PVP_STATISTICS.md`.

## 0. Fuente y precisión

- **Fuente:** segundo boceto ampliado de WarScore, generado en la conversación del 17-11-2026 a partir del boceto original aportado por el usuario. Resolución de imagen **1199 × 1312 px**. Referencia visual de la conversación: versión con dos filas de estadísticas secundarias, «BG GANADOS», porcentajes verdes y «Valle de Alterac».
- **Importante:** el PNG de referencia **aún no está incorporado como binario al repositorio**. Ruta objetivo cuando se añada: `docs/assets/general-approved-reference.png`. No declarar que existe hasta subirlo. La especificación textual y el plano vectorial de guías son utilizables mientras tanto.
- Coordenadas siguientes: **estimaciones visuales medidas sobre la imagen**, no medidas extraídas de un archivo fuente por capas. Tolerancia inicial recomendada ±3–8 px; confirmar con superposición de capturas del cliente. No prometer fidelidad milimétrica sin los assets, la fuente y las restricciones reales del motor.
- No copiar el fondo del mundo que aparece detrás de la ventana: es contexto de escena, no parte del addon. La UI debe superponerse al mundo real.

## 1. Sistema de coordenadas y estructura

Lienzo de referencia: `W=1199, H=1312`; origen (0,0) arriba a la izquierda. **Marco exterior** aprox. `x=126..1041, y=24..1212` (`915 × 1188`), sin contar sombra proyectada. **Área útil** aprox. `x=145..1023` (878 px). **Eje central x≈583**.

Las medidas se expresan primero en píxeles de referencia; en WoW, usar `Frame:SetSize`, `SetPoint` y escalado uniforme `s=min(availableWidth/915, availableHeight/1188, 1)` para conservar proporciones. El tamaño final debe permitir pantallas pequeñas; no aplicar posiciones absolutas de pantalla. La ventana es un frame único movible, anclado al centro; elementos internos anclados al frame, nunca a `UIParent` directamente.

| Elemento | Caja aproximada en PNG (x,y,w,h) | Detalle |
| --- | --- | --- |
| Ventana + borde metálico | 126, 24, 915, 1188 | Relieve gris acero/negro, filo dorado y esquinas ornamentadas |
| Cabecera | 237, 27, 753, 51 | Placa negra horizontal biselada, remates metálicos |
| Emblema superior izquierdo | 117, 0, 133, 128 | Medallón circular solapado, espadas cruzadas, aro dorado |
| Cerrar | 989, 26, 53, 56 | Botón cuadrado metal oscuro, X roja y brillo dorado |
| Pestaña General | 273, 106, 183, 56 | Única pestaña visible en esta imagen, activa, dorada |
| Borde interior de contenido | 141, 156, 888, 1039 | Filetes dobles, remaches, esquinas pequeñas |
| Bandera izquierda | 166, 176, 139, 354 | Tela roja rota, emblema Horda, degradado a negro |
| Bandera derecha | 863, 176, 139, 354 | Espejo compositivo de la izquierda |
| Retrato circular | 475, 156, 213, 205 | Doble/triple aro dorado, orco como placeholder |
| Nombre | 480, 361, 210, 43 | «Krawer», centrado, serif crema |
| Nivel y clase | 469, 404, 234, 29 | «Nivel 60 · Guerrero», centrado |
| Placa rango PvP | 342, 435, 484, 77 | Cinta granate/negro, escudo Horda y laureles |
| Separador bajo rango | 226, 514, 720, 10 | Filete dorado y rombo central |
| Bloque HK | 338, 526, 498, 109 | Etiqueta con laureles; valor dorado más grande |
| Separador HK/ratios | 225, 636, 722, 10 | Línea con rombo central |
| Ratios HK/D y KB/D | 256, 647, 657, 128 | Dos columnas simétricas; división vertical x≈584 |
| Separador ratios/muertes | 224, 773, 722, 10 | Línea con rombo |
| Muertes PvP | 374, 790, 419, 88 | Etiqueta salmón y número rojo |
| Separador antes del pie | 224, 877, 722, 10 | Línea con rombo |
| Tarjeta inferior fila 1 | 162, 894, 837, 134 | Marco rectangular ornamental, 3 columnas |
| Tarjeta inferior fila 2 | 162, 1043, 837, 127 | Marco rectangular ornamental, 3 columnas |
| Borde inferior | 130, 1170, 907, 41 | Cornisas, esquina y sombra |

### Subcuadrículas inferiores

Fila 1: separadores verticales en `x≈443` y `x≈753`. Columna 1: icono de espadas en `x≈206..277`, título «DUELOS GANADOS», valor «487». Columna 2: icono de banderas cruzadas `x≈465..534`, título «CAMPOS DE BATALLA JUGADOS», valor «1.263». Columna 3: icono trofeo `x≈786..846`, título «BG GANADOS», valor «810».

Fila 2: separadores `x≈382` y `x≈613`. Columna 1: icono hachas cruzadas, «WIN RATE BG», «64,1 %» verde. Columna 2: icono espadas, «WIN RATE DUELOS», «82,3 %» verde. Columna 3: banderín azul/oro, «CAMPO DE BATALLA FAVORITO», «Valle de Alterac» y subtítulo «432 veces jugado». El nombre debe soportar localización y truncamiento razonable, con tooltip de texto completo.

## 2. Paleta visual estimada

| Token | Color aproximado | Uso |
| --- | --- | --- |
| `backgroundDeep` | `#100D0B` | Fondo central casi negro |
| `backgroundPanel` | `#21170F` | Tarjetas inferiores, degradado/textura |
| `steelShadow` | `#171819` | Borde exterior |
| `steelHighlight` | `#89847B` | Cantos biselados metálicos |
| `goldDark` | `#765018` | Bisel y sombra de oro |
| `goldEdge` | `#C78B20` | Contornos y líneas |
| `goldBright` | `#F7C44B` | HK protagonista, brillos |
| `parchment` | `#E9D5A4` | Texto principal y valores secundarios |
| `redDeath` | `#F26C62` | Muertes PvP sufridas |
| `winGreen` | `#75DD3C` | Porcentajes de victoria |
| `bannerRed` | `#67100B` | Banderas de Horda |
| `rankBurgundy` | `#410C08` | Fondo placa de rango |

**Son muestras aproximadas**: la fidelidad viene sobre todo de las texturas, sombras, gradientes, bordes y detalles pintados, no de colores sólidos.

## 3. Tipografía

- Estética: serif fantástica de Warcraft, **no sans-serif web**. Preferir fuentes incluidas en el cliente y permitidas por su motor; evaluar `Fonts\\FRIZQT__.TTF` (Friz Quadrata) y otras rutas disponibles en Forever. **No asumir que una ruta o fuente existe sin probarla.** No distribuir fuentes ajenas.
- Título «WarScore»: serif dorada ~37–40 px de referencia, sombra oscura.
- Pestaña: ~28 px; nombre del personaje ~34 px; nivel/clase ~24 px.
- Rango: etiqueta ~19 px, valor ~27 px, dorado.
- HK: encabezado ~29 px, cifra ~79–85 px, brillo amarillo/dorado y sombra negra; mayor jerarquía.
- Ratios: títulos ~28 px, valores ~55–61 px, microcopy cursivo/serif ~20–22 px, centrado en dos líneas.
- Muertes: título ~28 px, valor ~72 px, rojo con glow muy controlado.
- Tarjetas: títulos ~20–23 px, cifras ~42–47 px; porcentajes verdes ~33–39 px; nombre de BG ~26–30 px; partidas ~19–21 px.
- Todo el texto real debe renderizarse con `FontString` (no horneado en imágenes). Localización, espaciado, separadores numéricos y ajuste de anchura son dinámicos.

## 4. Texturas y componentes: plan de reproducción

**La imagen de referencia NO es una textura de fondo que deba pegarse entera**: contiene personaje, valores y texto ficticios. Construir la pantalla en capas.

| Capa | Técnica WoW recomendada | Restricciones |
| --- | --- | --- |
| Fondo oscuro | `Texture` repetible/atlas, degradados si los soporta el cliente | Evitar bandas visibles; opacidad permite integración con WoW |
| Marco metálico | Texturas de 9-slice o 8 bordes + 4 esquinas, `SetTexture`, `SetTexCoord` | No estirar esquinas; mantener ancho constante al escalar |
| Placa de cabecera | Textura con extremos ornamentales + relleno central | Texto independiente |
| Botón cerrar | `Button` con estados normal/highlight/pushed, hitbox real | No dibujar una X sin interacción |
| Emblema de espadas | Asset circular específico, overlay con borde | Solapa cabecera sin romper drag |
| Pestañas | `Button` con estados seleccionado/no seleccionado | **Añadir «Hoy» a la derecha de «General»**, según decisión funcional anterior; la imagen solo muestra General |
| Banderas laterales | Dos texturas con transparencia alfa y bordes de tela rasgada | Variante de facción; no mostrar iconografía Horda a Alianza sin decisión |
| Retrato | `SetPortraitTexture` o API probada + máscara circular/overlay con aro | Placeholder orco **no** es el retrato real; para personajes offline usar snapshot disponible o estado explícito |
| Placa PvP | Textura ornamentada de cinta, laureles y escudo | Rango real solo si la API está verificada; no mostrar «Señor de la Guerra» ficticio |
| Laureles | Texturas izquierda/derecha con transparencia | Alineación simétrica |
| Separadores | Textura de línea dorada con diamante central | No usar bordes CSS; textura escalable horizontalmente |
| Tarjetas | Borde 9-slice + textura interior oscura, sombras | Iconos separados del texto; filas independientes |
| Iconos | Texturas/atlas propios o iconos nativos con licencia adecuada | Espadas, banderas, trofeo, hachas, banderín |
| Ayudas `ⓘ` | `Button`/frame con tooltip al hover | Explicar HK/D y KB/D con definiciones reales |

**Formato de assets:** investigar soporte real de `.tga`, `.blp`, dimensiones y canales alfa en Forever; crear texturas separadas y nombradas (no depender de `.png` cargable dentro del juego). Propuesta de rutas: `Media/General/frame_*.tga`, `header_*.tga`, `banner_horde_*.tga`, `rank_*.tga`, `divider_*.tga`, `card_*.tga`, `icon_*.tga`. Estos nombres son contratos propuestos, **no archivos existentes**.

## 5. Capas de render y API

Orden de dibujo recomendado: `BACKGROUND` (fondo), `BORDER` (marcos, tarjetas, banners), `ARTWORK` (retratos, iconos, placa, laureles), `OVERLAY` (brillos, rombos, texto, hover), tooltips por encima. Usar subframes si hace falta controlar orden. Comprobar que el retrato no sobresale visualmente de su máscara y que los bordes no tapan texto. No usar un único PNG para todos los elementos interactivos.

Se recomienda declarar una tabla `GeneralLayout` de tokens y cajas de referencia (o un módulo `UI/GeneralTheme.lua` **cuando se apruebe implementar**) con `x/y/w/h`, `colors`, `fontSizes`, `texturePaths`, `anchors`. Convertir las coordenadas desde el origen del marco: `localX=x-126`, `localTop=y-24`. En WoW `SetPoint("TOPLEFT", parent, "TOPLEFT", localX*s, -localTop*s)`; no usar la Y positiva de la imagen directamente. **No modificar el código UI todavía**.

## 6. Estados de datos que afectan al diseño

- Datos del boceto **ficticios**: 12.845 HK, 3,42 HK/D, 1,18 KB/D, 3.756 muertes PvP, 487 duelos ganados, 1.263 BG jugados, 810 BG ganados, 64,1 % BG, 82,3 % duelos, Valle de Alterac 432 veces. El diseño **no implica** que esos datos existan en el cliente.
- **KB/D**: bloqueado hasta aclarar la semántica de `GetStatistic(1487)`; mantener el espacio visual, pero mostrar `—`/«No disponible» si no se puede calcular de forma honesta.
- Rango PvP: `GetPVPLifetimeStats()` segundo valor no validado como rango visible; estado vacío sin inventar título.
- Win rates sin partidas/duelos: `—` (no `0%` ficticio).
- BG favorito sin partidas: `—` y número `0` o estado vacío consistente; empates: indicar empate, no inventar ganador.
- Duelos sin actividad: `GetStatistic(319/320)` devolvió `--` mientras UI nativa muestra cero; normalización específica contrastada.
- Multipersonaje: retrato/identidad y valores corresponden al personaje seleccionado; los offline pueden mostrar datos cacheados y no siempre retrato dinámico.
- Valores grandes y cadenas largas: reservar anchura, probar 6–9 dígitos, nombres de BG traducidos, escalado de `FontString` y no solapar iconos.

## 7. Validación de fidelidad antes de aprobar implementación

1. Conseguir el PNG de referencia en `docs/assets/general-approved-reference.png` (pendiente de subida).
2. Generar captura del addon a la **misma resolución y escala visual** que la referencia; superponer al 50 % de opacidad para revisar geometría.
3. Validar sucesivamente: contorno y cabecera → pestañas → retrato y banderas → rango y HK → ratios y muertes → tarjetas e iconos → tipografía y brillos.
4. Para cada componente, comparar posición, ancho/alto, grosor de borde, radios/esquinas, contraste, sombra, iconografía, jerarquía y alineación.
5. Revisar en distintas resoluciones y UI Scale; asegurar botones accesibles, tooltip legible y sin recortes.
6. **No declarar «idéntico» hasta revisar capturas reales**. Los efectos pintados del boceto pueden requerir assets originales y aproximaciones del motor.
7. El agente de implementación debe registrar diferencias inevitables y solicitar aprobación antes de sustituir elementos ornamentales por alternativas simplificadas.

## 8. No desviarse de la referencia

No transformar la vista en dashboard web, no sustituir las dos filas ornamentales por tarjetas planas, no eliminar banderas/laureles/diamantes, no cambiar a tipografía sans-serif, no desplazar el retrato del centro, no alterar el orden principal HK → ratios → muertes → complementarias. La pestaña «Hoy» se añade a la navegación **sin cambiar** la composición de General. **Las decisiones futuras de producto prevalecen sobre los valores ficticios de la imagen.**
