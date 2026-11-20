# Technical design — visual style system

**Status:** Proposed design, not implementation.

## Existing state (verified against main 2026-11-20)

- `addon/WarScore/UI/General.lua` builds the movable frame, ornamented General view, a Settings page, and the native Settings dropdowns. It currently hides/shows collections of rendered children for view switching.
- The Settings style dropdown is disabled and displays `Classic Forever`.
- `Core/Stats.lua` exposes `ns.Stats.ReadHistorical()`; identity and stats are refreshed from the client when General is opened.
- `Core/Localization.lua` owns language dictionaries and refresh listeners.
- `WarScoreDB.settings` stores language, interface scale, and minimap preferences; missing UI scale defaults to 100%, where 100% = frame scale `0.7179`.
- `WarScore.toc` explicitly determines file load order. Packaging tools discover referenced media from Lua; assets must be present under `addon/WarScore/Media`.

## Architecture

### 1. Registry / stable selection

Introduce a small dedicated style registry (suggested `UI/Styles/Registry.lua`; final load order must be verified before code changes) with immutable IDs:

| Stable ID | Display name | View |
| --- | --- | --- |
| `classic-forever` | Classic Forever | Existing General |
| `classic-forever-simple` | Classic Forever Simple | New General |

Persist `WarScoreDB.settings.visualStyle` (exact key specified by this change). The ID is never derived from labels. Missing, invalid, or deleted IDs use the default `classic-forever` without loss of other settings. Localization resolves labels, and renaming a display label has no impact on stored IDs. Only currently implemented/registered styles may be selected.

### 2. Shared shell and per-style General content

Build the outer window ONCE: header, flags, border, tabs, X, gear and the existing Settings page. Host General in a single dedicated content layer so both style views can be attached within that layer and keep the parent shell untouched.

The existing Classic Forever General renderer should be extracted without redesigning or shifting its approved geometry. The new Classic Forever Simple renderer is independent and composed from supplied art. Do not duplicate the shell's textures or Settings frame in either renderer.

Suggested interfaces, subject to the available Forever API:
- `StyleRegistry.Get(id)` and `StyleRegistry.Resolve(id)`
- style descriptor `id, labelKey, buildGeneral(host)`
- view `Show()/Hide()` or equivalent parent-frame visibility; `Refresh(snapshot)` for live data.
- `ApplyStyle(id)` updates active content, dropdown selection and SavedVariables atomically; same-id selection is a no-op.

The visible renderer alone receives pointer events. On change, hide/deactivate the old renderer before showing the new one; do not accumulate additional OnShow, refresh or language listeners per transition.

### 3. Shared stats snapshot

One source of truth: continue to call native stats/identity logic at the normal refresh boundaries. The active renderer receives the same snapshot/formatting rules; no style-specific calls for alternative statistics, altered HK/D, missing-value coercion, fake figures or independent caches. Ensure a style change refreshes the new visible renderer immediately, avoiding stale UI.

Cross-style equivalent metrics include character portrait/name/level/class; PvP rank/progression (including already exposed rank points where available); lifetime HK, current/max Honor, HK/D, PvP deaths, duels won, BG played/won, BG and duel win rates, favorite BG and match count. Where a value is unknown or unsupported, use the existing presentation semantics.

### 4. Settings and persistence

Replace the style selector's disabled state with two enabled entries. Preserve its geometry, visual scale, enabled behaviors of other dropdowns, language selector and 75/100/125% size selection. The style choice applies immediately from Settings, without reload, and remains active through closing/reopening the window and through `/reload` and relog.

Changing language re-renders the visible renderer and labels without changing the stable style ID. Changing scale scales the *shared* parent frame and both presentations uniformly. Main window interactions (X, Escape, minimap, gear, Back, movement) continue to work.

### 5. Simple visual composition

Target the definitive owner screenshot: same outer ornamental window, Horde banners, header/tabs, centered circular portrait and character identity, compact rank plate, thin gold separators and a left-caption/right-value statistics layout. The HK total is the dominant number; honor, deaths and win-rate values retain appropriate hierarchy and accents. The favored BG name and played count occupy the final row. Preserve source statistics and localized copies.

Do not try to reproduce the target by reusing a screenshot as a texture. All dynamic values/names remain Lua text and game data. Required art assets are to be supplied by the owner; integrate source PNGs faithfully and convert to a tested client-supported texture format with alpha as needed. Determine exact dimensions/coordinates with the user-supplied source files, not arbitrary estimates.

## Implementation risks and mitigations

- **Shared-frame regression:** extraction may change draw order or anchors; compare Classic Forever before/after screenshots at 100%.
- **Layering/hitboxes:** inherited frame overlays may swallow dropdown, tab or close interactions; inspect strata and pointer regions.
- **Stale/duplicated data:** centralize refresh and ensure no duplicate registered callbacks.
- **Client API differences:** use only established compatible Lua APIs / explicit fallbacks; avoid unsupported Retail-only calls.
- **Packaging:** new Lua files must be ordered in `.toc` and image dependencies must be included by release tooling.
- **Asset fidelity and localization:** long text and variable values may clip; test Spanish/English with realistic numbers and BG names.
- **Screenshot gaps:** if screenshot differs from current shared chrome labels or hides a current metric, resolve explicitly before shipping instead of silently dropping functionality.

## Verification strategy

1. Static syntax (`luac5.1 -p`), available unit/regression tests, asset existence/alpha, TOC/load order and release package test.
2. Registry scenarios: default/unknown ID, persistence, rename-invariant selection, repeated switching, stable listeners.
3. Functional parity: identical sampled stats, formatting and unknown states for both renderers.
4. Client UI: switch both directions in one session, relog/reload, settings in ES/EN, 75/100/125%, all shared buttons and navigation.
5. Owner-guided visual fidelity comparison with the definitive screenshot and individual PNG assets.
6. Do not archive OpenSpec or claim client acceptance before owner approval.

## OpenSpec workflow limitation

The OpenSpec CLI is not available in the current execution environment; do not mark `openspec validate --strict` as passed until run in an environment with the official CLI. Proposal files are prepared for review, not applied.
