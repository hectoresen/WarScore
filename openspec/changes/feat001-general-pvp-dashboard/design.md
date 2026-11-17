# Technical design — General PvP dashboard

**Status: DRAFT; no implementation until owner approval.**

## Evidence and source precedence
1. `docs/PVP_STATISTICS.md`: verified Lua APIs, IDs and normalization rules.
2. `docs/GENERAL_VISUAL_SPEC.md`: reference geometry, layers, colors, font sizes, texture plan, states, screenshot QA.
3. `docs/GENERAL_VIEW.md`: approved visual/product direction and tab placement.
4. `UI/General.lua`, `Core/Stats.lua`, `Core/Storage.lua`, `WarScore.toc`: actual existing implementation state.

The target is the **two-row expanded General mockup**, not a flat dashboard. The original PNG is not yet committed; `docs/assets/general-layout-guide.svg` is only a geometry guide. Adding the reference PNG is a prerequisite to claiming pixel-level screenshot parity, not a prerequisite to writing code.

## Data contracts
Read statistics through a guarded adapter in `Core/Stats.lua`; `GetStatistic(id)` may return numeric text, `--`, or unavailable. Keep unknown distinct from zero. Candidate contract:

```lua
{
  honorableKills = number_or_nil,   -- 588, cross-check GetPVPLifetimeStats first return
  pvpDeaths = number_or_nil,       -- 1501
  hkDeathRatio = number_or_nil,    -- only when deaths > 0
  kbDeathRatio = nil,              -- explicitly unavailable pending validation
  duelsWon = number_or_nil,        -- 319
  duelsLost = number_or_nil,       -- 320 (needed for win rate)
  battlegroundsPlayed = number_or_nil, -- 839
  battlegroundsWon = number_or_nil,    -- 840
  bgWinRate = number_or_nil,
  duelWinRate = number_or_nil,
  favoriteBattleground = string_or_nil,
  favoriteBattlegroundPlayed = number_or_nil,
  favoriteBattlegroundTied = boolean
}
```

BG matches IDs: Alterac 53, Arathi 55, Warsong 52, Darkspear 64179. When all are unknown/zero, no favorite. Equal positive maxima: indicate tie, no arbitrary winner. `--` can map to zero **only with documented per-statistic evidence** (duel 319/320 on a character without duels); avoid global coercion. Other counters with `--` remain unknown unless validated. Ratios with unknown inputs/zero denominator render `—`. For percentages use `100*wins/played` only when numerator and denominator are reliable and played>0. Do not mix HK from full lifetime with partial tracking.

## UI construction
- `UI/General.lua`: native frame composition; split into local reusable functions for window, portrait, banner, rank, primary stats, lower cards and tooltips. Avoid coupling data reads to individual draw elements.
- Proposed `UI/GeneralTheme.lua`: coordinate/size/color/asset tokens (only add when implementation begins). The layout specification uses 1199×1312 reference coordinates, outer frame approximately x126 y24 w915 h1188. Convert to frame-local coordinates and scale uniformly.
- Build ornamental borders as native texture slices, icons as individual transparent textures, text via FontStrings, clickable tabs and close button via Buttons. Do not use a single screenshot as the UI.
- Faction-dependent flags and rank badge must not misidentify the active character. Render placeholder only when explicitly marked unavailable.
- Use portrait API/mask only after client compatibility test; if circular masking unsupported, propose a faithful circular overlay crop and record limitation.
- Avoid including unauthorized copyrighted fonts/textures. Record provenance/license for custom assets and test supported formats (`.tga`/`.blp`).
- General and Hoy tab buttons are both present; Hoy has a clearly nonfunctional/coming-later state, without fake daily data. The General tab remains active.
- Provide a method to refresh on relevant client events or reopening; avoid per-frame polling unless proven necessary.

## Character and state boundaries
v1 shows **active character only**. Existing SavedVariables remain compatible. Do not infer other characters' live stats or portraits. A future change can add multi-character navigation and cached snapshots without redesigning the primary visual hierarchy.

## Verification
- Offline deterministic tests for normalization, ratio, percentage, favorite BG, ties and missing data, if a Lua runner is available; otherwise document NOT RUN.
- In-client smoke test: open/close, drag, tabs, portrait, API counters, no Lua errors; compare with native statistics pane.
- Capture at matching UI scale and overlay with reference; audit frame, tabs, portrait, banners, borders, separators, fonts, icons and cards. Record deviations. Do not claim pixel parity without original PNG and screenshot.
- Verify at least one smaller resolution and another UI scale; test empty/unknown counters. No client tests are complete at proposal time.

## Rollback
Revert the implementation commit; keep approved specs and recorded client evidence. No migration/destructive SavedVariables operation in this change.
