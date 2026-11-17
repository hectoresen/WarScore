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

## Iteration 4 — pending client verification

- **Iteration 3 owner screenshot:** centered square portrait, ring fixed, vertical ratio divider visible; title disappeared and rank label is obscured by child frame layers; stats remain correct.
- [ ] Owner tests commit `f76b559`: WarScore title and rank readable, all six card borders visible, (i) glyphs render without squares.
- [ ] Next: proper circular portrait and actual ornate texture assets; screenshot comparison with source mockup (PNG not yet in repo).
- Automated tests and client visual acceptance remain **NOT RUN / NOT ACCEPTED**.

## Iteration 5 — pending client verification

- **Iteration 4 owner screenshot:** title/rank/card borders/(i) render, stats stable; square portrait and missing ornate assets remain.
- [ ] Owner tests commit `170abf6` and reports whether all six provisional native card icons load and labels fit.
- [ ] Replace provisional iconography with vetted Warcraft-compatible assets; obtain approved PNG and implement real circular portrait crop if supported.
- No final UI acceptance; automated tests still NOT RUN.

## Iteration 6 — pending client verification

- **Iteration 5 owner screenshot:** all six native PvP icons render and no text/value overlaps; historical stats unchanged.
- [ ] Owner tests commit `b20ddb0`: two provisional faction side banners, no occlusion or Lua errors.
- [ ] Replace provisional banners with authored alpha-textured assets; implement circular portrait and ornate details against original PNG when available.
- UI fidelity not accepted; automated tests NOT RUN.

## Iteration 6 — owner client screenshot PASS for placement, FAIL for fidelity

- Both Horde emblems and red side rectangles render, with no visible collisions; HK=32, PvP deaths=8, HK/D=4.00 stable.
- [ ] Iteration 7: produce original alpha-textured torn banners, verify one TGA/BLP asset in Forever, then replace provisional rectangular flags.
- [ ] Add circular portrait overlay/mask and remaining ornate elements; obtain approved reference PNG.
- **Do not mark visual acceptance complete.** See `docs/DEVELOPMENT_HANDOFF.md`.

## Iteration 7 — code committed, awaiting owner test

- Commit `b19a011`: replace rectangular flags with layered ragged-edge silhouettes built from known-working WHITE8X8 textures, keeping faction icons. This is a provisional visual improvement, not actual alpha-textured art.
- [ ] Owner tests `/ws` and sends screenshot of ragged flags.
- [ ] Source proper original TGA banner textures and verify compatibility; add circular portrait frame and ornamental details.

## Iteration 7 owner QA and iteration 8 TGA test

- **Iteration 7 screenshot:** banners remain visually flat red rectangles despite strip-based ragged hem. Do not repeat strip approach.
- [x] Add original 128×256 32-bit transparent TGA `Media/General/banner_horde.tga` and integrate it into `UI/General.lua`.
- [ ] **Owner tests iteration 8** in Forever: custom cloth alpha, ragged bottom edge, faction icon, no Lua errors. Texture compatibility NOT YET VERIFIED.
- [ ] Add Alliance cloth variant, circular portrait framing, ornamental frame and screenshot QA.

## Iteration 8 owner QA / iteration 9 circular portrait

- [x] Owner screenshot confirms original Horde TGA banners render with ragged transparent edges in Forever.
- [x] Added original 128×128 TGA portrait ring with transparent circular aperture and gold border; integrated into `UI/General.lua`.
- [ ] Owner tests iteration 9: portrait visually circular, no black square artifacts or texture errors.
- [ ] Continue approved ornamentation and layout comparison after screenshot; full visual acceptance still pending.

## Iteration 9 owner QA / iteration 10 mask test

- [x] Owner screenshot: gold circular ring loads; **FAIL** opaque dark square outside the ring remains obvious.
- [x] Add circular alpha mask and fully transparent ring TGA; conditionally use native mask API with legacy fallback.
- [ ] Owner tests iteration 10: does dark square disappear? If not, record unsupported mask behavior and investigate alternative.
- Visual fidelity and full game acceptance remain pending.

## Iteration 10 screenshot / iteration 11 pending test

- [x] Owner screenshot: circular portrait now visually clean without dark square; banners and HK/deaths/ratio stable. Underlying native mask API execution not independently diagnosed.
- [x] Iteration 11 committed: header trim, General selected underline, rank-plate side accents.
- [ ] Owner screenshot of iteration 11: verify accents render without obscuring text or tabs.
- [ ] Continue with authored ornate header/frame assets and comparison against original mockup; UI not accepted.

## Iteration 11 screenshot / iteration 12 larger visual batch

- [x] Owner screenshot confirms iteration 11 header, selected tab underline, rank accents render and stats remain correct.
- [x] Owner explicitly requests larger visual changes per test cycle.
- [x] Implemented four outer corners, multi-layer header, diamond divider ornaments and section shading in iteration 12.
- [ ] Owner tests iteration 12 in Forever, checks Lua errors (especially `Texture:SetRotation`), layer order and overall appearance.
- [ ] Continue with actual painted ornamental assets and compare against reference PNG; no final UI acceptance.

## Iteration 12 screenshot / iteration 13 authored texture batch

- [x] Owner screenshot: iteration 12 corners/diamonds/section shading render; **issue** harsh rectangular HK/death backgrounds.
- [x] Add original TGA ornate corner and feathered section plaque assets; integrate four mirrored corners, softer HK/death sections, header detailing and six card studs.
- [ ] Owner tests iteration 13: texture loading, corner mirroring, feathering, text layering and no Lua errors.
- [ ] Continue with approved reference fidelity; no final visual acceptance.

## Iteration 13 screenshot / iteration 14 visual batch

- [x] Owner screenshot: TGA corner art and soft section plaques render, but corners clip at window edges.
- [x] Iteration 14: inset ornate corners, custom gold General/Hoy tab skin, layered rank-plate borders.
- [ ] Owner tests iteration 14 for clipped corners, correct selected tab styling, text readability and Lua errors.
- [ ] Continue approved visual parity work with original art assets; Hoy remains future functionality.

## Iteration 15 owner QA / iteration 16 pending

- [x] Owner screenshot: both unified statistic bands render with three segments; HK=32, PvP deaths=8 and HK/D=4.00 still visible. Layout is visually closer to target; owner has not explicitly accepted overall design.
- [x] Iteration 16 code committed: slightly larger icons, headings and normal values, paired metallic rails, beveled segment dividers and four corner studs per band.
- [ ] Owner tests iteration 16 in Forever and shares screenshot confirming no overlaps or Lua errors; check long titles and BG favorite text when available.
- [ ] Continue ornamental header, rank and approved reference parity work; automated Lua tests remain NOT RUN.
