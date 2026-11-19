# WarScore

**Tus estadísticas PvP de World of Warcraft Forever, de un vistazo.**

WarScore es un addon para **WoW Forever** que reúne la información de tu personaje en un panel visual inspirado en la estética clásica de Warcraft. Consulta tus muertes con honor, tu rango PvP, tus resultados en duelos y campos de batalla y mucho más, sin salir del juego.

**Gratis · Sin cuentas · Sin servidores externos · Datos proporcionados por el propio juego**

## Qué puedes ver

### Pestaña General

La pantalla principal muestra el historial PvP del personaje con el que estás jugando.

| Sección | Información |
| --- | --- |
| **Tu personaje** | Retrato, nombre, nivel y clase. |
| **Honor** | Puntos de honor disponibles y límite indicado por el juego. Es tu saldo actual, no todo el honor que has ganado históricamente. |
| **Rango PvP** | Rango actual, próximo rango y puntos de rango (RP/PR) necesarios para progresar, cuando el juego facilita esos datos. |
| **Muertes con honor (HK)** | Total histórico de muertes con honor registradas por WoW. |
| **Muertes PvP sufridas** | Veces que otros jugadores han eliminado a tu personaje. |
| **Ratio HK/D** | Relación entre muertes con honor y muertes PvP sufridas. |
| **Duelos** | Duelos ganados y porcentaje de victorias. |
| **Campos de batalla** | Partidas jugadas, victorias y porcentaje de victorias. |
| **Campo de batalla favorito** | Campo que más has jugado y número de partidas disputadas en él. |

> **HK** significa *Honorable Kills* (muertes con honor). **BG** significa *Battleground* (campo de batalla). Si alguna estadística no está disponible en el cliente, WarScore evita inventar el dato.

### Ajustes y personalización

- **Español e inglés:** cambia el idioma desde **Ajustes → Idioma** o con los comandos de chat.
- **Interfaz integrada en WoW:** marcos ornamentales, retrato del personaje y diseño inspirado en Warcraft.
- **Estilo visual:** el aspecto **Classic Forever** está disponible; el selector de otros estilos se reserva para versiones futuras.
- **Ventana desplazable:** mueve el panel por la pantalla y ciérralo cuando no lo necesites.

### Icono en el minimapa

WarScore añade un botón en el borde del minimapa para acceder rápidamente al addon.

- **Clic izquierdo:** abre o cierra la ventana.
- **Arrastrar:** coloca el icono en el punto del borde del minimapa que prefieras.
- **Posición recordada:** el addon conserva su ubicación para la próxima vez que entres.

## ¿De dónde salen los datos?

WarScore consulta **las APIs y estadísticas nativas disponibles en WoW Forever**, incluyendo los contadores PvP del personaje, el sistema de honor, los campos de batalla, los duelos y la progresión de rango.

Los datos históricos proceden del propio juego: **no empiezan a contarse desde la instalación de WarScore**. Al abrir la vista General se vuelven a consultar para mostrar la información disponible más reciente. El addon no requiere conexión a una web, registro de usuario ni base de datos remota.

Algunos porcentajes y ratios se calculan en el momento a partir de los valores que proporciona WoW. Las preferencias, como el idioma o la posición del botón del minimapa, se guardan localmente.

Para conocer las fuentes, limitaciones y pruebas técnicas, consulta la [documentación de estadísticas PvP](docs/PVP_STATISTICS.md).

## Instalación

1. **[Descarga WarScore.zip](https://github.com/hectoresen/WarScore/raw/refs/heads/main/dist/WarScore.zip)**, el paquete preparado para instalar.
2. Descomprímelo en la carpeta de addons de WoW Forever:
   ```text
   World of Warcraft/_forever_/Interface/AddOns/
   ```
3. Comprueba que existe esta ruta:
   ```text
   Interface/AddOns/WarScore/WarScore.toc
   ```
4. Abre el juego (o escribe `/reload` si ya estás dentro) y utiliza `/ws` o el botón del minimapa.

**Importante:** descarga el archivo `WarScore.zip` enlazado arriba, no el ZIP automático del código fuente de GitHub.

## Comandos

| Comando | Acción |
| --- | --- |
| `/ws` o `/warscore` | Abrir WarScore en General. |
| `/ws settings` | Abrir Ajustes. |
| `/ws lang es` | Cambiar a español. |
| `/ws lang en` | Cambiar a inglés. |
| `/ws version` | Mostrar la iteración de la interfaz. |
| `/wsdiag` | Diagnósticos técnicos para comprobar las APIs del juego. |

## Próximamente

La pestaña **Estadísticas** está visible, pero su contenido avanzado todavía está en desarrollo. Entre las funciones propuestas se encuentran los desgloses de PvP en **mundo abierto**, la comparación con las muertes con honor obtenidas en campos de batalla y estadísticas más detalladas de cada BG.

Solo se incorporarán métricas cuya fuente y significado estén suficientemente verificados en WoW Forever. Consulta el [catálogo de datos y funcionalidades futuras](docs/PVP_DATA_CATALOG.md).

## Compatibilidad y estado

- **Juego:** World of Warcraft Forever.
- **Interfaz del cliente de referencia:** `16001` (Forever 1.60.1).
- **Estado del proyecto:** en desarrollo activo; pueden existir limitaciones propias del cliente.
- **Privacidad:** funcionamiento local, sin servicios externos ni necesidad de cuenta adicional.

WarScore es un proyecto independiente y no está afiliado a Blizzard Entertainment.

## Documentación y desarrollo

Si quieres saber cómo funciona internamente o contribuir al proyecto, el **[índice completo de documentación](docs/INDEX.md)** reúne las guías funcionales, arquitectura, APIs investigadas, especificaciones visuales y proceso de desarrollo.

El código del addon está en [`addon/WarScore/`](addon/WarScore/). Las herramientas de empaquetado se encuentran en [`tools/`](tools/).
