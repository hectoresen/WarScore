# WarScore — live development handoff

**Last updated:** 2026-11-17 (iteration 12 larger ornament batch, awaiting owner QA).

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

## Iteration #3 — client-tested by owner

Git commit: `e845257cf70957f56eefd26c555c35f57aafdae5`.
- Removed `Interface\\Minimap\\MiniMap-TrackingBorder`, **confirmed in source** to be the cause of the misplaced gold ring; replaced with centered tooltip border as a temporary **square** frame. True circular mask still not implemented.
- Added darker header plate, rank plate and vertical separator between HK/D and KB/D.
- **OWNER SCREENSHOT #3:** gold minimap ring is gone, centered square portrait border and vertical ratio separator render; stats remain HK 32, PvP deaths 8, HK/D 4.00. **FAIL:** WarScore title invisible because header child frame covers parent FontString; rank label darkened because rankPlate child frame covers parent FontString; ornate assets/circular portrait missing. The screenshot exists in chat, not repo.

## Iteration #4 — client-tested by owner

Git commit: `f76b55991406c29a07d28353019082c9352f5f86`.
- Moved WarScore title FontString inside the header child frame and rank FontString inside the rankPlate child frame, preventing their backgrounds from painting over the labels.
- Added native tooltip-style border to each of six cards.
- Replaced unsupported Unicode circled-info glyphs (rendered as square boxes) with '(i)' temporary text. Proper tooltip buttons still outstanding.
- **OWNER SCREENSHOT #4:** WarScore title, rank label, all six card borders, and '(i)' labels render legibly. HK 32, PvP deaths 8, HK/D 4.00 unchanged. **FAIL / PENDING:** square portrait, no approved ornate frame, banners, laurels, corner details; mockup fidelity still low. Screenshot is in chat, not repository.

## Iteration #5 — client-tested by owner

Git commit: `170abf6ad66bb4eef6fff6862ef952f546951db7`.
- Added **provisional** WoW-native icon textures to each of six statistic cards, with adjusted label/value vertical layout.
- **OWNER SCREENSHOT #5:** all six provisional card icons render, labels and numbers fit without visible overlap; stats remain HK=32, PvP deaths=8, HK/D=4.00. **PENDING:** custom ornaments, accurate circular portrait and screenshot fidelity. Icon assets are temporary.
- Circular portrait masking, custom ornaments, banners and reference PNG are still pending; no claim of visual parity.

## Iteration #6 — client-tested by owner

Git commit: `b20ddb00e9ced29b2d17dc8caa26e61b6c1fe07e`.
- Added two **temporary** side banner blocks behind character content, with gold trim and faction-aware native PvP icon. This is an incremental layout test, **not** final torn-cloth/banner art.
- **OWNER SCREENSHOT #6:** both red rectangular banners and Horde emblems render, no overlap with portrait or statistics. HK=32, deaths=8, HK/D=4.00 remain stable. **VISUAL FAIL:** rectangles/icons are placeholders, unlike torn-fabric flags in target. True circular portrait and approved custom assets remain pending.

## Iteration #7 — client-tested, visual improvement FAILED

- Prepare original transparent faction-banner artwork with torn lower edges, integrated emblem, metallic attachment and shading; do not simply stretch a solid color block or screenshot.
- Test a single TGA/BLP texture in WoW Forever before producing the whole asset pack; verify dimensions, alpha and loading.
- Add asset files to repo with provenance, update UI/General.lua to use native Texture:SetTexture paths; keep fallback only if verified.
- Then address circular portrait framing with compatible alpha overlay/mask and remaining ornamental elements.
- Original expanded reference PNG still needs to be committed for meaningful screenshot overlay comparisons.
- **Implementation commit:** `b19a0113899e36633689469bfaded2261a6702dd`. Replaced the two flat rectangular banners with a layered, vertically ragged cloth silhouette made from client-tested WHITE8X8 texture strips. No external asset dependency; same faction icon retained. **This is not final painted cloth** and has not been client-tested.
- **OWNER SCREENSHOT #7:** banners still appear as flat red rectangles, no discernible torn-fabric silhouette. Faction emblems render and stats remain stable. Do not continue approximating painted fabric with solid strips.

## Iteration #8 — client-tested, TGA rendering confirmed

- `Media/General/banner_horde.tga` added as a genuine 128×256 uncompressed 32-bit BGRA TGA with alpha, top-left origin. Artwork is an original programmatically drawn dark red cloth with folds, gold top seam, irregular hem and tears; not copied from WoW artwork. Commit `a96d23235e6eb7ab57f428d7c2a03ada806224bb`.
- `UI/General.lua` now uses `Interface\\AddOns\\WarScore\\Media\\General\\banner_horde` as native Texture and retains separate native faction icon. Commit `198cb598a70d01da928f97f86887246d5c0c2846`.
- **OWNER SCREENSHOT #8:** both torn-cloth TGA banners render correctly, including irregular hem and alpha. The red banner art is still Horde-specific; Alliance-specific cloth art pending. Stats remain HK 32, PvP deaths 8, HK/D 4.00.
- Next after asset verification: circular portrait frame and ornate border/corners. Original reference PNG remains uncommitted.

## Iteration #9 — client-tested, square-corner artifact confirmed

- Added original `Media/General/portrait_ring.tga`, 128×128 uncompressed 32-bit BGRA TGA with transparent circular aperture, gold multi-tone ring and dark opaque outside corners. Commit `a7b0ea18372ef62f337aa828fbe450a69573fe1a`.
- Replaced square tooltip border with custom overlay in `UI/General.lua`; square player portrait is visually covered outside circular aperture (not actual texture masking). Commit `ee438c41419cd961f0b4af212f16d7e52782e594`.
- **OWNER SCREENSHOT #9:** gold ring loads and frames portrait; dark square behind ring is clearly visible and clashes with background. Stats and banners remain correct. Root cause: fallback ring TGA has opaque outer pixels, covering a square region; this was expected from its design but is not acceptable visual fidelity.

## Iteration #10 — native mask trial committed, awaiting owner test

- Added `Media/General/portrait_mask.tga` (128×128 white circular alpha mask) and `portrait_ring_transparent.tga` (gold ring, fully transparent outside). Commit `aea39b6c03bcbc59968d31ccb986ca52fca2f7c5`.
- `UI/General.lua` now conditionally checks `CreateMaskTexture` and `AddMaskTexture` and applies a real circular mask with pcall. If unsupported, falls back to previously tested opaque ring to preserve portrait appearance. Commit `0c118206c3d575d7425335bfa0ad4a90ae7af543`.
- **NOT YET TESTED in Forever**. A square remaining means fallback likely triggered. A disappearing square is visual evidence only; API support still requires explicit diagnostics for certainty.
- Next after owner screenshot: improve header/tab art, frame corners, rank plate and ornament details; do not mark full mockup parity.

## Exact next actions for any agent
1. **Wait for owner screenshot of iteration 10.** Check whether the square behind portrait disappears. If it persists, the client likely lacks mask support and fallback remains active; do not claim actual mask success. Investigate alternate native cropping or transparent portrait rendering without reintroducing square artifacts.
2. The `WHITE8X8` + vertex-color technique is now supported by the owner's screenshot; keep it for opaque panels. Do not reintroduce minimap tracking border for portrait.
3. Then improve layout proportions and asset pipeline toward reference; ensure readable second row, no action-bar overlap, real faction banners and ornaments, correct portrait framing.
4. Add Lua deterministic tests when runtime available, then run; don't mark NOT RUN as PASS.
5. Update this file and `tasks.md` after every test/commit, and run `skills/documentation-sync/SKILL.md` before declaring implementation complete.
6. Keep KB/D, rank, Hoy functional content, multi-character selector out of scope or unavailable as approved. Do not fabricate data.
7. Keep the spec open until owner accepts **both** real data and visual fidelity.

## Current user instruction
The owner explicitly wants ongoing incremental development, in-game testing feedback and a durable step-by-step agent handoff because ChatGPT conversations have context limits. This document is the **entry point for future chats/agents**.

## Iteration #10 — owner screenshot PASS (2026-11-17)

Owner screenshot confirms the square dark portrait background is gone and the gold circular frame renders correctly. This is **visual evidence of circular masking** but does not by itself prove which mask API path executed. Banners, HK=32, PvP deaths=8, HK/D=4.00 and lower cards remain stable. Screenshot supplied in chat, not committed to repo.

## Iteration #11 — committed, AWAITING OWNER TEST

Commit `e1353241894e48931294dbaad878175f07ca7742`: added subtle metallic horizontal header trim, gold selected-General-tab underline and rank-plate side accents using client-tested WHITE8X8. No changes to stats, portrait masking or banner files. **NOT TESTED in client**. Owner should download latest main, run `/reload` and `/ws`, and check header/title, General/Hoy tabs, rank text and new gold accents for layering or clipping. Continue with original ornamental asset pack and reference-image fidelity afterward; do not treat this as final design.

## Iteration #11 — owner screenshot PASS

Owner screenshot shows header gold trim, General tab underline, rank plate accents all render and remain readable; stats stable (HK=32, deaths=8, HK/D=4.00), portrait circular, banners unchanged. Screenshot exists in chat, not repository. Owner requested **larger feature batches per iteration**, not one tiny visual tweak at a time.

## Iteration #12 — larger ornamental pass committed, AWAITING OWNER TEST

Commits `73238105b21acc864700e51d3bbef7a5b6ca07d8`, `89f9a87004a2c4e30f7a417e36126497d37dc912`. Added in one batch: four metallic outer corner accents, layered header trim, small diamond ornaments on four major dividers, shaded main HK and PvP-death section plaques. All drawn using previously tested WHITE8X8; text-background layering fixed before requesting QA. No stats or masking changes. **NOT TESTED IN CLIENT.** Potential compatibility risk: `Texture:SetRotation` on the decorative diamonds. Owner should test `/ws` for Lua errors, title/rank/number visibility, all diamonds and corner accents. If `SetRotation` unsupported, remove/replace rotation. Still not the final painted WoW ornamental texture pack or approved reference parity. Next batch should integrate substantial authored assets, not tiny line adjustments.
