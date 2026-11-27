# WarScore

**Your World of Warcraft Forever PvP journey, at a glance.**

WarScore is a free, open-source PvP statistics addon for **World of Warcraft Forever**. Explore your character's PvP achievements, Honor, rank progression, duels, and battleground performance in one Warcraft-inspired interface—powered by the game's own data.

**Open source (MIT) · No account required · No external servers · English & Spanish**

## General — your PvP overview

Choose between two Warcraft-inspired visual styles in **Settings**. Both display the same real character statistics and share the same functionality.

### Classic Forever

The original ornamental dashboard, with detailed PvP panels and decorative stat cards.

<p align="center">
  <img src="docs/addon%20v0.3.0/WarScore%201.png" width="440" alt="Classic Forever General view in Spanish" />
  <img src="docs/addon%20v0.3.0/WarScore%201%20ENG.png" width="440" alt="Classic Forever General view in English" />
</p>

### Classic Forever Simple

A cleaner, more compact General layout with the same PvP data, gold dividers and Warcraft-themed artwork.

<p align="center">
  <img src="docs/addon%20v0.3.0/War%20Score%201%20SIMPLE.png" width="440" alt="Classic Forever Simple General view in Spanish" />
  <img src="docs/addon%20v0.3.0/War%20Score%201%20SIMPLE%20ENG.png" width="440" alt="Classic Forever Simple General view in English" />
</p>

The **General** tab brings together your character's real portrait, name, level and class, alongside a detailed PvP overview. Switching styles changes the presentation only—not the values or calculations.

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

On your first opening after a new installation, WarScore shows a welcome screen with the four preferences below. Save and open General or choose Not now to finish. You can revisit these preferences at any time in Settings.

<p align="center">
  <img src="docs/addon%20v0.3.0/WarScore%202.png" width="620" alt="WarScore Settings in English with language, interface size and visual style dropdowns" />
</p>

The **Settings** page includes four preference areas:

- **Language:** switch between **English and Spanish** at any time.
- **Interface Size:** choose **75%, 100%, or 125%** (100% is the default compact size).
- **Visual Style:** switch between **Classic Forever** and **Classic Forever Simple** without reloading the game.

- **Faction Appearance:** choose **Horde** or **Alliance** for the banners and the Classic Forever PvP rank plaque.

All four preferences are saved between sessions, and changes take effect immediately.

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

The addon does **not require a website, account, external database, or remote synchronization**. Only local preferences, such as language, interface size, visual style and minimap icon position, are saved. See the [technical PvP statistics documentation](docs/PVP_STATISTICS.md) for API evidence and limitations.

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

**For published versions:** download the latest installable `WarScore-vX.Y.Z.zip` from [GitHub Releases](https://github.com/hectoresen/WarScore/releases) and extract it into `Interface/AddOns/`. The repository source folder remains the canonical development source; development builds do not automatically produce ZIPs. Releases are published manually by the maintainer.

## Commands

| Command | Description |
| --- | --- |
| `/ws` or `/warscore` | Open the General tab. |
| `/ws settings` | Open Settings. |
| `/ws lang en` | Switch to English. |
| `/ws lang es` | Switch to Spanish. |
| `/ws version` | Display the installed addon release version. |
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
