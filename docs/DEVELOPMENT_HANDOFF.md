# WarScore — live development handoff

**Last updated:** 2026-11-17 (iteration 3). **Active work:** `feat001-general-pvp-dashboard` — OWNER APPROVED, implementation IN PROGRESS, NOT accepted. **Current branch:** `main` (all changes committed directly to main by the chat assistant so far; do not claim a feature branch exists).

## Read in this order
1. `AGENTS.md`, `openspec/README.md` — lightweight SDD and approval boundaries.
2. `openspec/changes/feat001-general-pvp-dashboard/{proposal.md,design.md,tasks.md,specs/general-dashboard/spec.md}`.
3. `docs/PVP_STATISTICS.md` — IDs, tested results, parsing and unknown semantics.
4. `docs/GENERAL_VIEW.md`, `docs/GENERAL_VISUAL_SPEC.md`, `docs/assets/general-layout-guide.svg` — target UI and coordinates.
5. `Core/Stats.lua`, `UI/General.lua`, `Core/Bootstrap.lua`, `WarScore.toc`.

## Working agreement with owner
Iterate in the **same current development line (`main`)**. Assistant commits one small focused change, owner downloads `https://github.com/hectoresen/WarScore/archive/refs/heads/main.zip`, replaces addon and tests `/ws` inside WoW Forever, shares screenshot or error; assistant documents outcome and next step here and in OpenSpec tasks. **Never declare client QA passed without owner's real evidence.** Another agent can resume by reading this file and current GitHub code, not by relying on chat history.

## Current implementation
- `Core/Stats.lua`: reads lifetime HK 588, PvP deaths 1501, duels 319/320, BG played/won 839/840, favorite BG among 53/55/52/64179, HK/D and win rates. KB/D and rank unavailable intentionally.
- `UI/General.lua`: `/ws` or `/warscore` opens movable native UI with character portrait/identity, primary stats, two rows of cards and nonfunctional Hoy button. **This is a rough prototype, NOT the approved ornamental design.**
- `Core/Diagnostics.lua`: existing `/wsdiag` diagnostics; preserve.
- No original expanded mockup PNG committed; `docs/assets/general-layout-guide.svg` is **only** a vector measurement guide. Source screenshot exists in earlier chat; obtain/upload original PNG for proper comparison.
- No automated Lua tests or CLI OpenSpec validation executed so far. OpenSpec structure was authored manually.

## Actual client test #1 — owner screenshot (2026-11-17)
Environment: WoW Forever 1.60.1; character Krawer, level 29 Priest. Screenshot supplied in conversation, **not uploaded to repository**.
- **PASS observed:** /ws renders, character name/level/class; HK=32, PvP deaths=8, HK/D=4.00; duels won=0; unavailable BG and KB/D displayed as dashes.
- **FAIL observed:** background appears transparent, cards and separators invisible, incorrect portrait ring (floating offset), world visible behind UI, oversized and dispersed layout, no ornamental assets.
- **NOT RUN:** client tests at other scales/resolutions, positive BG/duel values, automated Lua tests, image parity, actual asset support.

## Iteration #2 — client-tested by owner
Git commit: `70aca9f02c41ac37fa701354c3ef80bb6561726d` (following earlier incremental commits).
- Changed flat color textures to `Interface\\Buttons\\WHITE8X8` + `SetVertexColor` to address transparent background/cards/lines in this client.
- Replaced inappropriate minimap tracking ring with portrait border using `Interface\\Tooltips\\UI-Tooltip-Border`.
- Applied `window:SetScale(0.86)` and fixed initial window height to 990.
- **OWNER SCREENSHOT #2: PASS** for dark background, visible cards, separators and improved overall scale. **FAIL** for portrait ring (still floating offset), insufficient Warcraft ornamentation and simplistic card styling. Screenshot exists in chat but is not stored in GitHub.
- Known risk: portrait still uses square texture; circular clipping/mask not implemented. Frame may still be too large. WoW native texture support must be confirmed.

## Iteration #3 — committed, AWAITING OWNER TEST

Git commit: `e845257cf70957f56eefd26c555c35f57aafdae5`.
- Removed `Interface\\Minimap\\MiniMap-TrackingBorder`, **confirmed in source** to be the cause of the misplaced gold ring; replaced with centered tooltip border as a temporary **square** frame. True circular mask still not implemented.
- Added darker header plate, rank plate and vertical separator between HK/D and KB/D.
- **NOT TESTED** in Forever yet. The selected ornate reference is still far away; no licensed texture asset pack has been added.

## Exact next actions for any agent
1. **Wait for owner screenshot of iteration #3.** Check that floating gold ring is gone, portrait is framed by a stable square border, header and rank plate display, central ratio separator is visible; record observed PASS/FAIL with date.
2. The `WHITE8X8` + vertex-color technique is now supported by the owner's screenshot; keep it for opaque panels. Do not reintroduce minimap tracking border for portrait.
3. Then improve layout proportions and asset pipeline toward reference; ensure readable second row, no action-bar overlap, real faction banners and ornaments, correct portrait framing.
4. Add Lua deterministic tests when runtime available, then run; don't mark NOT RUN as PASS.
5. Update this file and `tasks.md` after every test/commit, and run `skills/documentation-sync/SKILL.md` before declaring implementation complete.
6. Keep KB/D, rank, Hoy functional content, multi-character selector out of scope or unavailable as approved. Do not fabricate data.
7. Keep the spec open until owner accepts **both** real data and visual fidelity.

## Current user instruction
The owner explicitly wants ongoing incremental development, in-game testing feedback and a durable step-by-step agent handoff because ChatGPT conversations have context limits. This document is the **entry point for future chats/agents**.
