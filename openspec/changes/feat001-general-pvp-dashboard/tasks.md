# Tasks — feat001-general-pvp-dashboard

**Status: APPROVED / IMPLEMENTATION IN PROGRESS. Native-client verification NOT RUN.**

## Approval and prerequisites
- [x] Owner explicitly approves proposal, exclusions and acceptance criteria.
- [ ] Confirm availability of the original approved expanded PNG; commit as `docs/assets/general-approved-reference.png` if supplied.
- [ ] Inventory supported client font/texture/portrait APIs; document what is tested vs assumed.

## Data layer
- [x] Implement guarded `GetStatistic` parsing and per-counter unknown/zero semantics in Core/Stats.lua.
- [x] Implement HK, PvP deaths, HK/D, duel/BG counters, win rates and favorite BG/tie behavior.
- [x] Ensure KB/D and unverified rank remain unavailable; keep current diagnostics functional.
- [ ] Add deterministic tests for numeric strings, `--`, zero denominators, percentages, favorite/ties.

## Native UI
- [ ] Create reusable theme/layout tokens and texture asset manifest with licensing/provenance.
- [x] Build movable frame, header, close button, General tab and adjacent Hoy placeholder.
- [ ] Implement centered active-character portrait, identity, faction ornamentation and rank unavailable state.
- [x] Build HK, HK/D, reserved KB/D, PvP deaths, help labels and separators.
- [x] Build two lower ornamental rows with duels, BG, win rates and favorite BG.
- [ ] Handle refresh, localization-ready labels, long values and alternate UI scales.

## Verification and handoff
- [ ] Run available offline tests and document PASS/FAIL/NOT RUN.
- [ ] Run Forever client smoke test and compare displayed HK/deaths against native panel.
- [ ] Capture same-scale screenshot and compare with approved image; record differences.
- [ ] Run skills/documentation-sync/SKILL.md; update README and technical docs truthfully.
- [ ] Obtain owner acceptance before marking feature complete or archiving the change.

## Implementation note

Initial native frame and live data code committed in Core/Stats.lua and UI/General.lua. **No Lua runner or Forever client test has been executed**; visual textures, exact reference fidelity, portrait masking, multi-resolution QA and acceptance remain outstanding. Current frame is a functional first pass, **not** a faithful final rendering of the selected PNG. In-game tests may reveal compatibility issues.

## Real-client QA evidence — 2026-11-17

Owner supplied an actual WoW Forever screenshot of the first /ws implementation (level 29 Priest). **PASS:** window opens, player name/level/class render, lifetime HK=32, PvP deaths=8, HK/D=4.00, duels won=0, unknown BG metrics and KB/D display as unavailable. **FAIL (visual):** central background and lower cards appear transparent, ornamental borders and separators nearly invisible, portrait is not circularly clipped and ring is misplaced, no banners/laurels/icons, overly large window with weak visual hierarchy. **NOT RUN:** independent Lua automated tests, other resolutions, texture format checks, positive BG/duel counters. The screenshot is proof of basic rendering/data, **not acceptance** of the General UI. Prioritize opaque game-compatible background and actual texture assets, portrait frame/overlay correction, proportion/spacing against target, then re-test in client. Do not mark full in-game acceptance complete.

## Iteration 2 — pending user test

- [ ] Owner installs latest main and tests background, card panels, separators, portrait border and window scale after commit `70aca9f`.
- [ ] Record actual screenshot/error result in `docs/DEVELOPMENT_HANDOFF.md` and this checklist.
- **Changes made, not yet validated:** `WHITE8X8` texture with vertex colors, tooltip-border portrait frame, 0.86 window scale. See `docs/DEVELOPMENT_HANDOFF.md` for complete handoff.

## Iteration 3 — pending client verification

- **Iteration 2 owner screenshot:** dark background, card panels, dividers and scale now render correctly; portrait tracking ring remains misplaced; ornate reference not matched. See `docs/DEVELOPMENT_HANDOFF.md`.
- [ ] Owner tests commit `e845257` in game: confirm tracking ring gone and new portrait border, header, rank plate and ratio divider render.
- [ ] Develop actual circular portrait framing and licensed ornamental texture assets; compare against the target screenshot.
- Automated Lua tests and OpenSpec CLI validation remain **NOT RUN**.
