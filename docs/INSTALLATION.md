# Installation and verification — WarScore

## For players

1. Open [WarScore Releases](https://github.com/hectoresen/WarScore/releases) and download the latest `WarScore-vX.Y.Z.zip` file attached to a published release (when available).
2. Extract the ZIP directly into `World of Warcraft/_forever_/Interface/AddOns/`. The archive already has a single `WarScore/` root.
3. Verify that `Interface/AddOns/WarScore/WarScore.toc` exists. Do not end up with `WarScore/WarScore/`.
4. Enable WarScore in WoW Forever, use `/reload` if necessary, then open with `/ws` or the minimap button.

To test unreleased development code, copy the [`addon/WarScore/`](../addon/WarScore/) folder instead. Do **not** download the automatically generated GitHub **Source code** ZIP as an installable release.

## Quick in-game checks

- General shows the character portrait, level, PvP statistics and rank information without Lua errors.
- Compare honorable kills, PvP deaths and honor against the corresponding native WoW Forever views.
- Open and drag the minimap button, then verify its saved position after `/reload`.
- Switch languages in Settings and verify persistence after reload.
- Check Close and Back from Settings to General.

Unknown native statistics must not be presented as fabricated numbers. The advanced **Statistics** tab is not implemented yet.

## For contributors and maintainers

- Work directly in `addon/WarScore/` and use PRs; the owner reviews and merges manually.
- Release packaging runs **only** through GitHub Actions `Publish WarScore Release`, manually dispatched by @hectoresen from `main`, with a patch/minor/major choice.
- The release package contains only the addon runtime; the packaged `.toc` receives the release version without modifying the tracked source.
- `/ws version` reports the UI iteration, **not necessarily the published semantic release version**.
- Automated tests do not substitute for in-client gameplay and visual verification.

See [development](DEVELOPMENT.md), [PvP data contract](PVP_STATISTICS.md) and [OpenSpec](../openspec/README.md).
