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

## Iteration 16 screenshot / iteration 17 rank ribbon

- [x] Owner screenshot confirms iteration 16 larger band icons, trims and dividers render without obvious clipping; HK/deaths/HK-D unchanged. Full UI acceptance still pending.
- [x] Iteration 17: add bordered faction badge and layered metallic ribbon accents to rank plaque, retaining unavailable rank state.
- [ ] Owner tests iteration 17 in Forever: rank text not occluded, shield/badge alignment, no overlap with next divider, no Lua errors and main stats unchanged.
- [ ] Continue faithful painted ornament assets, exact original reference image storage and multi-resolution QA; automated Lua tests remain NOT RUN.

## Iteration 17 screenshot / iteration 18 header medallion

- [x] Owner screenshot: iteration 17 faction emblem and rank label render legibly; HK=32, PvP deaths=8, HK/D=4.00 and lower bands intact. This is not final visual acceptance.
- [x] Iteration 18: add decorative crossed-swords header medallion reusing supported ring TGA and icon; reposition tabs to avoid its footprint.
- [ ] Owner tests iteration 18 in Forever and sends screenshot checking square artifacts, icon/ring alignment, tab labels and interaction, close button, and Lua errors.
- [ ] Continue improving ornamental art and source-image fidelity; automated Lua checks and multi-resolution QA remain NOT RUN.

## Iteration 18 screenshot / iteration 19 medallion mask

- [x] Owner screenshot: crossed-swords medallion renders, tabs/title/close remain visible; squared backing and icon are visually obvious.
- [x] Iteration 19: apply guarded circular alpha mask to both medallion disc and swords icon, with smaller icon/no square backing as fallback.
- [ ] Owner test iteration 19 medallion masking and fallback/no artifacts in Forever; ensure other stats/UI stay intact.
- [ ] Final hand-painted swords artwork, ornamental asset fidelity, Lua tests and multi-resolution QA remain pending.

## Iteration 19 screenshot / iteration 20 tab skin

- [x] Owner screenshot: circular medallion now renders without a square backing; main stats and lower rows remain stable. Native mask API path still uninstrumented.
- [x] Iteration 20: replace templated General/Hoy buttons with plain Button frames and custom decorative FontStrings/rules to avoid unintended bright red inactive skin.
- [ ] Owner tests iteration 20: General visually active, Hoy muted, click handler works, no Lua errors or overlay issues.
- [ ] Continue original ornamental art and visual parity work; automated Lua tests and cross-resolution QA remain NOT RUN.

## Iteration 20 screenshot / iteration 21 HK emphasis

- [x] Owner screenshot confirms General gold active and Hoy dark inactive; medallion, rank, historical counters and segmented bands remain visible.
- [x] Iteration 21 increases HK typography and adds subtle paired gold flourishes/FontString shadows, without altering data.
- [ ] Owner tests iteration 21 in Forever, checking large HK numbers, side decoration, overlaps, Lua errors and baseline stats.
- [ ] Original laurel artwork, full reference-image parity, deterministic Lua tests and cross-resolution testing remain pending.

## Iteration 21 screenshot / iteration 22 HK laurel pass

- [x] Owner screenshot: larger HK number and title visible, stats unchanged; horizontal side strokes appear disconnected and don't resemble the reference laurels.
- [x] Iteration 22: replace side bars with mirrored small leaf/stem ornaments around HK, preserving text and statistics.
- [ ] Owner tests iteration 22 ornament visibility, no clipping, and absence of Lua errors.
- [ ] Create dedicated transparent painted laurel textures if native primitives remain insufficient; full design parity and automated tests outstanding.

## Iteration 22 screenshot / iteration 23 authored HK laurels

- [x] Owner screenshot: primitive HK sprigs render but look blocky and unlike the approved laurel reference. Data and both lower bands remain visible.
- [x] Iteration 23: commit original transparent 128x128 TGA laurel art; replace primitive sprigs with mirrored textures in UI/General.lua.
- [ ] Owner tests iteration 23: both transparent laurels load, orientations match, HK stays readable, no Lua errors or unexpected occlusion.
- [ ] Full painted-reference fidelity, multi-resolution tests and automated Lua checks remain pending.

## Iteration 23 screenshot / iteration 24 laurel alignment

- [x] Owner screenshot confirms transparent authored TGA laurels render symmetrically without square artifacts; they sit too close to the ratio divider.
- [x] Iteration 24 shifts and scales the two laurels closer to HK, maintaining the single mirrored asset and dynamic stats.
- [ ] Owner tests iteration 24 positions, separator clearance and absence of errors in Forever.
- [ ] Full reference-image parity, multiple UI scales and deterministic Lua tests remain pending.

## Iteration 24 screenshot / iteration 25 broader ornamental pass

- [x] Owner screenshot: HK TGA laurels look balanced after size/position adjustment, without clipping or collisions. Previous counters and bands intact.
- [x] Owner requested larger visual iterations.
- [x] Iteration 25: paired inset frame rails, feathered ornamental header title plate and improved typographic shadow, replace rank ribbon line accents with smaller mirrored TGA laurels.
- [ ] Owner tests iteration 25 in Forever for frame/header/rank layer order, label readability, ornament alignment, no Lua errors and unchanged stats.
- [ ] Full pixel parity, all data scenarios, alternate UI scales and deterministic Lua checks remain pending.

## Iteration 25 owner feedback / iteration 26 visual cleanup

- [x] Owner screenshot shows iteration 25 renders but rejects upper circular swords medallion (clipped and unnecessary), incomplete faction banners, redundant '(i)' ratio marks, and uneven small rank laurel. Overall design is not accepted.
- [x] Iteration 26 removes upper medallion, removes both '(i)' marks, repositions tabs with shared rule, removes rank laurel fragments, widens/enlarges banners and adds metal fitting. Alliance uses neutral placeholder rather than Horde cloth.
- [ ] Owner tests iteration 26 on Forever; check banner fit, no text overlap, correct active tab, ratio headings, rank ribbon, all lower data, Lua errors.
- [ ] Create original faction-specific banner artwork, finish approved ceremonial rank ribbon, inspect multiple UI scales, validate long labels and run deterministic Lua tests. Do not close this OpenSpec change yet.

## Iteration 26 screenshot / iteration 27 faction artwork and ribbon

- [x] Owner screenshot confirms medallion absent, ratio labels cleaned, navigation and rank legible, larger Horde banners visible, data stable. Final flag/rank appearance not accepted.
- [x] Iteration 27 adds original transparent Horde and Alliance 128×256 TGA banner art plus original 512×128 metallic PvP ribbon art.
- [x] Updated General.lua to use faction-specific fabrics and new ribbon, keeping current rank unavailable and all other metrics unchanged.
- [ ] Owner tests iteration 27 in Forever: banner alpha/tears, faction emblem placement, rank ribbon texture visibility and layering, no overlap or Lua errors, stable stats.
- [ ] Confirm Alliance appearance in client; run syntax/behavior tests and compare at other scales; full mockup fidelity remains pending.

## Iteration 27 screenshot / iteration 28 reordered center

- [x] Owner screenshot: Horde v2 banner cloth and metallic rank ribbon load, main counters and lower bands remain visible; new banner styling is progress but not final reference fidelity. Ribbon's angular end still looks awkward; Alliance remains untested.
- [x] Owner explicitly requests HK → PvP deaths → HK/D and KB/D, keeping lower rows.
- [x] Iteration 28: move death section below HK, move ratios lower, update separators within existing window height; narrow rank-ribbon rendered dimensions.
- [ ] Owner validates iteration 28 in Forever with screenshot: no overlap, stable numbers, readability of rank, ratios and lower bands.
- [ ] Continue original art fidelity, Alliance tests, automated Lua tests and UI-scale/large-value QA; no acceptance or archive yet.

## Iteration 28 — additional styling before first client QA

- [x] Owner requested a more complete iteration before testing.
- [x] Second iteration 28 commit adds stronger death-number hierarchy, gold ratio headings/cream values, softer captions, subtle rank studs, and lower-band value shadows while preserving HK → deaths → ratios ordering.
- [ ] Owner tests the combined iteration 28 changes in one Forever screenshot, checks layout, value readability, rank ribbon ends, no errors and unchanged historical counters.
- [ ] Native client test and automated Lua tests are still NOT RUN; maintain open spec until accepted.

## Iteration 28 owner screenshot / clean addon release ZIP

- [x] Owner screenshot confirms HK → PvP deaths → two ratios ordering renders clearly without major overlaps; lower bands intact. Final design not approved.
- [x] Removed disconnected PvP-deaths side lines and cropped stripe artifacts from existing rank ribbon (new visual QA pending).
- [x] Added reproducible `tools/package_addon.py` and published `dist/WarScore.zip` with exactly 15 runtime files under a single `WarScore/` root, excluding OpenSpec/docs/tools. ZIP contents independently validated.
- [ ] Owner tests clean ZIP in Forever, confirms rank tip/death-section cleanup, no missing resources, no Lua errors and preserved stats.
- [ ] **For every future code/media iteration:** rebuild `dist/WarScore.zip` and share only the clean package link, never source `main.zip`.
- [ ] Full mockup parity, other characters/factions, high-digit numbers and automated tests remain outstanding.

## Iteration 28 clean-ZIP screenshot / iteration 29 style pass

- [x] Owner screenshot: the clean ZIP loads, shows new order HK → PvP deaths → ratios, and keeps six lower indicators, banners, rank and portrait. Stats remain 32/8/4.00; no error reported.
- [x] Owner requests visually smaller, less important PvP deaths.
- [x] Iteration 29: reduce death title/value/soft plaque; remove isolated rank studs, improve rank/header typography, add dark mounts to lower-band icons.
- [x] Rebuilt `dist/WarScore.zip` with only 15 runtime files. GitHub confirms binary SHA; separate remote-content check was inconclusive due connector returning empty content.
- [ ] Owner tests iteration 29 in Forever and sends screenshot, validates ratios, secondary deaths, icon mounts and no Lua errors.
- [ ] Keep development docs/OpenSpec outside install ZIP; run automated Lua tests and multi-faction/scale QA before approval.

## Distribution hotfix after iteration 29

- [x] User reports manually assembled ZIP cannot be extracted by Windows. Mark old package invalid.
- [x] Added GitHub Actions standard-Python packaging + `unzip -t` + `ZipFile.testzip()`; committed a fresh Deflate ZIP with 15 runtime files and no development folders.
- [x] Verified new ZIP structure via GitHub connector readback (107,767 bytes, standard compression, valid central directory).
- [ ] Owner downloads corrected ZIP from raw.githubusercontent.com and confirms Windows extraction and in-game loading.
- [ ] Keep future packages CI-produced; no ad hoc ZIP assembly.

## Iteration 29 screenshot / iteration 30 banner and rank polish

- [x] Owner screenshot confirms the repaired standard-Python distribution ZIP extracts and loads in Forever. The smaller deaths counter and existing stats render as intended; final style still unapproved.
- [x] Iteration 30 code: masked faction emblem over banners with compatibility fallback; two-tier PvP rank caption/value with retained faction crest; subtle icon accents within both lower bands.
- [ ] Owner validates iteration 30 rank alignment, banner emblem masking, lower icon details and no Lua errors in Forever.
- [ ] Regenerate and verify clean ZIP after Lua changes; continue final art parity and Alliance/multiple-UI-scale QA.

## Iteration 30 screenshot / iteration 31 version check

- [x] Owner screenshot of the purported iteration 30 looks like pre-30 rank (single-line) and square banner icons; exact loaded UI build not verified.
- [x] Iteration 31 adds `/ws version` diagnostic and refines two-line rank layout.
- [x] GitHub Actions rebuilt ZIP; independently checked ZIP central directory and UI source CRC/length match (15 clean addon files).
- [ ] Owner installs by replacing the complete `WarScore/` folder, runs `/ws version` expecting 31, opens `/ws`, sends screenshot.
- [ ] If diagnostic confirms 31 but visuals do not match, debug actual in-game render and alpha-mask support. Automated Lua and multi-faction QA still outstanding.

## Iteration 31 owner screenshot / iteration 32 refinement

- [x] Owner ran `/ws version`: confirms build 31. Two-tier rank text and circular banner emblems render; main stats and both lower bands remain intact.
- [x] Iteration 32 adjusts rank typography for bottom clearance, reduces banner badge visual dominance, softens lower-band accents, updates version diagnostic.
- [x] CI rebuilt the clean install ZIP; verified 15 Deflate files and current Lua file CRC matches its packaged copy.
- [ ] Owner tests build 32 in Forever, checks `/ws version`, rank clearance, mask appearance and absence of errors.
- [ ] Continue richer heraldic art/fidelity and test other factions, values, UI scales and Lua behavior before acceptance.

## Iteration 32 screenshot / iteration 33 ornamental batch

- [x] Owner screenshot explicitly confirms iteration 32 and shows two-line rank and smaller circular masked Horde emblems without obvious collisions; stats and lower bands intact.
- [x] Iteration 33: add visible banner hanging/mounting details, slightly soften icon badging, strengthen rank ribbon depth and ends, improve shared band surfaces and captions.
- [x] CI rebuilt verified clean ZIP; inspected 15 Deflate entries, updated Lua CRC and no development files.
- [ ] Owner tests iteration 33 in Forever, checks `/ws version` returns 33 and no visual clipping/errors.
- [ ] Full original mockup fidelity, Alliance and varied UI-scale/large-number test cases and automated Lua checks remain outstanding.

## Iteration 33 screenshot / iteration 34 lower bands

- [x] Owner screenshot: latest banded layout, two-tier rank and softened circular Horde emblems render; core counters unchanged. Full visual acceptance not granted.
- [x] Iteration 34: banner edge stitching, stronger inset band rails and divider rivets, bigger bottom icons and standard values; corrected divider-rivet anchors before QA.
- [ ] Confirm clean GitHub Actions package regenerated after iteration 34 changes; verify shipped `General.lua` matches source.
- [ ] Owner tests iteration 34 in Forever and shares screenshot; assess long label clipping, icon/value spacing, rivets, banner edges, errors.
- [ ] Full original reference parity, automated Lua tests and additional faction/scale testing outstanding.

## Iteration 34 screenshot / iteration 35 band-frame cleanup

- [x] Owner screenshot shows iteration 34 style with new lower icons and values, but divider rivets resemble isolated pixels; historical counters remain HK=32/deaths=8/HK-D=4.00.
- [x] Iteration 35 removes detached divider rivets and ribbon endcap strokes, adds continuous lower frame glint and uses short divider caps; no changes to statistics.
- [x] CI rebuilt and ZIP central directory/15 entries/current Lua CRC independently verified; deliver only `dist/WarScore.zip`.
- [ ] Owner tests iteration 35 in Forever, checks `/ws version`, visible frame finish and absence of Lua errors.
- [ ] Full mockup matching, automated Lua QA and Alliance/varied UI-scale coverage outstanding.

## Iteration 35 screenshot / iteration 36 larger metric bands

- [x] Owner screenshot confirms both 3-section bands still render without obvious collisions, and HK=32/deaths=8/HK-D=4.00 remain visible. Overall artwork still far from approved reference.
- [x] Iteration 36 replaces scattered corner studs with mirrored transparent ornamental corners and removes disconnected divider caps.
- [x] Enlarges lower icons, headings and values while constraining text within each segment; dynamic bindings unchanged.
- [x] GitHub Actions ZIP rebuilt, verified 15 runtime entries and Lua CRC matched current UI source.
- [ ] Owner tests `/ws version` 36 in Forever and shares screenshot to check lower heading wrapping, icon/value spacing, corner textures, no Lua errors.
- [ ] Continue original reference parity and multi-faction, nonempty metrics, different resolutions and Lua tests before final sign-off.

## Iteration 36 screenshot / iteration 37 hierarchy

- [x] Owner screenshot confirms HK=32, PvP deaths=9, HK/D=3.56 (correctly rounded from 32/9) and readable lower bands; live state differs legitimately from earlier 32/8/4.00 screenshots.
- [x] Iteration 37 differentiates two lower strips: first absolute totals, second lower-weight win rates/favorite; retains data bindings and previous layout.
- [ ] Verify CI-generated clean ZIP includes iteration 37 source; owner tests `/ws version` 37 and submits screenshot.
- [ ] Final approved design fidelity, nonempty BG history, additional factions and deterministic Lua testing remain pending.

## Iteration 37 screenshot / iteration 38 icon treatment

- [x] Owner screenshot confirms the first/second lower bands present different visual hierarchy, with no visible text clipping and stable HK=32, deaths=9, HK/D=3.56.
- [x] Iteration 38 simplifies icon mounts, crops native icon edges, softens frame glint and maintains aligned text columns.
- [ ] Verify the CI-rebuilt clean ZIP includes UI iteration 38, then owner tests in-game screenshots/no Lua errors.
- [ ] Final original-reference fidelity, Alliance UI, other scales, nonempty BG history and Lua automated tests remain pending.

## Iteration 38 screenshot / iteration 39 real textile heraldry

- [x] Owner screenshot: 38 keeps HK=32/deaths=9/HK-D=3.56 and 2x3 stat bands intact; icon tiles remain square-looking.
- [x] Owner explicitly rejects any Horde banner emblem that appears pasted on top. Acceptance requires cloth-integrated heraldry or a logo-less fallback.
- [x] Iteration 39: authored an original 128x256 transparent TGA with the Horde-inspired angular mark baked into the existing folded fabric; removed the Horde inventory-icon/mask overlay entirely; Alliance remains provisional.
- [x] Rank ribbon backing and band contrast polished in same batch, core data and layout unchanged.
- [x] CI-generated clean distribution verified (15 files, current Lua and new textile TGA CRCs match repository blobs).
- [ ] Owner tests `/ws version` 39 and sends screenshot; accept banner only if integrated mark actually resembles faction heraldry naturally.
- [ ] If mark is weak or still sticker-like, **remove banner symbol** rather than returning to icon overlay; finalize Alliance art separately.
- [ ] Longer value layouts, alternate UI scale, Lua automated tests and mockup fidelity outstanding.

## Iteration 39 screenshot / iteration 40 integrated cloth plus icon repair

- [x] Owner screenshot confirms emblem integrated into fabric but too dark; lower band icons are visibly cropped/zoomed.
- [x] New original woven Horda cloth TGA with enhanced pigment contrast and fabric-edge wear, no separate icon.
- [x] Restore full 0..1 texcoords for six stat icons, reduce mount/tile dominance, modestly rebalance rank crest and caption; `/ws version` now 40.
- [ ] Verify CI-generated clean ZIP matches source and includes new woven TGA, then owner tests in Forever.
- [ ] Owner judges whether integrated heraldry is acceptable; if not, consider cleaner logo-less cloth rather than reverting to pasted native inventory icon.
- [ ] Full reference art, Alliance integration and automated Lua/scale/data scenarios remain pending.

## Iteration 40 screenshot / iteration 41 original embroidered banners

- [x] Owner screenshot validates all six lower icons once more visible in full; Horde heraldry is directly integrated in cloth but still subdued.
- [x] Iteration 41 paints stronger worn copper/red threading into original textile TGA, avoiding any separate inventory emblem layer.
- [x] Tab/rank and first/second lower-row typographic hierarchy refined without modifying data.
- [x] Verified CI-built clean ZIP (15 files) matches both current Lua and new original TGA through CRC32.
- [ ] Owner tests `/ws version` 41, sends screenshot of faction flags, rank and lower bands, checks for Lua errors.
- [ ] Banner acceptance, Alliance art, alternative scales, real BG data scenarios, automated Lua QA and full reference fidelity remain pending.

## Iteration 41 screenshot / iteration 42 visibility

- [x] User screenshot confirms woven Horde cloth logo and all six lower icons render, values HK 32 / PvP deaths 9 / HK-D 3.56; not final banner approval.
- [x] Screenshot reveals excessive world/nameplate visibility behind center stats; iteration 42 makes window background opaque and adds dark central background behind lifetime metrics and ratios.
- [x] Secondary caption contrast and band top highlight adjusted slightly without changing bindings.
- [ ] Verify fresh clean packaged ZIP includes iteration 42 UI and no development files; owner tests in game with visible world activity behind panel.
- [ ] Full design parity, Alliance fabric, nonempty BG stats, multiple scales and Lua tests remain pending.

## Owner-approved structural redesign — iteration 43 (2026-11-17)

- [x] Lock decision: **faction banners frozen**, not accepted and not being modified until frame/rank/band milestones complete.
- [ ] Replace visual outer-limit black/background with native WoW-style **outer frame** and inset opaque background, flush with border.
- [ ] Add **separate inner content frame** containing tabs and stats; maintain breathing room and avoid collisions.
- [ ] Rework rank two-line caption padding down and improve silhouette/metal trim; never invent rank.
- [ ] Bottom strips: center captions and values in each full segment irrespective of icons; all top values gold and titles cream; all bottom values green, titles cream.
- [ ] Display nil as 0 for top counts and 0% for both win rates; favorite null becomes green dash; preserve nil/unknown in Stats.lua.
- [ ] Remove fake lower icon backing slots, but retain full silhouettes; real cutout/alpha icons remain design target, not automatic.
- [ ] Verify /ws version = 43, archive integrity, in-client layout, all empty-data cases and no Lua errors.
- [ ] Later: genuine native-border fidelity, transparent painted icon assets, unified rank silhouette, Alliance/banner graphics only AFTER other milestones; high numeric values and other scaling remain open.

## Iteration 43 — implemented, awaiting in-client QA

- [x] Document owner-approved visual redesign and freeze banner work.
- [x] Code: native WoW dialog outer frame with inset uniform background; remove hard-edged central rectangular overlay and redundant old side rails.
- [x] Code: second inner border around navigation and statistics.
- [x] Code: lower rank caption/value 3 px while keeping truthful rank unavailable.
- [x] Code: center text/value at each full lower-band segment's x=0, independent of decorative left icon.
- [x] Code: first-row counts nil→display 0 (gold), second-row rates nil→display 0% (green); favorite absent→green dash; all titles cream; backend nil semantics preserved.
- [x] Code: remove additional square icon mounts; leave full native icons (real transparent cutout art is future work).
- [x] CI clean ZIP verified, 15 runtime files, current General.lua CRC match; banners unchanged.
- [ ] **Owner tests /ws version 43 in Forever** with reference mockup alongside; check native border and inner frame render, dark background confined to frame, no hard-edged central rectangle, tab/close functionality, correct text centering and absent data colors, and send screenshot.
- [ ] Sculpted rank plaque / gold ends, true cutout pictogram assets, and more precise spellbook-like frame are NEXT visual milestones after QA. Banners stay frozen, NOT accepted.
- [ ] Nonempty BG stats/long favorite names, other UI scales and Alliance client test, automated Lua tests still open.

## Iteration 43 screenshot / iteration 44 actual image assets

- [x] Owner screenshot demonstrates dual nested frames and uniform interior, and confirms the 0 / 0% / green dash display rules and centered metric values with original historical statistics untouched.
- [x] Generated five original transparent cutout metric images and one original sculpted PvP rank plate TGA.
- [x] Updated `UI/General.lua` to load all six assets; retained dynamic two-tier rank, original character data, bottom band centering and frozen flags; `/ws version` = 44.
- [x] Fixed packaging workflow to check exact TOC+media runtime file set rather than fixed 15-file count; fresh GitHub Actions ZIP verified with 20 Deflate files, all six new assets, and UI CRC match.
- [ ] **Owner tests iteration 44 in WoW Forever** and submits screenshot, checks loading of transparent images, centered columns, rank plaque geometry, zero/green formats and no Lua errors.
- [ ] Full reference fidelity still pending; keep banners frozen; consider further sculpted rank and WoW-native border refinements after screenshot.
- [ ] Alternative scale, long populated favorite name, Alliance, automated Lua tests and data-retrieval QA remain open.

## Iteration 44 rejection and iteration 45 corrective rollback

- [x] Owner screenshot of 44: clip-art metric icons and orange rank rectangle **REJECTED**, despite successful texture loading.
- [x] Iteration 45 restores small unobtrusive native placeholder icons and subdued leather rank ribbon while preserving iteration 43 structure, stats and formatting.
- [x] CI rebuilt clean ZIP; 15 runtime entries and packaged Lua CRC match source; no rejected experimental art assets in install package.
- [ ] Owner validates /ws version 45, visual rollback, no errors, and sends screenshot.
- [ ] Long-term artwork must look like native Warcraft premium iconography rather than simplistic geometric symbols; rank plaque silhouette and pictogram art still need substantial work.
- [ ] Banner redesign frozen; preserve outer and inner frames, centered columns, top gold/bottom green values and no-data display semantics.

## Iteration 45 screenshot / iteration 46 QA

- [x] User screenshot shows visual rollback of rejected 44 art succeeded, with dual frames, correctly formatted lower values and historic stats intact.
- [x] Iteration 46: optional masked native glyphs to soften square tile outlines; no invented icons.
- [x] Iteration 46: remove stray rank gold endcaps, mirror existing gilded laurel at ribbon ends; crest and two-line rank retained.
- [x] Banner freeze and data behaviors preserved; GitHub Actions built clean ZIP, 15 runtime entries verified against source CRC.
- [ ] Owner tests `/ws version` 46 and returns screenshot; assess masks, ornament overlap and whether design genuinely improves.
- [ ] True premium icon artwork and sculpted single-piece rank still not fully achieved; banners remain deferred; multi-scale, Alliance, populated BG metrics and automated Lua tests pending.

## Iteration 46 screenshot → iteration 47 icon size / rank cleanup

- [x] Owner screenshot: circularly masked native glyphs render but remain too small; rank-end laurels look detached, not integrated.
- [x] Increase native lower icon sizes 37→43px without moving centered text; retain fallback for masking.
- [x] Remove poorly integrated mini-laurels from PvP rank; modestly slim ribbon/backing.
- [x] CI-generated runtime-only ZIP verified (15 entries, current Lua CRC match).
- [ ] Owner tests `/ws version` 47 in Forever and reports icon scale, rank edge clarity and any Lua errors.
- [ ] Frozen banners, alternative faction/scale QA, nonempty BG values, automated Lua tests, high-fidelity art still outstanding.

## Iteration 47 screenshot and iteration 48 rank pass

- [x] Owner screenshot shows icon size 43px and no detached rank laurels, stable double-frame and value conventions; no explicit final art acceptance.
- [x] Iteration 48 adjusts rank inset backing, adds restrained continuous metallic lines within plaque, centers rank text horizontally at x=0 and slightly compacts crest holder.
- [x] Clean CI build ZIP validated: 15 runtime Deflate files and `General.lua` CRC32 matches current repo.
- [ ] Owner tests `/ws version` 48 in WoW Forever, checks metal highlights, centered rank text/crest and any Lua errors.
- [ ] Banners remain frozen. Additional realistic artwork, long value, alternative-scale, Alliance and automated Lua QA remain outstanding.

## Iteration 48 screenshot → iteration 49 textured background

- [x] Owner observed the mockup uses dark warm-grey subtle material rather than plain black, and requested implementation; verified working GitHub repository write access.
- [x] New original opaque 256×256 TGA with low-contrast aged-stone grain, warm grey-brown palette and soft vignette.
- [x] Only the root shell background is switched to the TGA, preserving the border inset, frames, PvP data, rank, masks and frozen banner artwork.
- [x] Clean CI package verified: 16 runtime entries, exact Lua and new TGA CRC match, no development files.
- [ ] Owner checks `/ws version` 49 and screenshot of full-window backdrop for visible grain, non-flat grey tone, correct contrast and border containment.
- [ ] Continue genuine reference fidelity, rank sculpting, Alliance/scale cases and automated Lua QA; banners remain frozen.

## Iteration 49 owner screenshot → iteration 50 rank sculpture

- [x] Owner screenshot of 49 shows warm grey textured shell heading toward mockup; lower stat icons and hierarchy retained. Not final sign-off.
- [x] Iteration 50: restore visible sculpted ends of pre-existing rank ribbon art while reducing flat backing.
- [x] Replace square-bordered rank crest with circular ornamental boss using existing transparent ring and guarded mask; keep faction truthful and rank unavailable.
- [x] Keep banners frozen, rejected clip-art and orange slab absent, all 43px lower icons and data semantics unchanged.
- [ ] Confirm CI refreshed runtime-only ZIP contains iteration 50 Lua; test archive integrity and source parity.
- [ ] Owner tests `/reload`, `/ws version` = 50, `/ws` in Forever and returns screenshot. Evaluate rank silhouette, icon mask, crest integration and any Lua errors.
- [ ] Continue visual matching in small iterations; alternate UI scales, Alliance, populated BG scenarios and automated Lua/client QA remain outstanding.

## Iteration 50 screenshot → iteration 51 rank artifact correction

- [x] Owner screenshot: warm-grey textured shell, large lower icons, rank circular crest, main counters all render.
- [x] Identify **visible hatch/striping at ribbon right end** from iteration 50's expanded UV range; owner has not accepted the rank plaque.
- [x] Iteration 51: restore previously safe UV crop, refine restrained inside-material depth, enlarge/rebalance two-line rank inscription; preserve circular emblem.
- [x] Keep faction banners frozen and lower six icons/stat bindings unchanged.
- [ ] Verify CI runtime-only ZIP contains iteration 51 Lua and is structurally intact.
- [ ] Owner tests iteration 51 in Forever: no right-side hatch, rank readably centered, crest and surrounding dividers aligned, no Lua errors; send screenshot.
- [ ] Later: improve custom sculpted rank art if still visually too flat. Alliance, other scales, populated BG stats and deterministic Lua tests remain pending.

## Iteration 51 screenshot and original reference → iteration 52

- [x] Owner's reference mockup received and compared with real-client screenshots; reference data is fictional and must not be mirrored.
- [x] Record **unapproved**: background material, all lower statistic icons, current rank artwork.
- [x] Identify circular faction crest as visually wrong and persistent ribbon-right hatching despite earlier UV fix.
- [x] Iteration 52 removes round crest and tightens rank ribbon UV crop, maintains real rank-unavailable state and all existing counters/row conventions.
- [ ] Owner tests iteration 52 and confirms right-edge scratch gone, no awkward empty space without crest, no UI errors.
- [ ] Create proper single-piece rank graphic with integrated heraldic shield (NO circular coin and NO orange rectangle).
- [ ] Revisit backdrop using original reference: richer organic leathery/stone texture and proper depth; current backdrop not approved.
- [ ] Replace/rework all six masked native item icon tiles with coherent WoW-quality transparent pictograms; no rejected iteration 44 clip-art.
- [ ] Preserve frozen side banners until owner asks to unfreeze; game client/Alliance/alternate scaling QA still open.

## Iteration 52 screenshot → iteration 53 banners/settings/rank emblem

- [x] Owner screenshot: remove both large faction banners; round emblem is gone but the rank remains visually too rectangular.
- [x] Owner requests rank faction emblem as a left-side overlapping ornament; add WoW-style settings gear inside INNER frame upper-right, visual only (no feature).
- [x] Remove left/right banner creation from General UI; keep original files in source for possible later reuse.
- [x] Add overlapping gold-trim faction emblem to rank without fake PvP rank data; no circular boss.
- [x] Add native gear graphic and 'Ajustes (próximamente)' tooltip within inner frame; no settings implementation.
- [ ] Validate packaging/CRC and owner real-client screenshot: gear asset exists and positioned correctly, native emblem doesn't look like sticker, no errors.
- [ ] Unapproved: rich backdrop reference matching, coherent lower icon set, polished integrated shield/rank strip. Do not claim otherwise.

## Iteration 53 screenshot → iteration 54 depth / settings icon / rank spacing

- [x] Owner screenshot: banners absent, settings positioned correctly but wrong visual glyph, Horda badge too far left, background too grey/flat.
- [x] Deliberate background change: warm near-black tint of grain asset and subtle feathered central patina for recessed material depth.
- [x] Replace non-cog Gizmo icon with `INV_Misc_Gear_01` candidate, preserve settings placeholder/inner-frame location.
- [x] Move raised faction badge 36px right within ribbon and rebalance title and dynamic value.
- [ ] Real-client screenshot verification of cog asset (may not exist), dark material depth, rank alignment and no lua errors.
- [ ] Still NOT approved: background final reference fidelity, lower six icons, premium rank graphic/shield. Do not mistake this iteration for finished artwork.
- [ ] Independent Lua tests, non-empty BG data, Alliance and alternate scale QA.

## Iteration 54 screenshot → iteration 55 original art pass

- [x] Owner's 54 screenshot: gear candidate was a grey coil, not a gear; original dark shell still too flat; no approval of rank or lower icons.
- [x] Author transparent original metal cog TGA and switch settings icon from unreliable native inventory asset; same interior upper-right location, no settings feature.
- [x] Author new darker organic leather/stone texture with multiscale grain and edge vignette; use it directly without extra patina overlay.
- [ ] CI package includes both new media assets and source Lua 55; integrity and source parity checks.
- [ ] Owner verifies in Forever cog legibility, warm dark backdrop depth, contrast of text/card bands, no artifacts, no Lua errors.
- [ ] Future: polished PvP shield/plaque, six high-quality lower symbols, exact reference-material fidelity, other UI scales and Alliance scenarios. None considered complete.

## Iteration 55 screenshot follow-up → iteration 56 owner-provided faction asset

- [x] Receive original Horde hanging-banner transparent PNG (1024×1536) and inspect dimensions/alpha.
- [x] Convert to compatible 256×512 32-bit uncompressed transparent TGA; preserve artwork rather than drawing surrogate placeholders.
- [x] Commit asset to `Media/General/banner_horde_supplied.tga` and render symmetrically on each side in `UI/General.lua`, replacing previously removed banner functionality; no Alliance reuse.
- [x] Bump UI diagnostic to 56; keep metrics, rank, settings placeholder, lower card icons and background untouched.
- [ ] Verify GitHub CI runtime-only ZIP includes new TGA and packaged `UI/General.lua` CRC agrees with source; test archive integrity.
- [ ] Owner tests clean install, `/reload`, `/ws version` = 56 and screenshot; verify transparency, size, rod alignment, and no overlap/errors.
- [ ] Background, lower iconography, premium rank shield/plaques remain unapproved; continue after owner screenshot.

## Iteration 56 screenshot → iteration 57 owner integrated inner-frame

- [x] Owner confirms supplied Horde banner art is good; issue: detached hanging rods versus ornamental top rail.
- [x] Receive original full gold inner panel PNG with banners visually connected to upper edge and two blank projecting tabs.
- [x] Import as transparent compatible TGA `inner_frame_owner_v57`, retain nested-window hierarchy and no second banner sprite.
- [x] Remove duplicate inner tooltip border and decorative corner overlays; position live General/Hoy labels and hitboxes on supplied tabs.
- [x] Keep settings cog, historical stats, ratios, icon fallback rules and available data unchanged.
- [ ] CI verified ZIP contains integrated panel and UI 57; owner in-game QA of tabs/banners/frame seam, gear alignment and panel/card collisions.
- [ ] Alternative Alliance art, background/card contrast, final rank ornament, and coherent lower-stat glyphs are still unapproved.

## Iteration 57 owner screenshot → iteration 58 supplied outer frame

- [x] Owner provided matching exterior frame asset with crossed-swords medallion, header and close glyph.
- [x] Convert new exterior art to WoW-compatible transparent 512×1024 TGA, cropping redundant internal border to avoid double-framing the existing inner asset.
- [x] Use 870×1060 outer window, center 760×890 inner art and align tabs in the exposed space below the outer header.
- [x] Replace native dialog border/header/close skin with supplied outer art; preserve dynamic WarScore title and clickable transparent X hitbox.
- [x] Reposition settings gear inside inner frame top right without duplicating Horde banner decorations.
- [ ] Verify CI clean ZIP contains exact new outer asset and v58 General.lua with matching source CRC.
- [ ] Owner tests v58 in Forever: exterior/inner centering, sufficient bottom clearance, no mismatched rails, General/Hoy tab labels, clickable X and no Lua errors.
- [ ] Pending: approval of lower metric glyphs, sculpted rank artwork, Alliance treatment, multiple scales and high-number/long-label cases.

## Iteration 58 screenshot → iteration 59 structural cleanup

- [x] Owner screenshot identifies residual black outer rectangle, portrait/tab overlap, border clashes and cramped cards. This is not completed visual acceptance.
- [x] Remove old full-frame opaque leather layer so alpha outside combined author-supplied frames is unobstructed.
- [x] Reduce portrait to 106px ring/90px face and lower it under tab rail; adjust live name, level and PvP rank.
- [x] Reposition HK, deaths, ratios and two lower stat rows within nested frame; shorten separator rails and preserve gold/green missing-value conventions.
- [x] Keep settings gear clear of upper-right faction banner, retain painted tab positions, dynamic title and close hitbox.
- [ ] Verify CI refreshed runtime ZIP version 59 against source CRC and exact runtime resource list.
- [ ] Owner tests in Forever and returns screenshot: confirm black rectangle/outer alpha, portraits, tab/rail overlap, rank, bottom row margin and any Lua errors.
- [ ] Outer asset transparency may still need direct inspection if black rectangle persists. Rank's heraldic treatment and six lower icons still need replacement/approval.

## Iteration 59 in-client FAIL → iteration 60 confined background

- [x] Screenshot confirms removal of root full-window backing reveals the world through several alpha holes in supplied inner/outer artwork.
- [x] Reuse previously authored existing dark leather TGA only as a 744×875 **inset background** behind both painted frames, rather than restoring old full-window black block.
- [x] Keep prior geometric layout/reflow and stats untouched while repairing the layering failure; bump diagnostic to version 60.
- [ ] Verify GitHub CI package version 60, source CRC and referenced art.
- [ ] Owner tests real client: no see-through holes inside frame, no full-size black rectangle outside it, centered portrait/stats and bottom card clearance, no Lua errors.
- [ ] If still see-through, investigate alpha contours/need for an opaque backing supplied separately. Never mark unapproved rank plaque/lower glyphs complete.

## Iteration 60 screenshot → iteration 61 background gutters and asset governance

- [x] Owner screenshot: central interior covered, but bright world visible in side gutters between outer and inner frames, and upper tab transition.
- [x] Adjust existing dark leather backing from 744×875 y=-115 to 790×930 y=-97, behind supplied paintings, without modifying any owner art or game statistics.
- [x] Document root AGENTS.md rule: request missing artistic assets from owner, never invent/generate visual stand-ins; conversion/positioning of provided assets is allowed.
- [ ] Confirm CI regenerated runtime-only ZIP contains v61 General.lua with matching source CRC.
- [ ] Owner QA v61 in bright zone: no transparent gutters and no new black exterior rectangle, both owner frames clean, tabs and bottom cards legible, no Lua errors.
- [ ] If the flat rectangular backing still causes leakage or protrusion, explicitly request a separately supplied opaque alpha-masked interior backing. No further fabricated decoration.
- [ ] Rank/plaque and lower six icons remain unapproved, plus Alliance and alternative display-scale QA.
