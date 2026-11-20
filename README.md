# WarScore

**Your World of Warcraft Forever PvP journey, at a glance.**

WarScore is a free, open-source PvP statistics addon for **World of Warcraft Forever**. Explore your character's PvP achievements, Honor, rank progression, duels, and battleground performance in one Warcraft-inspired interface—powered by the game's own data.

**Open source (MIT) · No account required · No external servers · English & Spanish**

## General — your PvP overview

<p align="center">
  <img src="docs/addon%20v0.1/WarScore2.png" width="620" alt="WarScore General tab with character portrait, rank progression, Honor, honorable kills and battleground statistics" />
</p>

The **General** tab brings together your character's real portrait, name, level and class, alongside a detailed PvP overview.

| Statistic | What it means |
| --- | --- |
| **PvP Rank** | Your current PvP rank, next rank and Rank Points (RP) progress toward the next level. |
| **Honor** | Your current Honor balance and maximum, as reported by WoW Forever. |
| **Honorable Kills (HK)** | Your lifetime total of honorable kills. |
| **PvP Deaths** | Total deaths caused by other players. |
| **HK/D Ratio** | Honorable kills divided by PvP deaths. |
| **Duels Won** | Total number of duels won. |
| **Battlegrounds Played** | Total battleground matches played. |
| **BG Wins** | Total battleground victories. |
| **BG Win Rate** | Percentage of battleground matches won. |
| **Duel Win Rate** | Percentage of duels won. |
| **Favorite Battleground** | Your most-played battleground and number of matches played. |

The top navigation also includes a **Statistics** tab, reserved for more advanced features in a future update. Use the **X** to close the window or the **gear icon** to open Settings. You can move the main window around the game screen.

> **Accurate game data:** historical PvP statistics are read from the game, so they do not start at zero when WarScore is installed. Honor represents your **current spendable balance**, not lifetime Honor earned. If a reliable value is unavailable, WarScore does not invent it.

## Settings — personalize your experience

<p align="center">
  <img src="docs/addon%20v0.1/WarScore3.png" width="620" alt="WarScore Settings tab with Language selection, Visual Style and Back navigation" />
</p>

The **Settings** page includes two preference areas:

- **Language:** switch between **English and Spanish** at any time. Your choice is saved for future sessions.
- **Visual Style:** **Classic Forever** is the current Warcraft-themed look. Additional visual styles are planned for future releases; this selector is not yet customizable.

Use the **Back** tab to return to General, or close WarScore with the top-right **X**. Settings can also be opened directly with `/ws settings`.

## Minimap button — quick access

<p align="center">
  <img src="docs/addon%20v0.1/WarScore4.png" width="420" alt="Crossed-swords WarScore button on the WoW minimap with a tooltip" />
</p>

WarScore adds a small **crossed-swords icon** with a circular Warcraft-style border to the edge of the minimap.

- **Left-click** to open or close the addon.
- **Drag the icon** around the minimap border to position it wherever you prefer.
- **Your chosen position is remembered** after reloading the game interface.

## Powered by native WoW Forever APIs

WarScore retrieves your statistics using the **native APIs provided by WoW Forever**, including PvP records, the Honor currency, rank progression, duels, and battleground results. It calculates ratios and win rates from those reported values. The General view reads the latest available data when opened.

The addon does **not require a website, account, external database, or remote synchronization**. Only local preferences, such as your language and minimap icon position, are saved. See the [technical PvP statistics documentation](docs/PVP_STATISTICS.md) for API evidence and limitations.

## Installation

The ready-to-install addon lives in [`addon/WarScore/`](addon/WarScore/), including Lua scripts, the `.toc` manifest, textures and fonts. No build step is needed when installing directly from source.

1. Download the addon source from the [`addon/WarScore/` folder](addon/WarScore/) (or clone/download the repository) and copy the **WarScore** directory into:
   ```text
   World of Warcraft/_forever_/Interface/AddOns/
   ```
2. Ensure this exact file exists:
   ```text
   Interface/AddOns/WarScore/WarScore.toc
   ```
3. Enable WarScore in the game's AddOns menu, run `/reload` if necessary, then use `/ws` or the minimap button.

**For published versions:** installable ZIP downloads will be available under [GitHub Releases](https://github.com/hectoresen/WarScore/releases). The repository source folder remains the canonical development source; development builds do not automatically produce ZIPs.

## Commands

| Command | Description |
| --- | --- |
| `/ws` or `/warscore` | Open the General tab. |
| `/ws settings` | Open Settings. |
| `/ws lang en` | Switch to English. |
| `/ws lang es` | Switch to Spanish. |
| `/ws version` | Display the current UI iteration. |
| `/wsdiag` | Inspect native game statistics for diagnostics. |

## Coming soon

The **Statistics** tab is already visible, but its advanced views are **not implemented yet**. Planned work includes open-world PvP summaries, battleground breakdowns, and additional insights based on verified native game data. Follow the [PvP data catalog](docs/PVP_DATA_CATALOG.md) for current research and proposals.

## Compatibility and project status

WarScore targets **World of Warcraft Forever** (reference client **1.60.1**, Interface `16001`). It is actively developed, and some information depends on which APIs the game makes available.

WarScore is an independent community project and is not affiliated with Blizzard Entertainment or the operators of WoW Forever.

## Open source and contributing

WarScore's original source code and documentation are distributed under the [**MIT License**](LICENSE). Contributions, bug reports, and suggestions are welcome. Read the [contribution guidelines](CONTRIBUTING.md), our [Code of Conduct](CODE_OF_CONDUCT.md), or [open an issue](https://github.com/hectoresen/WarScore/issues/new/choose).

Bundled artwork may be subject to separate rights, and the Spectral font retains its own license. Please check [asset licenses and attribution](ASSET_LICENSES.md) before reusing graphical assets.

For technical details, visit the [documentation index](docs/INDEX.md), browse the [addon source](addon/WarScore/), or explore the [development tools](tools/).
