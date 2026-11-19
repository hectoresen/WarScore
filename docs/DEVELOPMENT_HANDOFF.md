# WarScore — live development handoff

**Last updated:** 2026-11-17 (iteration 14 client QA pending).

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

## Localization foundation — 2026-11-19

- Added `Core/Localization.lua` with Spanish default and English catalog for the General view.
- Added compatible `WarScoreDB.settings.language` persistence and temporary `/ws lang`, `/ws lang es` and `/ws lang en` commands.
- General-view copies now refresh when the language changes; no settings UI control was added.
- Implementation is pushed in commit `d6883cc` on `main`.
- Static validation passed with `git diff --check`; client QA is still pending because the addon must be tested inside WoW.
- Static checks and hardcoded visible-copy scan were run; in-client English/Spanish QA is **PENDING**.

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

## Iteration #12 — owner screenshot PASS (2026-11-17)

Four divider diamonds and outer metallic corner lines render; main HK and death sections have rectangular dark plates that look too abrupt compared to approved mockup. Data still HK=32, PvP deaths=8, HK/D=4.00. User supplied screenshot in chat. **Do not add more square opaque plates.**

## Iteration #13 — substantial original asset batch, AWAITING OWNER TEST

- Commit `9c96af3635fc4257b4fc42513ee3f6f54cd850b4`: created original 128×128 transparent 32-bit TGA `Media/General/ornate_corner.tga` and 256×128 feathered alpha `Media/General/section_plaque.tga` with subtle gold strokes; both use the proven TGA format but their particular render is **not yet client-tested**.
- Commit `c45e0bdfa25047957fd0477dda44e69f73073224`: replaced all four simple corner L-shapes with mirrored ornate corner textures; replaced abrupt HK/death rectangular shading with softer feathered art; enhanced header horizontal metalwork; added small gold studs on all six cards. Historical data, portrait masking and banner textures unchanged.
- **Next owner QA:** update from main, `/reload`, `/ws`. Inspect four corners (correct mirrored orientation and texture loading), HK/death soft plaques (no harsh rectangles or obscured labels), header accents, card studs and Lua errors. If textures don't load, inspect paths and TGA alpha. No final visual parity claim.
- **Further planned work:** source and commit exact approved mockup PNG; produce authored title/header frame and WoW-like tabs, integrated rank ribbon and proper faction art, and consider fewer/more compact lower cards without removing approved metrics. Maintain large meaningful iterations.

## Iteration #13 — owner screenshot PASS with corner clipping issue

Owner screenshot: new corner TGA, soft section plaques and card studs render; corners visually extend outside the outer frame and clip at screen edges. Stats remain HK=32, deaths=8, HK/D=4.00; banners and circular portrait stable. Screenshot in conversation, not repo.

## Iteration #14 — visual batch committed, awaiting owner screenshot

Commit `1bac348a3b3011ebcd8704d00b8e2b253d4a0321`: inset four ornate TGA corners by 8 logical pixels from frame edges; replace default General/Hoy grey/red button appearance with a custom dark-and-gold tab skin using native texture layers; add layered metallic top/bottom rules to PvP rank plate. Existing HK/death soft plaques and stats untouched. **NOT TESTED in Forever**. Check corner clipping, tab labels/selected state, rank text, any Lua errors. Today's tab remains intentionally a non-functional placeholder and should not appear active. Next large batch: approved source mockup PNG, painted ornamental frame/title and true faction-specific flags. No full UI approval yet.


## Iteration #15 — unified lower statistics bands, awaiting owner QA (2026-11-17)

- Implementation commit: `412afe0870da13b1c5cf74d5ba7defa6cfa97c3b`.
- Changed only `UI/General.lua`: replaced six separate bordered cards with two full-width ornamental bands, each containing three segments separated by vertical gold rules. Retained existing six field bindings, titles, icons, numbers, unavailable states and refresh logic.
- Both rows use the already client-proven `WHITE8X8` background/rules and native tooltip border, without adding external assets. This is a *structural visual iteration*, not yet faithful painted/bespoke reference artwork.
- **Automated Lua syntax/runtime tests: NOT RUN** (Lua interpreter unavailable in this agent runtime). **Forever client QA: NOT RUN** as of commit. No claim of screenshot parity or visual acceptance.
- **Owner test:** download latest `main`, replace addon, `/reload`, `/ws`. Check both lower rows render as continuous bands with three legible segments, no icon/text overlap, no Lua errors; specifically verify long favorite BG names and `—` unavailable values. Confirm HK 32, PvP deaths 8, HK/D 4.00 unaffected on the known character.
- If successful, next iterations can replace temporary native icons with authored visuals, improve banner/rank/header ornamentation and match the approved reference. Do not erase any client findings from the previous iteration; #14 was pending owner QA in this document.

## Iteration #15 — owner screenshot review (2026-11-17)

- **OWNER SCREENSHOT #15:** two full-width lower bands render in Forever, each with three separated statistics and visible vertical gold dividers. All six icons, headings and values are visible; no obvious clipping or significant text overlap. Existing HK=32, PvP deaths=8, HK/D=4.00 remain unchanged. No Lua error reported with screenshot.
- **Visual PASS (limited):** segmented-band layout is closer to approved reference than six independent cards. Owner has supplied screenshot; this is visual QA evidence, **not explicit final owner acceptance** of the design or proof of every runtime path.
- **Remaining differences:** icons are relatively small; headings in the lower bands need stronger hierarchy; borders are simpler than the ornate beveled reference. Favorite BG long-name content and positive battleground values remain untested in this screenshot.
- **Suggested next pass:** retain the two-band structure; refine content hierarchy and ornamental border styling without altering data sources or recreating six separate cards. All other open visual work remains pending.
- **Automated tests NOT RUN**; no claim of pixel parity or full client QA.

## Iteration #16 — lower-band visual polish, awaiting owner client QA (2026-11-17)

- Implementation commit: `e76c704fb15e417f322dc02881434173d88faa02` (`UI/General.lua`). Iteration #15 owner screenshot confirmed both bands were visible and data remained stable, but final fidelity was not accepted.
- Kept both segmented bands and all six original data bindings. Enlarged native icons from 34 to 42 logical pixels; increased title typography 11 to 12 and regular value size 26 to 28, with a dedicated text column. Favorite BG retains custom 16 font size.
- Added paired metallic horizontal inset rules, dark bevel beside both vertical dividers, and studs on all four band corners. Uses existing native `WHITE8X8` and tooltip border; no new image textures or WoW API dependencies.
- **NOT RUN:** automated Lua syntax/runtime tests (no Lua binary in execution environment). **NOT YET TESTED:** Forever client screenshots and positive/long-name BG examples. This commit is an unverified visual change, not final acceptance.
- **Owner QA:** download latest main; install, `/reload`, `/ws`. Check bands, gold rails, enlarged icons, top/bottom studs, no title/value/icon overlap, especially the longer center and favorite labels; verify numeric data unchanged and no Lua error. Capture screenshot.
- Next action: use screenshot to decide whether to adjust band text spacing or continue with painted header/rank assets. Preserve the owner-approved reference layout and never claim pixel parity without matching-scale comparison.

## Iteration #16 — owner screenshot PASS for visual continuity (2026-11-17)

- Owner screenshot confirms both segmented statistic bands still render after the icon and border refinements. Increased icon size, dual rails, dividers and corner studs are visible; no obvious text/icon collisions in shown empty-stat states. HK=32, PvP deaths=8, HK/D=4.00 unchanged. This is limited visual QA only, not full UI acceptance. Long favorite BG names and nonempty BG values remain untested.

## Iteration #17 — faction rank ribbon; client QA pending (2026-11-17)

- Implementation commits: `e0439827811041940853f51dd9cba95bee60b4cf` and layer correction `5c5cae29fdf579ad4ce30f84ee57b3b81a100c2c`.
- Modified only `UI/General.lua`. The rank plaque is now 452 × 38 logical pixels with dark inset BACKGROUND texture, double horizontal metallic trim, a small native faction emblem in a 48 × 48 bordered badge overlapping its left side, and short symmetrical gold side details. Still displays `Rango PvP · No disponible`; the emblem signifies faction **not an awarded rank**. No change to statistical APIs, data sources, or lower bands.
- Prevented a known child-frame stacking hazard by rendering the inset as a parent BACKGROUND texture rather than a child Frame (which could occlude rank text). Uses previously working native UI textures; however this exact composition has not been tested in Forever.
- **QA status:** native-client test NOT RUN, automated Lua tests NOT RUN, overall visual acceptance still pending. No claim that laurel or ceremonial ribbon parity is achieved.
- **Owner QA next:** install latest main, run `/reload` and `/ws`; check rank text fully legible, emblem and frame centered without collisions with the level text or gold divider underneath, correct Horde icon, unaffected portrait and bands, no Lua error. Send screenshot. If badge overlaps/visually weakens the rank label, iterate geometry; keep rank unavailable until API is verified.

## Iteration #17 — owner screenshot visual review (2026-11-17)

- Screenshot confirms the rank plaque, left Horde emblem and unavailable-rank label are visible in Forever. Main counters remain HK=32, PvP deaths=8, HK/D=4.00; both segmented lower rows still render. No obvious blocking overlap with adjacent elements. Short gold strokes at the right of the plaque appear less like the approved ornate ribbon; further asset-based polish remains pending.
- **LIMITED VISUAL PASS**, not final owner acceptance; the PvP rank is still correctly unavailable and no automated tests were performed.

## Iteration #18 — crossed-swords header medallion, awaiting owner QA (2026-11-17)

- Implementation commit: `798950d80103c68e42a9c06663caa76be75e00c5` in `UI/General.lua`.
- Added an ornamental crossed-swords medallion overlapping the top-left part of the header, using a native `Ability_DualWield` icon and the existing client-tested transparent portrait-ring TGA. It is purely decorative, not a rank indication. The new element intentionally avoids introducing fresh binary assets or new client API dependencies.
- Shifted the General/Hoy tab pair rightward from x=30 to x=115 so the new medallion does not occlude the selected tab. All data bindings, portrait, banner and rank rendering, lower bands, and tab click behavior remain unchanged.
- **QA pending:** install latest main; `/reload` then `/ws`. Check the medallion texture loads, the crossed swords remain visually centered, there is no square/opaque halo outside the circular ring, tabs remain clickable/readable, and title, corners, portrait and close control remain unobstructed. Especially inspect the medallion's dark square backing at 46×46 relative to the ring aperture. Send screenshot.
- **Tests:** automated Lua syntax/runtime NOT RUN (no Lua binary available); no Forever-client QA for iteration 18 yet. Do not claim visual fidelity to the original ornate medallion; this is an intermediate step with native icon art.

## Iteration #18 — owner screenshot review (2026-11-17)

- Owner screenshot confirms header medallion (ring + swords icon) renders in Forever, tabs remain readable and placed to its right, and close button/title are unobstructed. HK=32, PvP deaths=8, HK/D=4.00 and two lower bands unchanged.
- **Visual defect:** swords icon and dark backing have noticeable square edges inside the circular medallion, unlike reference ornamental round badge. No Lua error was reported in screenshot, but test coverage is limited and not full acceptance.

## Iteration #19 — header medallion circular masking, awaiting client QA (2026-11-17)

- Code commit: `2bff115d70203997b63feb09e11b29645ad76b77` (`UI/General.lua`).
- Applied guarded `CreateMaskTexture`/`AddMaskTexture` with existing `portrait_mask` TGA individually to swords icon and dark backing disc. Ring remains `portrait_ring_transparent`. Avoids new assets and leaves previous location/size of outer medallion untouched.
- If masking is unavailable, hides the square dark backing and reduces the unmasked icon to 36 × 36 (intentional limited fallback); does **not** claim circular rendering in fallback mode. The artwork still uses a provisional native `Ability_DualWield` icon, not the final hand-painted crossed-swords reference.
- No statistical data, tab behaviors, rank state, banners, or two-band layout changed.
- **Owner QA pending:** download latest main, `/reload`, `/ws`; check both the swords icon and its dark disc are visibly circular with no square edges, and the medallion remains correctly aligned. Watch for missing icon/black artifacts and confirm existing metrics are unaffected. Send screenshot. Exact masks not yet client tested.
- **Automated tests NOT RUN;** in-game iteration #19 QA NOT RUN; full visual fidelity and MVP acceptance remain outstanding.

## Iteration #19 — owner screenshot review (2026-11-17)

- Owner screenshot shows the crossed-swords icon visually clipped within the circular gold medallion, with the previous square framing no longer visible. Portrait, banners, rank unavailable label and segmented lower bands remain visible; HK=32, PvP deaths=8 and HK/D=4.00 unchanged.
- **Limited visual PASS** for circular medallion appearance; underlying mask API path not instrumented, no automated tests, and no final acceptance of painted reference parity.
- **Observed issue:** the inactive "Hoy" tab again appears red in this screenshot, likely caused by the native `UIPanelButtonTemplate` state textures competing with the custom skin. General's active styling is not clearly distinguishable.

## Iteration #20 — independent tab styling, awaiting owner QA (2026-11-17)

- Code commit: `c1c634b69ceba8afec2afe9bf3a27b89dcf8e2b8` in `UI/General.lua`.
- Replaced `UIPanelButtonTemplate` with plain native `Button` frames for General and Hoy. Rebuilt `skinTab` with explicit native `WHITE8X8` background and gold perimeter rules, plus dedicated FontString. General has an amber/dark active panel; Hoy has a muted charcoal inactive panel. General remains visually selected without invoking `:Disable()`; Hoy keeps its existing placeholder click message.
- The icon/medallion, stats, faction banners, rank ribbon, portrait and segmented lower rows are unchanged.
- **Owner QA pending:** install current main, `/reload`, `/ws`, verify General appears selected, Hoy does NOT appear bright red, both labels are legible, Hoy click still shows coming-soon message, and no Lua error appears. Send screenshot.
- Native-client iteration 20: NOT RUN. Automated Lua tests: NOT RUN (Lua interpreter unavailable). Do not mark overall design or MVP accepted.

## Iteration #20 — owner screenshot review (2026-11-17)

- Screenshot from Forever confirms General now has the gold selected look and Hoy is dark/inactive rather than red. Labels are readable; header medallion, portrait, rank plaque, main stats, and two lower bands render normally. HK=32, PvP deaths=8, HK/D=4.00 remain unchanged.
- **Limited visual PASS** for tab styling. Hoy click-message functionality not independently demonstrated in the screenshot; no Lua error was reported, but this is not full runtime QA or owner acceptance.

## Iteration #21 — HK hero emphasis, awaiting owner client QA (2026-11-17)

- Code commit: `335dd171e3d5412077a2d4751652f452d7148ac8` in `UI/General.lua`.
- Increased the honorable-kills headline from 23 to 24 px and the main lifetime HK number from 57 to 64 px. Added native FontString drop shadows and three symmetric, graduated gold strokes on both sides of the number. These flourishes are provisional ornaments, not the approved painted laurel art.
- Left the historical statistics adapter, refresh values, denominator semantics, portrait masking, tabs, rank, PvP-deaths block and two bottom bands untouched.
- **Owner test:** latest main, `/reload`, `/ws`; check all three HK digits and longer lifetime values remain centered/legible, the decorative lines do not collide with ratios or labels, and no Lua errors occur. Send screenshot; compare HK's new visual emphasis with target. Positive/high-digit value layout still requires testing.
- **Status:** iteration 21 native-client QA NOT RUN, automated Lua tests NOT RUN, not visually approved or pixel-matched.

## Iteration #21 — owner screenshot visual review (2026-11-17)

- Owner screenshot confirms increased HK number and heading render clearly, with HK=32, deaths=8, HK/D=4.00 unchanged. No obvious label overlap in this example. The new horizontal side strokes are visibly disconnected and do not resemble the reference's laurels. No Lua error reported; automated checks and large HK values remain untested. **Limited visual PASS for typography, FAIL for ornamental fidelity**.

## Iteration #22 — mirrored HK laurel sprigs, awaiting owner QA (2026-11-17)

- Commit: `4ecf70535e32e2c7ee07c01897706ca09261a683` in `UI/General.lua`.
- Replaced six detached horizontal bars around lifetime HK with eight small symmetrical stem-and-leaf motifs (four per side) made with existing WHITE8X8 native textures and `Texture:SetRotation`, previously observed working for divider diamonds. Kept the HK headline and 64 px FontString number. No new assets or data/API changes.
- Artwork is **provisional** and not claimed to match the reference's actual painted laurel wreaths. If the leaf shapes remain unconvincing, prefer an original transparent TGA laurel asset rather than stacking more rectangular primitives.
- **Owner QA pending:** install current main, `/reload`, `/ws`; check leaf spacing around HK, number legibility, no clipping/artifacts or Lua errors; verify stats, portrait, tabs, rank plate and lower bands unchanged. Send screenshot.
- Client test iteration 22: NOT RUN. Automated Lua checks: NOT RUN. No full visual acceptance.

## Iteration #22 — owner screenshot visual review (2026-11-17)

- Owner screenshot confirms the mirrored handmade HK sprigs render in Forever. The motifs are blocky, angular and significantly unlike the approved painted laurel wreaths; **visual FAIL for fidelity**. The HK value 32, PvP deaths 8 and HK/D 4.00 remain readable, with both lower statistic bands intact. No Lua error was reported, but automated tests remain unrun.

## Iteration #23 — original transparent HK laurel artwork, awaiting client QA (2026-11-17)

- Asset commit `c73a15f1e2be0fa8fd7c350b5bcee96d5a202544`: created `Media/General/hk_laurel.tga` as original programmatically drawn 128×128 uncompressed 32-bit BGRA TGA, top-left origin, alpha transparency. It uses curved golden stems and small tapered leaves; not copied from WoW or third-party textures.
- UI commit `52281582e82c8cecc23b818516e8622bbab98c44`: removed the native WHITE8X8 HK sprigs and rendered the authored TGA twice, mirrored horizontally for symmetry. Each is displayed at 108×108 logical pixels, at ±190 x from window center, top -384. No modification to HK dynamic number, data adapter, rank, tabs, portrait, or two lower bands.
- **Client QA NOT RUN** for iteration 23. Owner should install current main, `/reload`, `/ws`; check both laurels load with transparency, no square backgrounds, correct mirror orientation, no text collision and no Lua errors. Also inspect whether the arrangement resembles the approved reference better than iteration 22. If not, refine TGA artwork/position rather than returning to primitive rectangle stacks.
- Automated Lua tests: NOT RUN. No claim of pixel parity or overall MVP acceptance; known rank and KB/D remain unavailable.

## Iteration #23 — owner screenshot QA (2026-11-17)

- Owner screenshot confirms both original transparent TGA HK laurel sprites render with mirrored orientation and no opaque square artifacts. HK=32, deaths=8, HK/D=4.00 remain legible; bottom bands and portrait remain intact. **Limited visual PASS for texture loading and appearance**, not final owner acceptance or automated functional QA.
- Visible flaw: both laurels extend down to the HK/ratio horizontal divider, making the composition appear cramped; adjust position/size before continuing other ornamentation.

## Iteration #24 — HK laurels alignment adjustment, awaiting client QA (2026-11-17)

- Code commit: `cf68d2db26d833ed24a3acd82fa5dae84133303f` in `UI/General.lua`.
- Kept existing `Media/General/hk_laurel.tga` and two mirrored instances; changed display dimensions 108×108 to 96×96 logical pixels, x centers ±190 to ±183, and top position -384 to -371. The goal is to raise laurels above the ratio separator and visually frame the HK number more closely. No new assets, API usage or data changes.
- **Awaiting owner screenshot** in Forever: `/reload`, `/ws`; verify laurel positions are better balanced, neither touches divider or HK text, no texture or Lua errors, same stats. This adjustment has NOT been client-tested; large HK values and different scales remain untested.
- Automated Lua tests: NOT RUN. Full UI fidelity and MVP acceptance still outstanding.

## Iteration #24 — owner screenshot review (2026-11-17)

- Owner screenshot confirms the smaller 96×96, higher-positioned TGA laurels frame the HK number without reaching the ratios divider. Both render with alpha, correct mirrored orientation and no opaque square. HK=32, PvP deaths=8, HK/D=4.00; lower bands and portrait remain visible. **Limited visual PASS**, not final UI acceptance. No Lua errors reported, but automated checks and other UI scales not exercised.
- Owner explicitly permits **more substantial iteration batches**, provided changes remain focused, traceable and owner-tested.

## Iteration #25 — combined frame, header and rank ornamental pass; client QA pending (2026-11-17)

- Code commit: `9544b6ce4d20bdce8e783f8ca2ddd0a5a1355ec1` (`UI/General.lua`).
- **Outer frame:** added paired thin gold/dark vertical inset rails on both sides (within frame corners) to increase metallic depth, keeping the proven tooltip border and mirrored corner TGA.
- **Title header:** added a subtle 470×49 feathered `section_plaque` texture under the dynamically rendered title, increased title 31→32 and added a restrained shadow. Maintained medallion, close button, and General/Hoy tabs and their click behavior.
- **PvP rank ribbon:** removed the three disconnected mechanical line accents on both sides; replaced them with two small 44×44 mirrored instances of the client-tested `hk_laurel.tga` texture. Narrowed/recentered rank label within the existing ribbon so it stays distinct from side ornaments and left faction badge. Rank still says `Rango PvP · No disponible` until historical semantics have been verified; do not conflate the faction emblem with actual rank.
- **No changes** to Lua statistics, HK/deaths labels, ratio logic, portrait, banners, lower two segmented bands, or saved character data. This pass introduces no new binary assets or unknown game API.
- **Owner QA PENDING:** download latest main; `/reload`, `/ws`; inspect header title plate for clipping/layering, close button, both perimeter rails and four corners, rank label/badge/laurels for overlapping, no Lua errors. Confirm previous HK 32 / deaths 8 / HK-D 4.00 and the two bottom bands remain unaffected. Send screenshot.
- **Automated Lua tests: NOT RUN.** Native-client iteration #25: NOT RUN. Full ornamental fidelity/pixel matching, long rank labels and alternative display scales remain unverified.

## Iteration #25 — owner screenshot and explicit visual rejections (2026-11-17)

- Owner screenshot shows existing frame, main stats and segmented lower bands intact (HK=32, PvP deaths=8, HK/D=4.00). It also shows a tiny, one-sided remnant of a laurel on the right of the rank ribbon: the rank ornament from iteration 25 is **NOT approved**.
- Owner explicitly **rejects the upper-left circular swords medallion** (unnecessary and clipped), considers faction flags unfinished, and requests removal of redundant '(i)' next to both HK/D and KB/D because definitions already appear below each value. Owner says overall visual fidelity is still far from the expanded mockup and authorizes larger cohesive style iterations. Do not label those assets accepted.

## Iteration #26 — visual cleanup and enlarged banners; owner QA pending (2026-11-17)

- Code commit: `8bcddedfe0186d3f4e4cb7ea26f76b10f86232d1` in `UI/General.lua` (published to `main`).
- Removed the **entire top-left circular swords medallion** and its local masking code; no upper-left icon remains. Returned General/Hoy tabs from x115 to x38 and added a shared 296×2 metallic rail below them. General remains selected; Hoy remains a coming-soon action.
- Removed '(i)' from both ratio headings; descriptive lines beneath the ratios are unchanged.
- Removed the small, uneven ribbon laurel attachments; retained the actual faction emblem on the left and a slightly wider unobscured `Rango PvP · No disponible` label. No unverified PvP rank introduced.
- Banner presentation: enlarged each banner frame from 106×198 to 126×228 and shifted it slightly upward, enlarged faction emblems from 48 to 56, with metallic top fittings. Horde continues to use the original `banner_horde.tga` (still provisional/far from the approved reference). For Alliance a neutral dark blue-grey rectangular fallback replaces the incorrect Horde cloth until authored Alliance banner art exists; **this fallback is not final artwork**.
- Data contracts, main HK laurel texture, portrait and two segmented lower statistics bands are unchanged. No new asset files were added.
- **Owner QA:** install latest main, `/reload`, `/ws`; confirm no upper medallion, tabs are unobstructed, both ratios have no '(i)', rank label readable without dangling small laurel, and both flags have visible irregular hem without crowding portrait/identity. Verify 32 HK / 8 PvP deaths / HK-D 4.00 in tested character; check no Lua errors. Test Alliance later to ensure its temporary flag does not display Horde cloth.
- **Automated Lua runtime/syntax checks NOT RUN** (no Lua binary in agent environment). **Native-client iteration 26 QA NOT RUN**; screenshot comparison and owner acceptance pending. Do not represent larger banners as final painted cloth or pixel parity.
- Next substantive iteration after screenshot: create/verify genuine faction-specific cloth art, richer rank ribbon and frame treatment with original alpha textures; avoid replacing rejected medallion or restoring redundant info symbols.

## Iteration #26 — owner screenshot review (2026-11-17)

- Owner screenshot confirms the upper circular swords medallion is removed, the General/Hoy tabs are readable and unobstructed, both ratio labels have no '(i)', and the PvP rank label remains readable. HK=32, deaths=8, HK/D=4.00, lower two segmented bands and player portrait remain visible.
- Both Horde banners appear larger with visible torn bottoms and fittings, but still lack the rich layered fabric and emblem integration of the original expanded reference. **Limited client-visual PASS** for the removal/rebalancing changes; **NOT accepted** for final banner/rank fidelity. No Lua error reported, but no automated/other-resolution proof.

## Iteration #27 — authored faction banners and metallic ribbon (2026-11-17)

- Asset commit `46f238d28d140ce777fc8c04b8c6b892df35bad1`: added original `Media/General/banner_horde_v2.tga` and `banner_alliance_v2.tga`, each 128×256 uncompressed BGRA 32-bit TGA with alpha, top-left origin, faction-specific reds/blues, shaded longitudinal folds, stitch seams, scalloped torn lower hem, and top metallic fitting. Original raster artwork authored for WarScore, not sourced/copied from WoW; native faction insignia remains separate.
- Asset commit `00eda9058e671a3d4f405dae76d3a13020b843e7`: added `Media/General/rank_ribbon.tga` as original 512×128 alpha BGRA TGA, a dark burgundy/bronze beveled ribbon with tapered angled ends and fine gold rails. No fictional PvP rank encoded in art.
- UI commit `c601d13767dd370b1c53bcfef25fa461a81b69f0`: `UI/General.lua` now selects the faction-specific v2 banner TGA, uses a larger 59×59 faction icon and adds rivets/mount line, without changing banner placement or player identity. Rank's native rectangular backdrop and flat trim were replaced with the TGA ornamental ribbon behind the existing Horde/Alliance badge and the dynamic text `Rango PvP · No disponible`.
- Preserved the owner's rejection of the upper circular swords medallion and unnecessary '(i)' symbols; did not modify Stats.lua, statistics, multi-character state, HK laurels, portrait, tab behavior or two lower segmented bands.
- **QA NEXT:** replace addon with latest main, `/reload` and `/ws`; verify transparent torn cloth loads for both flags without square artifacts, top fittings and emblems remain aligned; verify new rank ribbon loads fully, its caption is legible and it does not collide with the divider underneath or portrait/name above. Compare composition and colors against approved reference. Confirm 32 HK, 8 PvP deaths and HK/D 4.00, plus lower bands. Check Lua errors. Later test Alliance character to verify blue cloth and correct insignia.
- **Not validated in Forever yet.** Automated Lua tests NOT RUN. Large/offline values, varied UI scales, and exact reference fidelity still unverified. This is an intermediate ornamental iteration, not visual acceptance.
- **Next if verified:** replace square faction icon art with original alpha heraldry, strengthen outer frame and title treatments, and polish lower-band iconography in a cohesive batch. Keep rejected medallion removed.

## Iteration #27 — owner screenshot review (2026-11-17)

- Owner screenshot confirms the new Horde v2 banner artwork renders with visible folds, top gold fittings and torn lower hems, without obvious opaque rectangles or overlap with the character portrait. The new angular rank ribbon texture also loads and the unavailable-rank caption remains legible. HK=32, PvP deaths=8, HK/D=4.00 and the lower segmented bands stay visible.
- **Limited client visual PASS for Horde texture loading**, not final art acceptance. The right tip of the rank ribbon appears mechanically striped and awkward; Alliance art has NOT been tested. Automated Lua tests, larger counts and other scale/resolution tests remain NOT RUN.
- Owner requests a new information hierarchy: **HK, then PvP deaths, then HK/D and KB/D**, without changing the lower bands. Owner also requests continuing visual refinement.

## Iteration #28 — reorder lifetime counters above ratios and adjust rank ribbon (2026-11-17)

- UI code commit `1d4f60b2751f207e00f651fa45e3f607e12e63d7` on `main`; changed `UI/General.lua` only.
- Retained HK hero headline/value at their approved positions. Moved the red PvP-deaths headline/value immediately below HK (title y=-483; value y=-518). Moved the gold HK/D and KB/D two-column section into the lower region (headings y=-602, values y=-634, descriptions y=-677), with a single shared center divider and new intermediate divider y=-590. Kept the lower-band entry y=-727 and final central divider y=-714, so overall window dimensions and already-tested bands remain unchanged.
- Narrowed rank ribbon texture display from 484×58 to 452×52 logical pixels to reduce awkward overshoot of the tips. Did not replace source asset or modify the unavailable-rank label/faction emblem.
- No changes to data sources, HK/D or KB/D semantics, denominator handling, faction banners, portrait, General/Hoy navigation, HK laurel texture, or saved variables. Never fabricate unknown KB/D/rank.
- Static source verification confirmed one death field, ordering HK → PvP deaths → HK/D → lower stats, and preservation of the removed medallion and '(i)' UI elements. **This is code inspection, NOT a client render test.**
- **Owner QA pending:** install latest main, run `/reload`, `/ws`; inspect HK laurels and number, new PvP-deaths position, ratio headings/values/descriptions and all separator lines for overlaps. Check rank ribbon tips and legibility, both segmented lower rows, 32 HK / 8 deaths / HK-D 4.00 on the known character and absence of Lua errors. Send screenshot.
- Automated Lua tests and actual iteration 28 native-client tests: NOT RUN. Other UI scales, long numbers and Alliance banner still not verified; feature remains open and visually unaccepted.

## Iteration #28 — extended ornamental polish before owner QA (2026-11-17)

- Owner requested **expand the current iteration before their next screenshot**, so the previously recorded iteration 28 reorder and ribbon fit are still UNTESTED in Forever. This is the second commit of the same pending iteration, **not a new accepted visual baseline**.
- Second code commit: `715ce908ef877a87ea2b365649f84df71c26c29a` in `UI/General.lua`.
- Increased PvP-deaths value from 48 to 52 logical font pixels, added restrained red shadow and two thin symmetrical bracket lines to give the second primary lifetime counter more hierarchy.
- Ratios after deaths: changed HK/D and KB/D headings to 20 px gold, numbers to 39 px cream with soft shadow, and descriptive captions to muted cream, while retaining the exact same meaning, read order and unavailable values.
- Added small native gold studs on the rank-ribbon ends and soft value shadows in both lower segmented bands. No change to banner textures, faction identity, portrait, cards layout, statistics APIs or denominator semantics.
- **Combined QA to perform once after both iteration-28 commits:** install latest main; `/reload`, `/ws`; ensure HK → PvP deaths → ratios are vertically clear without overlapping separators, thin death-section brackets are subtle, rank studs and ribbon tips do not clip, six lower values remain legible, and main metrics are unchanged (32 HK / 8 deaths / 4.00 HK/D in current test character). Check no Lua errors and send screenshot.
- **NOT RUN:** automated Lua tests, WoW Forever client test for both iteration-28 code commits, high-digit and different-scale tests. Not owner-approved or pixel matched.

## Iteration #28 — owner screenshot review and distribution workflow (2026-11-17)

- **OWNER SCREENSHOT:** reorganized structure displays HK 32, PvP deaths 8 immediately underneath, then HK/D 4.00 and unavailable KB/D, followed by both segmented lower stat bands. No obvious overlap in the screenshot. Horde banners, portrait and ribbon continue rendering. **Limited visual PASS for layout; not final approval.** The tiny orange bars left/right of PvP deaths looked disconnected; the ribbon's right-hand striped ornament still looked faulty. Automated Lua tests, click behavior, nonempty battleground data and alternative UI scaling still untested.
- New *visual cleanup* code commit `d8dcd86d8af61e80d0ea8907e323d5781ea12d85`: removed the floating death-side bars and cropped the center ribbon TGA via `SetTexCoord(0.09,0.91,0.10,0.90)`, with its display reduced to 446×46, to hide hard striped ends. The new crop still needs an actual Forever screenshot.
- **Owner's distribution requirement:** NEVER send a GitHub source/archive ZIP as the game installable package again. Keep OpenSpec/docs in the repository but deliver only `WarScore/` with TOC-defined Lua files and TGA actually referenced by those scripts.
- Reproducible Python 3 packaging script committed as `tools/package_addon.py` (commit `73ed964de1bb5bee3ec08c834b28273927bb3785`). It builds `dist/WarScore.zip` using only `WarScore.toc`, its declared scripts and the media paths referenced by those scripts, with archive validation.
- **Clean install ZIP published** as GitHub blob/commit `fcfaba2bd8367ba9eaff97f963a78481a94c1a6d`, at `dist/WarScore.zip`, accessible as `https://github.com/hectoresen/WarScore/raw/refs/heads/main/dist/WarScore.zip`. The package has exactly 15 files under `WarScore/`: 1 TOC, 5 Lua, 9 TGA, **no OpenSpec, docs or tools**. The archive was independently verified by reading it back from GitHub and checking ZIP central-directory offset, header count, entry names and structure (1,017,468 bytes). It is a valid uncompressed ZIP; it is not a gameplay test.
- **Critical for future agents:** after EVERY addon code or referenced media change, rebuild and replace `dist/WarScore.zip` BEFORE giving the download link; docs-only changes do not require rebuilding. `main.zip` is NOT the addon distribution.
- **Next owner QA:** download just the clean ZIP, unzip its `WarScore` folder under `Interface/AddOns/`, replace previous folder, run `/reload` then `/ws`. Check that missing development files do not affect runtime, HUD loads, new death-section cleanup and cropped ribbon render correctly, all six lower stats and historical numbers remain visible, no Lua errors. Send screenshot.
- No in-game client validation of this last cleanup/clean ZIP yet. Automated tests NOT RUN, full visual parity NOT accepted.

## Iteration #28 clean distribution — owner screenshot review (2026-11-17)

- Owner screenshot of the clean `WarScore.zip` confirms the addon launches in Forever; the layout is HK → PvP deaths → ratios → two lower rows, with Horde banners, portrait, rank ribbon and counters HK=32, deaths=8, HK/D=4.00 visible. This visually validates the clean packaging flow at least for the tested Horde character.
- The floating death brackets were removed and no longer appear. Ribbon is readable, though exact mockup fidelity is still pending. Owner explicitly wants **PvP deaths smaller and less visually dominant** while keeping the section visible, plus continued styling work.
- No Lua errors reported in screenshot, but automated test status remains unverified. Alliance banner, nonempty BG history and large numbers still untested.

## Iteration #29 — subdued PvP deaths and visual consistency (2026-11-17)

- UI commit `4648656484625a85eee6a4870ca85eb67d208dbc` on `main`.
- Deaths secondary KPI: softened the `section_plaque` (570×108 alpha 0.72 → 500×91 alpha 0.48), reduced the title 20→17 pixels with muted dusty-red and the number 52→39 pixels, moved title/value slightly down, and softened the text shadow. HK continues to dominate visually. The order HK → deaths → HK/D and KB/D is untouched.
- Removed tiny isolated gold studs from the rank ribbon (appeared like rendering artifacts); kept rank label and added subtle text shadow. Header name increased 32→33. Lower band icons now have dark 48×48 mounts with 40×40 icons for consistent visual weight across six segments; values and bindings unchanged.
- Neither Lua statistics nor SavedVariables, TGA artwork, faction selection, portrait masking, lower-band layout or tab behavior changed. No rejected sword medallion or redundant '(i)' was restored.
- **Clean distribution rebuilt:** ZIP commit `bc269a4c1c601928bead438a1173d0931d73ca18` updates `dist/WarScore.zip` on `main`, with one `WarScore/` top-level directory holding 15 files: 1 TOC, 5 Lua and 9 TGA. GitHub confirms the new binary SHA `d7e528a5fa874c255e281cd5eb12d61c1dad8131`. The ZIP was constructed with correct local headers, central directory, CRC32 values and entry counts before upload. Note: GitHub contents connector returned zero bytes on the attempted readback for this updated ZIP, so independent remote byte revalidation was not possible this time; do not claim it passed a separate downloaded ZIP check.
- **Owner QA pending:** install `https://github.com/hectoresen/WarScore/raw/refs/heads/main/dist/WarScore.zip`, `/reload`, `/ws`. Check the deaths KPI feels appropriately secondary, all six lower icons render on dark mounts without overlap, rank/header remain legible, and original HK=32, deaths=8, HK/D=4.00 persist. Confirm no Lua errors. The user should receive ONLY the clean ZIP, never source `main.zip`.
- Automated Lua tests NOT RUN; client test for iteration #29 NOT RUN; overall visual fidelity NOT approved.

## Distribution hotfix — corrupted iteration #29 ZIP (2026-11-17)

- Owner reported that Windows could not open/extract the previous `dist/WarScore.zip`; **confirmed release failure**, even though code/UI files were unaffected. Root cause was an ad hoc manually assembled ZIP, not adequately tested after uploading. That manual distribution is invalid and must never be reused or described as verified.
- Added CI workflow `.github/workflows/package-addon.yml` (commit `340932f6c9288a1f2bf3adde282e220c98dbf474`): on changes to addon code/media/packager, GitHub Actions runs standard Python `tools/package_addon.py`, `unzip -t`, and `ZipFile.testzip()`, asserts 15 runtime files under `WarScore/` and excludes documentation/OpenSpec/tools, then commits the package. GitHub Actions generated corrected ZIP in commit `b71a53e23341d7d821560f621022c55f42219ad3`.
- Corrected `dist/WarScore.zip` blob SHA: `9a7ccc36c299f41b3ae45f4ac379ea5f675454f5`, compressed size 107,767 bytes. Connector readback now returns full base64, whose decoded central directory was independently checked: 15 entries, Deflate method 8, correct offsets and complete End of Central Directory, no extra development content. CI also ran its unzip and CRC checks before committing.
- **Correct direct-download URL:** `https://raw.githubusercontent.com/hectoresen/WarScore/main/dist/WarScore.zip`. Prefer this URL over a GitHub page/HTML redirect if downloaded archive appears corrupted. Do not claim owner Windows extraction or WoW Forever runtime verified until screenshot/feedback.
- For subsequent iterations: only use CI/Python standard ZIP generation; never hand-assemble ZIP binaries using JavaScript. Always check CI-generated commit and inspect archive structure before sharing.

## Iteration #29 — owner screenshot review (2026-11-17)

- The owner tested the **fixed, CI-produced clean ZIP successfully in WoW Forever**. The latest screenshot shows HK=32, PvP deaths=8, HK/D=4.00, the subdued red deaths counter, both lower segmented statistic bands, Horde banners, centered portrait and rank ribbon. It visually confirms the corrupted archive incident is resolved for this tested version; no error text appears in the screenshot, but automated Lua tests were not run.
- The smaller PvP-deaths area now visibly reads as secondary to HK. **Limited screenshot PASS**; this is not the owner's final approval of the visual reference. Square-looking faction emblems, flat rank presentation and band styling remain further fidelity work.

## Iteration #30 — banner badge integration, two-tier PvP rank and band detail (2026-11-17)

- UI commits: `6e964571a191aa0e5da4c8aea3a9dca5cf6dc34a` and corrective `77190bd28e5ce0a985ebafa57a458a81d84f2aac` (`UI/General.lua`).
- Horde/Alliance cloth art and proportions remain intact. The native square faction icon displayed over each banner is enlarged and given a client-guarded circular alpha mask, reusing the already working `portrait_mask.tga`. On clients without mask support, the original native icon falls back to 52×52 with cleared/reapplied points, avoiding overconstrained texture anchors. This should visually integrate faction emblems with cloth but **has not been tested in-game** yet.
- Rank presentation changed to a two-tier centered inscription: small `Rango PvP` caption above the truthful dynamic `No disponible` value, with the faction crest retained inside its own left ornament. `refresh()` now only sets the dynamic value to `No disponible`; no claim of an actual rank. Existing TGA ribbon remains behind these labels.
- Added subtle vertical bronze accent beside each lower-band icon and slightly increased feathered header-title plaque opacity. Retained HK-first hierarchy, subdued PvP deaths, original HK laurels and both three-section lower bands. User-rejected upper swords medallion and redundant ratio '(i)' remain absent.
- **Owner QA pending:** install regenerated clean ZIP only (never repository archive), `/reload`, `/ws`; check banner icons blend without square backgrounds and without disappearing, rank caption/value and crest do not collide, six lower sections remain legible, HUD numeric values remain 32 HK/8 deaths/4.00 HK-D, no Lua errors. Test Alliance art in later QA. If masked icons look worse than reference, revise rather than label approved.
- The automated GitHub Actions packager must update `dist/WarScore.zip` after these Lua changes. Verify ZIP has 15 files and standard compression before delivering. Automated Lua gameplay tests and reference pixel-parity remain unverified.

## Iteration #30 — owner screenshot and install-version discrepancy (2026-11-17)

- Owner screenshot after the iteration #30 delivery shows the UI functional with HK=32, PvP deaths=8 and HK/D=4.00; the overall layout, Horde banners and lower segmented bands are intact. However the rank visibly remains a *single line* reading `Rango PvP · No disponible`, and banner emblems still appear as opaque square inventory icons. These are inconsistent with the two-tier caption/value and attempted masking in current `UI/General.lua` and indicate that the screenshot may show an older installed build. The screenshot alone does not prove the cause. **Do not claim iteration #30 has been validated in game.**

## Iteration #31 — version diagnostic and two-line rank fit (2026-11-17)

- Code commit: `08875a3f0dce9de8d7adcd3ceb11a46fa6e42548` in `UI/General.lua`.
- Added `/ws version`: writes `WarScore UI iteración 31` to the default chat frame, without opening the UI; `/ws` and `/warscore` retain existing behavior. This permits precise testing of which UI build WoW Forever has loaded.
- Rank ribbon frame height increased 38→42, its caption and unavailable dynamic value fitted separately with adjusted point offsets/widths, keeping the faction crest and honest unavailable state. No PvP statistics or persistent data changed.
- **Verified clean package**: GitHub Actions generated commit `af41bed80990d76c004092d1b4834560c2908c85`, `dist/WarScore.zip` blob SHA `3b2f0713efa351ca8d16bc3720599d958c7be775`. Connector readback verified ZIP central directory and 15 Deflate entries; the ZIP's `WarScore/UI/General.lua` CRC32 (`0d8647e0`) and uncompressed length match current repo source. 108,209 bytes. No docs/OpenSpec.
- **Owner test (important):** delete the previous `Interface/AddOns/WarScore` directory, extract the new clean ZIP so the structure is exactly `Interface/AddOns/WarScore/WarScore.toc`, run `/reload`, enter `/ws version` and confirm **31**, then run `/ws` and send screenshot. Inspect two-line rank and banner emblems. If version 31 shows but rank is still single-line or masks fail, investigate client masking/fonts/layout rather than attributing it to stale installation.
- Owner client test, gameplay QA, other factions/UI scales and Lua automated tests: still NOT RUN for iteration #31. Overall design remains unaccepted.

## Iteration #31 — owner client verification and screenshot (2026-11-17)

- Owner explicitly ran `/ws version` and supplied chat output **`WarScore UI iteración 31`**. Screenshot confirms the rank is now two-tier: `Rango PvP` above `No disponible`; both faction emblems on Horde banners are circularly masked and the rest of the UI remains stable. Stats HK=32, PvP deaths=8, HK/D=4.00 and the two lower bands remain visible. The previously suspected outdated client install is no longer an issue for this screenshot. **Limited native-client PASS** for 31, not final design acceptance.
- Remaining visual issues: two-line rank text slightly crowds the lower ribbon edge; faction badges remain prominent as independent icon cutouts instead of blended cloth artwork. The approved original artwork is still substantially richer than the live implementation.

## Iteration #32 — rank spacing and more restrained faction heraldry (2026-11-17)

- Code commit `edfed05fad35bf40c98c5d3cc274adab8b6d2cea` in `UI/General.lua`.
- Updated `UI_ITERATION` to `32` so `/ws version` will explicitly identify this build.
- Adjusted rank caption/value to height 14/19, vertical offsets -1/-16, 12/16px fonts respectively; helps avoid clipping into the divider below. Maintains the two-tier rank hierarchy, left faction crest, true `No disponible` value and the existing ribbon art.
- On both faction cloths, masked banner emblem reduced 70→63px and alpha 0.86→0.76, with placement moved down 5 px; aims to reduce the appearance of square icon graphics hovering over fabric. When client masking is unavailable the original guarded icon fallback remains.
- Slightly softened vertical icon accents inside bottom bands; historical data, dynamic HK laurel, subdued PvP deaths, navigation and lower-band structure unchanged.
- Verified clean CI-built `dist/WarScore.zip`: packaging commit `32239815757023d05295f82e9ef1c9f24f85f5c9`, blob SHA `41f69dddd5cae09239f7350469350d7580d47480`, 108,283 bytes. ZIP readback shows 15 Deflate files all under `WarScore/`; its `UI/General.lua` CRC32 `89540300` and uncompressed byte count match current source; no OpenSpec/docs/tools distributed.
- **Owner QA PENDING**: replace entire WarScore folder with clean ZIP, `/reload`, `/ws version` should show 32, then `/ws`. Check two-line rank within ribbon and smaller/less visually intrusive circular faction emblems, lower bands, no Lua errors; send screenshot. Alliance cloth and alternate scales remain untested. No automated Lua gameplay tests or final design approval.

## Iteration #32 — owner screenshot review (2026-11-17)

- Owner posted screenshot explicitly labeled **UI iteración 32**. The rank's small caption and unavailable value fit inside the plaque and are readable; both masked Horde banner badges are visible, with reduced prominence. Main statistics HK=32, PvP deaths=8, HK/D=4.00 and both lower segmented bands remain unchanged. The screenshot is **limited visual validation**, not overall design sign-off. Client data beyond the shown character, Alliance cloth and different UI scales remain untested.
- The screenshot also shows that the reference's premium layered frame, banner mounting and continuous lower ornaments have not yet been achieved; no final-art approval is implied.

## Iteration #33 — banner hanging hardware, ribbon relief and lower-band finish (2026-11-17)

- UI commit `cf4f4105aea2e9c0a1c633d7de6dc6279568b10d`, changes only `UI/General.lua`.
- Updated `/ws version` diagnostic to iteration `33`. Horde and Alliance banners gain a dark horizontal rod shadow, small metal hanging clasps and a subtle stitch below the circular masked heraldry; faction icon size is 68×68, alpha lowered to 0.68 to soften the badge. Existing masked-icon fallback, TGA torn cloths and faction logic remain.
- Rank ribbon receives a dark inset backdrop and short, symmetrical bronze endcaps rather than disconnected frame fragments. Retains factual two-tier `Rango PvP` / `No disponible` and faction crest. Both lower segmented bands gain a subtle dark inset surface for layered depth; captions are slightly softer, leaving all six icon/value bindings unchanged.
- The overall layout stays HK hero → subdued PvP deaths → HK/D and KB/D → two lower statistic bands. Nothing modifies `ns.Stats`, SavedVariables, available numeric values or unsupported KB/D/rank semantics. Removed upper-left swords medallion and redundant info symbols remain absent.
- **Clean distribution verified:** GitHub Actions commit `b3fe0eb9a14ada8300d484cf433767172bdca8a0` updated `dist/WarScore.zip`; ZIP blob SHA `ae28d0e79f572ac2838358f82623886c9b8236c7`, length 108,681 bytes, 15 Deflate entries under `WarScore/`, none from docs/OpenSpec/tools. Connector readback verified central-directory structure and source CRC of `WarScore/UI/General.lua` matches current repo source. No raw/manual ZIP assembly.
- **Owner QA pending:** install clean ZIP, `/reload`, `/ws version` must display 33, `/ws` then inspect left/right banner clasps and emblems, two-tier rank legibility and bronze endcaps, both complete lower strips, preserved historical values and absence of Lua errors. Send screenshot. Current iteration not yet client-tested or accepted; automated Lua/runtime tests, Alliance and alternative scaling remain open.

## Iteration #33 — owner screenshot review (2026-11-17)

- Owner screenshot shows the two-tier rank label, both Horde cloth banners with circular faction emblems and revised fittings, HK=32, PvP deaths=8, HK/D=4.00, and both segmented lower rows. No major clipping is visible in this example. **Limited visual PASS**, not approval of art fidelity or proof of other UI scales/factions. Exact `/ws version` output for this screenshot was not supplied.

## Iteration #34 — stronger shared lower-band frame and banner stitching (2026-11-17)

- UI commits: `1ab1498cf76a9c72b629c6195c2865029b537448` and anchor correction `fc4f37d38d20a91e4c08563bc663b82c65dc6281`, in `UI/General.lua`. `UI_ITERATION` now `34` for `/ws version`.
- Main changes: subtle gold stitch rails along both banners without opaque backing; paired inner metallic side rules on each unified lower statistics band; small rivets above/below each internal segment divider; increase lower icon mounts from 48 to 52 px and icons from 40 to 44; offset label/value columns slightly to the right and increase regular value size 28 to 30. Keep second-row favorite BG value smaller (16 px) for multiline text.
- A first pass of divider rivets used an incorrect reference point; corrected to the band's `TOPLEFT` to ensure all rivets are placed inside band. The corrections are included before release.
- No changes to statistics adapters, persistent data, unavailable rank/KB-D, HK/deaths hierarchy, two-line rank, portrait, tabs, original textures, or rejected upper-left medallion.
- **Owner QA pending:** install the CI-built clean ZIP, `/reload`, verify `/ws version` displays 34, then `/ws`. Check both lower bands for icon/text overlap, central-divider rivets, long label wrapping and six values. Inspect subtle banner threads and verify prior HK/deaths/ratio values unchanged. Send screenshot.
- This is still a styling preview, not overall design approval. Automated Lua client tests, high-value and Alliance UI tests remain pending. **Never distribute the source repository archive**; only the 15-file CI-generated `dist/WarScore.zip` after validating it matches current source.

## Iteration #34 — owner screenshot review (2026-11-17)

- Screenshot shows larger icons and values in both unified lower bands, the newly adjusted dividers and rivets, faction banners, two-line unavailable-rank plate and main historic stats (HK=32, PvP deaths=8, HK/D=4.00). No obvious clipping/overlap in shown state. The extra small rivets at divider edges read as detached pixels, and the two-band artwork still falls short of the approved continuous ornamental mockup. **Limited visual PASS for function/layout only**, not final visual approval; no explicit version command in screenshot.
- Design direction: favor coherent ornament over increasingly many native white-square studs, retaining the user's desired central hierarchy and rejecting a return to separate six cards.

## Iteration #35 — remove stray decorative pixels, unify band trim (2026-11-17)

- UI code commit: `08409f34c7930466ada0061e5715ad82fb821a5f`. Updated `UI_ITERATION` to `35`.
- Replaced tiny 4×4 scattered rivets at internal lower-band dividers with short 12×2 horizontal caps connected visually to the shared frame, and added one restrained full-band inner-top glint; kept the segmented structure and six data bindings.
- Removed thin isolated 3×20 ribbon endcap strokes; preserved actual metallic ribbon TGA, faction crest, two-level `Rango PvP` and `No disponible` labels.
- Slightly softened provisional native lower icon opacity; no statistical data, saved variables, banner textures, portrait or character-scoped logic changes.
- CI packaging commit `ffebcf6604e2d826530ebfdefc4e855e5b84ee5a` rebuilt `dist/WarScore.zip`. Blob SHA `0f06c5213ce216d122c7fcba0e78727b50004609`, size 109,062 bytes. Read-back confirms 15 Deflate files only under `WarScore/`, valid ZIP central directory, `UI/General.lua` CRC32 `90ff51aa` matches current source. No OpenSpec/docs/tooling included.
- **Owner QA pending:** install clean ZIP, `/reload`, verify `/ws version` reports 35, then `/ws`. Look at shared divider caps, ribbon ends, six icon/value alignments, intact stats and absence of Lua errors. Send screenshot. Automated Lua gameplay tests, varied UI scales and Alliance art tests still outstanding. Visual mockup remains a preview, not approved final.

## Iteration #35 — owner screenshot review (2026-11-17)

- Owner screenshot demonstrates continued stable runtime presentation of HK=32, PvP deaths=8, HK/D=4.00, with `No disponible` for KB/D and PvP rank and both 3-segment lower bands visible. Gold divider caps and two-band frames are visible; no obvious clipping in the shown state. This is limited *visual* evidence, not final acceptance, not proof of error-free scripting or multi-faction layouts.
- The lower rows remain more like technical metric bars than the approved high-fantasy ornamental reference: titles and icon mount hierarchy are undersized, and geometric gold pixels/caps detract from a coherent border.

## Iteration #36 — lower-band hierarchy and ornamental corners (2026-11-17)

- Implementation commit `1fe280b8bb86f1d4c4f1f1e1ae9efb7cfa0311e4` on `main`, changes only `UI/General.lua`. `UI_ITERATION` now `36` for `/ws version`.
- Replaced four square metal studs at each shared lower band with small 30×30 mirrored instances of the **existing proven** `Media/General/ornate_corner.tga`, preserving shared 3-segment bands rather than returning to six boxed cards.
- Removed detached short horizontal caps at internal dividers, keeping the 2-pixel gold separator and adjacent dark bevel. Increased icons 44→47px and mount 52→55px; increased regular value font 30→32px and titles 12→13px, adjusting text column widths and offsets to remain inside each segment. Favorite BG value font remains separately small (16→17px) to allow long battleground names. No new artwork or API dependencies.
- No changes to data calculations, SavedVariables, historical counters, PvP deaths hierarchy, portrait, banners, rank or navigation. Do not restore rejected upper-left medallion or redundant ratio info symbols.
- **Clean packaged build:** CI commit `5bd041deaa49e495f5377abcf5fec37e9621ea8b`, `dist/WarScore.zip` blob SHA `636fea24f85775a49576702a05f1dbc994681360`; ZIP readback 109,051 bytes, 15 Deflate entries under `WarScore/`, source `UI/General.lua` CRC32 `5c36c921` matches packaged version. No source docs/OpenSpec/tools in install ZIP.
- **Owner QA pending:** replace `WarScore` folder with ZIP, `/reload`, `/ws version` should display 36, `/ws`, check small ornate corners, no detached divider caps, icons/titles/values alignment, particularly long middle and final title or a nonempty favorite BG name. Check main values 32/8/4.00 stable; report any Lua errors. Send screenshot.
- Client validation for iteration 36 NOT RUN, automated Lua tests NOT RUN; Alliance/multiple scales and full design fidelity remain open.

## Iteration #36 — screenshot review (2026-11-17)

- Owner screenshot shows the revised ornamental band corners, 3 columns in each of two strips, and fully readable labels/counters. Crucially, **live stats have advanced** to 32 honorable kills, **9** PvP deaths and HK/D **3.56**, consistent with 32/9 rounded to 2 decimal places. This is positive visual evidence of the refresh/update path, but not proof that every data path works. KB/D, battlegrounds and favorite remain unavailable; do not invent these values. No explicit /ws version output or Lua error report.
- Remaining gap to the reference: the two lower strips have nearly identical visual weight although their semantics differ (absolute totals vs secondary rates/favorite). Gold native-style geometry still appears less sophisticated than painted source mockup. The owner has not approved final aesthetics.

## Iteration #37 — first-row counts vs second-row secondary insights (2026-11-17)

- UI commit `af09c4a83547454e9f310592a9d8d9dca8790e06` in `UI/General.lua`. Diagnostic `UI_ITERATION` updated to `37`.
- `statBand` now accepts a fourth optional `secondary` flag; the second strip passes `true`. Its backdrop is subtly darker, border and separators are quieter, icon alpha is reduced, value default size is 29px instead of 33px (first strip), and captions are smaller and slightly muted. The upper totals strip remains the priority. Favorite BG retains its custom 17px size for long names.
- Both strips retain the exact two-band / three-segment architecture, TGA corner ornaments, six data bindings, original icons and all tab/nav/core metrics. Inner icon mounts are slightly reduced to de-emphasize blockiness; caption/value columns adjusted in lockstep. No extra new assets, new API dependence or calculations added.
- **Owner QA pending:** install latest CI-built clean ZIP, `/reload`, `/ws version` should display 37, then `/ws`. Check that the first strip looks stronger than the second and values/text still fit all six segments; observe 32 HK/9 deaths/3.56 HK-D if same character state. Other values may evolve naturally, so do not hardcode screenshots as test assertions.
- Client iteration 37 NOT RUN. Lua automated tests, Alliance view, nonempty BG favorite and alternate UI scales remain untested. Preserve this handoff for the next agent, and do not equate visual checks with final acceptance.

## Iteration #37 — owner screenshot review (2026-11-17)

- Screenshot confirms two unified lower bands with an intentional difference in prominence between totals and secondary insights. No apparent clipping with the wrapped `CAMPOS DE BATALLA JUGADOS` or `CAMPO DE BATALLA FAVORITO` headings in shown empty-stat state. HK=32, PvP deaths=9, HK/D=3.56, and unknown KB/D remain visible and internally consistent. This is a **limited visual QA PASS**, not complete gameplay QA or final design approval.
- Remaining visual mismatch: the six small inventory icons still look like squared tiles inside rectangular mounts, unlike the freer ornamental icon treatment of the reference.

## Iteration #38 — softer icon presentation and restrained band glint (2026-11-17)

- Code commit `1ca616dde82c97af029cf26fa64570704da69e9a` modifies `UI/General.lua`. `UI_ITERATION` is now `38`.
- Reduced the hard-edged framing of the six native icon tiles: replaced the layered icon square and thin vertical gold line with a single low-opacity 50×50 recess, a 48×48 icon, and slight cropping of the outer inventory icon border via `SetTexCoord(0.075, 0.925, 0.075, 0.925)`. Upper totals retain greater icon opacity than secondary insights. Adjusted label/value columns together by 1–2 logical pixels to maintain breathing room; reduced inner top gold glint from 624 to 600 px and softened its alpha.
- No data changes, no new artwork or client-only APIs, no movement of HK/PvP deaths/ratio sections, and no impact on two 3-column bands or their dynamic text bindings. Existing banner and rank artwork unchanged.
- **QA pending:** owner must replace the entire addon folder with the CI-produced clean package, run `/reload`, verify `/ws version` shows 38, and screenshot `/ws`. Inspect six icons: are square icon borders less obvious, is contrast sufficient on both strips, are labels/values intact, and are there any Lua errors? Long favorite BG values and alternative UI scales remain untested.
- **CI packaging requirement:** only share the verified new `dist/WarScore.zip` after the updated UI CRC matches source; never send the source-repository archive.

## Iteration #38 — owner screenshot and explicit banner rejection (2026-11-17)

- Owner screenshot confirms that the two lower metric strips still render, HK=32, PvP deaths=9, HK/D=3.56, and unavailable KB/D/BG data remain correctly distinguished. Their native icon tiles look squarer/more prominent after the previous cropping attempt; do not claim the lower icon fidelity is approved.
- **Critical owner acceptance criterion:** the Horde logo must appear dyed/embroidered/printed **into the banner cloth itself**, like the original concept, not as a separately masked inventory badge. The Horde banners from iterations 27–38 are **REJECTED / NOT ACCEPTED**. If a real integrated result cannot be achieved, remove the badge rather than retaining an obvious sticker. Keep this criterion across future agents and iterations.
- Owner expressly authorizes broader integrated iteration batches instead of repeated minimal ornamental tweaks.

## Iteration #39 — integrated Horde textile artwork and visual hierarchy (2026-11-17)

- Artwork commit `3362440a8829b77da349e7e7ae711b4c93d4dd38` adds `Media/General/banner_horde_embossed.tga`. It is the existing 128×256, 32-bit alpha Horde cloth with a new **original procedural heraldic silhouette** dyed directly into the cloth pixels using a symmetrical angular stamp; color mixes with the original cloth fold/luminance and existing transparency is preserved. It is not a copy of a native Blizzard icon or a guaranteed pixel-perfect representation of the official faction logo; it is a **visual experiment pending client review**.
- UI commit `dc9a424494bd9ab18b7c9d8d492bc70ea06014cb` changes `UI/General.lua` and sets `UI_ITERATION = "39"`. Horde selects only `banner_horde_embossed.tga` and **does not instantiate the previously overlayed faction inventory icon or circular mask**. Alliance retains its previous v2 cloth and masked icon as a temporary, unapproved fallback; Alliance banner integrated art remains TODO.
- Same cohesive pass mildly reduces the independent rank ribbon backing shadow, tones down the second row's frame trim relative to primary totals, and further crops native square icons in the two lower metric strips. The two-tier rank caption, all current layouts, primary HK laurels, stats readback and SaveVariables are unchanged.
- **Clean CI-generated package:** build commit `8d3d5ea8ee6064df05045845a30bad4a650fb044`, ZIP blob `3c120c145da85f238fbae4938412b84b476352bb`, 115,462 bytes and exactly 15 Deflate entries under one `WarScore/` root. Connector readback verified valid central directory, `UI/General.lua` CRC32 `b098ba82` matches the source, and `banner_horde_embossed.tga` CRC32 `1c84469c` matches the newly created GitHub asset. No docs/OpenSpec/tooling or obsolete Horde cloth included.
- **Owner QA pending:** fully replace previous `Interface/AddOns/WarScore` with the clean ZIP, `/reload`, `/ws version` must report 39, then `/ws`. Assess whether the emblem genuinely looks embedded in cloth **and is recognizable enough to read as Horde**, without an overlaid inventory icon, square background, missing image or visible alpha artifacts. If integrated heraldry fails aesthetically, revert to a clean **logo-less** flag rather than restoring the sticker. Also inspect lower icon legibility, rank ribbon and all numeric stats, and report Lua errors if any.
- **Not client-tested** at iteration 39. The new heraldry is not owner-approved, and Alliance artwork, other UI scales, long battleground names and deterministic Lua tests remain open. No claim of final mockup fidelity.

## Iteration #39 — owner screenshot: textile-logo accepted only as direction (2026-11-17)

- The owner submitted an in-client screenshot of the new integrated Horde cloth at iteration #39. The emblem is now truly part of the red textile, with no floating square/circular inventory-icon tile. It is visible but too dark and weakly contrasted compared with the reference; **do not mark the banner or full design approved**. The screenshot also shows six lower-strip icons badly magnified/cropped (parts of swords and shields missing), caused by successive texture cropping/size treatment.
- Lifetime values remain HK=32, PvP deaths=9, HK/D=3.56; all unavailable statistics stay unavailable, as desired.

## Iteration #40 — stronger worn textile emblem, restore full icon silhouettes, rank balance (2026-11-17)

- Added original `Media/General/banner_horde_woven.tga` based on the prior dyed fabric (asset commit `ac32f6449ad8cde16597cd4c1e7ae64cc128a2f9`). Deepened the charcoal-copper pigment and provided subtle warm edge wear in pixels of the same original TGA, preserving the alpha/transparency, folds and torn cloth. It is **not** a separate icon layer. Official trademark/logo fidelity and relative contrast need owner review, not assumed accepted.
- Code commit `06a1730efe53eae167cc9654d6c051f4a855e0ed` in `UI/General.lua` sets `UI_ITERATION = "40"`; Horde uses the new woven artwork directly, retaining NO Horde icon/mask overlay. Alliance remains provisional. Restored all six lower stat icons to full texcoords (0,1), reducing their size 48→44 and softening their backing mount, specifically to address cropped swords and other pictograms in owner screenshot. Rank crest is reduced to 40×40 and internal icon 29×29, and rank inscription recentered slightly, maintaining truthful two-line unavailable value.
- No changes to stat algorithms, data contracts, saved variables, section ordering, portrait, HK laurels, or 2×3 lower bands; do not bring back top-left swords medallion or ratio '(i)' symbols.
- **QA needed:** install current CI-built `dist/WarScore.zip` after verifying it includes `UI_ITERATION = "40"` and `banner_horde_woven.tga`; use `/reload`, `/ws version`, `/ws`. Check emblem visibility and cloth integration without a sticker effect, no missing transparent fabric, six **complete** lower icons, and proper rank alignment; send screenshot. Unknown BG metrics must remain unknown.
- **Status:** owner screenshot verification pending; no gameplay-level automated Lua tests, Alliance test, other UI scales, high numeric counts or final visual sign-off.

## Iteration #40 — owner screenshot validation (2026-11-17)

- Owner screenshot shows the restored **complete** inventory icons in all six lower metrics (swords, shields, banners no longer amputated by zoomed texture coordinates). New Horde cloth remains integrated into the TGA with no pasted icon overlay; the emblem is recognizable at a glance but still dark and lacks the bright stitched contrast of the approved mockup. HK=32, PvP deaths=9 and HK/D=3.56 remain legible, no obvious collisions in the shown state. **Limited client visual PASS** for restored icons and functional composition, NOT final approval of emblem or general style.
- The user has not explicitly accepted final banners. Keep the original rule: dyed/embroidered design integral to textile or logo-less fallback, never the pasted Horde inventory icon.

## Iteration #41 — embroidered emblem contrast and coordinated styling (2026-11-17)

- Original asset commit `c931bd02f1355a5ecff1021b82574eeb7bca23d3` creates `Media/General/banner_horde_embroidered.tga` from the existing Horde cloth and dyed-mask silhouette with stronger copper/red edge threads and darker center pigment. Existing cloth folds, ragged hem and source alpha are retained. It is not a pasted square icon nor a claim of exact proprietary Horde glyph reproduction; client evaluation is required.
- Code commit `cc818509fee0cfa0c2835aa2502d226070ff89c2` changes `UI/General.lua` to use the new original painted cloth and bump `/ws version` to 41. Same batch adds a subtle metal glint on active tab, slightly reduces the rank ribbon's shadow, strengthens its value hierarchy, and slightly increases the first lower band's numeric font without changing the second band's relative importance. No statistics adapters, SavedVariables, ratio semantics or HK/PvP-deaths layout changed.
- **Distribution**: standard GitHub Actions ZIP build commit `1e2d32897336f8a93bb183481224ce9b6206edce`, `dist/WarScore.zip` SHA `70af8c4133073352399d33782ba4b7fa435aca73`, 116,000 bytes. Independently inspected GitHub-returned ZIP: 15 Deflate-only files in `WarScore/`, correct central-directory structure; packed `UI/General.lua` CRC32 `581bd14a` and `banner_horde_embroidered.tga` CRC32 `c9f5946f` match current sources. No docs/OpenSpec/tools. Zip validation is NOT native gameplay QA.
- **Owner QA pending**: fully replace the prior `WarScore/` installation; `/reload`, `/ws version` must say 41; open `/ws`. Assess Horde emblem brightness and whether it reads as embroidered cloth rather than a sticker; verify both lower strips have intact six icons, first totals row remains slightly stronger, rank stays readable and no visual overlaps. Capture screenshot; report Lua errors if any. Other factions, test scales and automated Lua logic tests remain pending.
- This iteration is NOT final artwork acceptance; continue working to match the approved expanded visual reference.

## Iteration #41 — screenshot review (2026-11-17)

- Owner screenshot confirms both Horde banners retain the integrated textile emblem (no inventory-icon stickers), with somewhat clearer copper embroidery; **not explicitly approved** against the original mockup. All six lower icons are complete, the two-line rank is readable, and live counters show HK=32, PvP deaths=9, HK/D=3.56. **Limited in-client visual PASS for composition**, not final sign-off.
- New, more urgent problem visible in the same screenshot: green world nameplates/3D scene show through the middle of the dashboard around HK/D and KB/D, reducing legibility. Prioritize opacity/readability rather than adding micro-ornaments.

## Iteration #42 — block world interference in statistics and simplify band highlights (2026-11-17)

- UI commit `fd241d8325054a009c8543065617f40c72fdef63` in `UI/General.lua`; `UI_ITERATION` advanced to 42.
- Main window background now requests alpha=1 (rather than the prior alpha default 0.96) so unrelated 3D activity cannot shine through the full panel. A second near-opaque, dark central shade is added at BACKGROUND layer, spanning x=27..-27 and y=-346..-712, specifically behind lifetime metrics, PvP deaths and ratios. Border, content, original icon/banners and dynamic values stay above the shade.
- Softened the long full-band top glints in both lower rows and improved readability of muted secondary captions. No change to numbers, historical stats, ratio formulas, available data, stored variables, tabs, rank text, faction fabric art, portrait or original reference hierarchy.
- **Owner QA pending:** install clean CI-built package once refreshed, run `/reload`, `/ws version` expecting 42, open `/ws` while world nameplates/other players are behind it; check middle panel truly hides green names, there are no opaque unwanted rectangular boundaries, and all text/icons/lower bands remain visible. If visually flat or still translucent, tune background artwork rather than undo the hierarchy. Verify HK/deaths/ratios as naturally updated, not hardcoded.
- Automated Lua tests and full client validation for iteration 42 NOT RUN. Banner fidelity, Alliance art and scale scenarios remain open.

## Owner-approved redesign brief — iteration 43 onward (2026-11-17)

**Source of truth:** owner supplied current iteration 42 screenshot side by side with the aspirational fantasy/WoW reference. Owner says 42 micro-iterations have not converged enough; prioritize structural, measurable visual milestones over tiny decorative edits. The reference has *single outer WoW-style frame, nested interior chrome containing navigation/content, detailed sculpted rank ribbon, painted cloth banners and fully integrated decorative stat iconography*. Owner explicitly confirms these constraints in the current conversation.

### Decisions LOCKED for current and next iteration
1. **Freeze faction banners**. Do not redraw, recolor, re-anchor, change emblem or remove the Horde/Alliance flags until the following milestones have been reached. Current embroidered Horda art is NOT accepted as final; no reason to keep tweaking it now. Document separately as deferred.
2. **Outer frame:** recognizable native WoW window/Spellbook-like chrome; the frame must visually define the absolute window bounds; no black rectangle extending outside border. Keep window movable, close button usable and on-screen clamp.
3. **Inner frame:** visible distinct secondary border around the tab navigation and all PvP contents, fitting fully inside outer window. Do not misread inner frame as six separate boxed cards.
4. **PvP rank:** keep two-line `Rango PvP` and dynamic `No disponible`; move small caption DOWN so it does not touch the top edge; better metallic/ribbon silhouette and edge treatment closer to mockup. Never fabricate ranks, retain real faction crest.
5. **Lower 2×3 statistics:** centering must be relative to EACH FULL 1/3 segment, NOT shifted by the decorative left icon. Titles remain cream; values in top band ALL gold, values in bottom band ALL green (including absent favorite). Top three counts display **0** on nil; lower win rates display **0 %** on nil; favorite uses an en dash `—` on absent data, in green. Such zeroes are UI presentation defaults only, not evidence backend APIs returned genuine zero: preserve nil/unknown in Stats and persistence. No edits to gameplay calculations.
6. **Iconography:** target icon glyphs blended with bar/background like transparent PNGs; remove explicit fake square recess/slot borders. Native square inventory icon sources will remain incomplete stylistically until alternative transparent art assets are available—do not pretend removing a recess eliminates baked-in native square backgrounds. Preserve complete silhouettes and avoid texture-coordinate zoom cropping.
7. **Preserve:** HK primary, PvP deaths subdued directly below, HK/D + KB/D below that; two shared lower strips; existing live data, normal tabs, portrait, laurels, slash commands and SaveVariables. No top-left swords medallion or redundant '(i)' info labels.
8. QA: inspect with /ws version (target 43), compare screenshot to source mockup by sections, verify no black overflow, secondary frame is obvious, rank header clearance, centered card texts, all absent-data colors, no clipped icons, normal movement and closing, no Lua errors. Alternate screen scaling, real non-empty stats, Alliance view and regression tests remain open.

### Delivery approach

This is a phased visual redesign. **Iteration 43 tackles structural outer/inner frames, rank caption padding, and deterministic lower-band formatting/centering.** Keep banners frozen. After owner screenshot, prioritize icon artwork without native tile edges and more sculpted frame/ribbon. Changes require one fresh CI-generated `dist/WarScore.zip` with only runtime assets, and handoff must mention real verified state vs untested in-client state. Avoid repeating failed tiny changes or claiming reference fidelity before client QA.

## Iteration #42 — owner screenshot and correction to design direction (2026-11-17)

- Owner supplied the real client UI side by side with the target mockup. The opaque central overlay introduced in #42 successfully hides game characters but appears as a conspicuous rectangular near-black panel with hard edges, exposing a new visual defect. The user also reports a black whole-window background slightly outside the apparent golden border. Live client screenshot shows priest now level **30**, HK=32, PvP deaths=9, HK/D=3.56. This does not mean hardcode those figures.
- Owner explicitly criticizes inadequate convergence after 42 iterations: major missing design language is a *native-style outer WoW frame defining the actual bounds*, a *second interior frame encompassing navigation and content*, a sculpted rank plate, natural banner integration and genuine transparent unboxed icon art. Tiled lower-band native icons remain an unfinished placeholder even when the outer slots are removed.
- **Locked owner decisions** recorded above: banners frozen; lower titles cream, top numeric row gold, entire lower numeric row green (favorite absence green dash); top three missing totals display `0`, two missing rates display `0%`, favorite missing displays `—`. This is presentation only; never coerce absent API statistics into observed facts at data layer.

## Iteration #43 — structural shell and metric layout implementation (2026-11-17)

- Code commit `b5eab5d98e07287c4bd5a1259f3ff50eef5344a6`, `UI/General.lua`; diagnostic `/ws version` now 43.
- **Frame:** previous completely edge-to-edge opaque background and separate hard-edged, near-black `centralShade` replaced by one uniform dark backdrop inset 12 px inside the window. Added a full-length native dialog-border texture (`Interface\\DialogFrame\\UI-DialogBox-Border`) positioned 2 px within bounds. Removed the competing parallel side rails. A separate thinner gold `innerPanel` frame now surrounds tabs and all PvP statistics, extending from x=22 to -22 and top=-60 to bottom=+17. The header remains above the interior.
- **Rank:** kept true two-tier `Rango PvP` / dynamic `No disponible`, moving both lines down 3 px within the existing ribbon to create more top padding. Complex shield/ribbon sculpture is still pending future asset work.
- **2×3 statistics:** removed fake solid square backing recess from each stat segment. Native source icon art is still a full square and is a deferred transparent-asset task; 36 px full-texcoord glyphs positioned at segment left. Both title and value FontStrings are anchored at segment **x=0**, not x=43/offset by icon, with 145 px text widths. All titles are cream, first-band numeric values gold, second-band values green including favorite.
- **Empty data:** added display-only `formatCountOrZero` for top three counts; percent formatter returns `0%` for nil win rates, but `ns.Stats.ReadHistorical()`, its nil semantics and persistence remain untouched. Unknown favorite still shows a green `—`, and nonempty values remain dynamic.
- **No changes** to faction flags/TGA, gameplay data, portrait, HK laurels, ordering of HK → PvP deaths → ratios, tab command behavior or SavedVariables. No discontinued medallion or ratio '(i)' returns.
- **Clean ZIP:** standard GitHub Actions generated `dist/WarScore.zip` on `main` (build commit `3751bf5d8cc213eba0f058e834b7281e06b2596c`), blob SHA `877ca616c60f3578d4336691ca2f5616f7399dc9`, 116,148 bytes, exactly 15 deflated runtime files under `WarScore/`. Connector readback verified central directory, no docs/OpenSpec/tooling, and packaged `UI/General.lua` CRC32 `1f96cac7` equals source.
- **Status: not validated in the WoW Forever client yet.** Owner should delete old addon folder, extract clean ZIP, `/reload`, `/ws version` must say 43, open `/ws`. Compare two frames and outer bounds to source mockup, check that dark central rectangle is gone, title/value columns visibly centered despite icons at left, 0/0/0 on missing top totals, 0% for missing rates in green, and favorite missing dash in green. Confirm rank caption now has top clearance, buttons work, no icon/text overlap or Lua errors. If full-center titles overlap left glyphs for very long labels or populated favorite, adjust icon sizing/transparent assets, not x offsets. Native dialog border and nested border aesthetics require client inspection; no claim of final pixel equivalence.

## Iteration #43 — owner's in-game screenshot review (2026-11-17)

- Screenshot clearly shows the new nested inner frame, native-style external border, dark background contained by the shell, and no hard black central panel. Portrait, Horde cloth flags, tab navigation, rank caption/value, lifetime HK=32, PvP deaths=9, HK/D=3.56 and two bands all render. UI character is level 30. **Limited visual PASS for structural outer/inner frame milestones**, not final frame/style acceptance; owner did not explicitly report `/ws version` output.
- Empty-state behavior from owner decision is visible and correctly colored: first row Duelos/BG jugados/BG ganados = 0 (gold); second row Win rate BG and Win rate duelos = 0% (green), favorite = — (green); captions remain cream. Text/value centers appear evenly aligned per third, independent of the decorative left icons.
- Remaining priority: the native icon backgrounds still resemble WoW item squares; the PvP rank remains a simple thin plaque, far from the heavily sculpted original mockup. Banner work remains **FROZEN by user instruction**, and is NOT approved final. Do not spend time reworking it before other milestones.

## Iteration #44 — original transparent glyphs and sculpted rank plate (2026-11-17)

- Created six new transparent 32-bit TGA assets using original vector/geometric painting primitives: `Media/General/icon_duels.tga` (crossed swords), `icon_battle.tga` (crossed battle flags), `icon_trophy.tga` (gold cup), `icon_rates.tga` (crossed axes), `icon_favorite.tga` (blue/gold hanging standard), `rank_plate_sculpted.tga` (tapered dark leather with gold beveled edges). These are original approximations, not transparent crops of WoW inventory icons, and are **NOT** verified inside Forever yet.
- Asset commits `ac4bf29c7e2f9ce5a831053bca3d21585b2be056` and `48a791537a50ceafa333da92dfb32ab3d6d7d777`. Code commit `1a1babd8c677dea98faca5575e704cb1d711792a` in `UI/General.lua` switches all six decorative slots to new custom assets, enlarges glyphs to 49px without additional tiles, and replaces the cropped old rank ribbon + rectangular backing shadow with a single 460×54 original transparent sculpted plate. Two-line rank text and factual `No disponible` remain dynamic; left faction crest is retained. Diagnostic `/ws version` now reports **44**.
- **Banner freeze respected:** no Horde or Alliance texture, location, symbol or masking changed in #44. Previous lock continues until shell/rank/metric-art milestones pass client QA.
- **Packaging incident resolved:** CI workflow hardcoded `assert len(names)==15` in the ZIP verification and blocked the first iteration-44 release because new runtime art increased file count. Commit `4ef107a3a7e647a3c13ce1f8a636113cc10d6304` changes verification to assert the *exact set* returned by the TOC + referenced-media packager, not a fixed number. GitHub Actions subsequently generated standard ZIP in commit `a56d1d2bb83f99aed4d1b3903219c9a69fc433c5`; SHA `5c48cf3821cebc8502040223f5ed49ec691744cd`, 125,070 bytes. Connector readback checked ZIP central directory, 20 Deflate runtime files under `WarScore/`, all six new assets present, and packaged `UI/General.lua` CRC32 `8c7140dd` equals repository source. No docs/OpenSpec/tooling included.
- **Owner QA PENDING:** replace `Interface/AddOns/WarScore/` completely, `/reload`, check `/ws version` = 44, then `/ws`. Inspect: original transparent icons load (not missing/white/black squares), appropriate pictograms and visibility, text is still centered, rank plate has a coherent gold bevel and no overlap with portrait/diamond line, two-tier caption fits, full shell remains inside limits, zero conventions and historic values unchanged. If any artwork is illegible or too stylized, iterate the specific asset; do not restore hard square inventory slots by default. No in-client test for iteration 44, long-value tests, automated Lua tests, Alliance client tests or final mockup approval.

## Iteration #44 — owner screenshot: REJECTED visual assets (2026-11-17)

- The owner tested iteration 44 inside Forever and rejected both its **cartoon/clip-art 5 glyphs** and its **large flat orange, overbright rank slab**. The original artwork assets loaded technically and the 2x3 columns/zero conventions/outer-inner window frames remained stable, but **technical transparency is not aesthetic acceptance**. Stop patching the failed image set; do not promote it as approved.
- Owner specifically instructed to **keep iterating and avoid lengthy explanations**. The best immediate corrective step is to remove the rejected visuals from the addon, retain the good structural/data changes from iteration 43, and seek a coherent more realistic illustrated art direction later. Faction flags remain explicitly frozen by owner choice.

## Iteration #45 — rollback rejected graphics, restore restrained rank/metric treatment (2026-11-17)

- UI commit `dc62c39f64e9663310d1d834e62ae7b01a9e6d61`: `UI_ITERATION = "45"`. Removed references to all new custom `icon_*.tga` and `rank_plate_sculpted.tga`. Older unobtrusive native inventory icons return as a **temporary fallback**, only 32px, no extra square mount or destructive crop; this is **not final icon acceptance**.
- Restored the earlier dark leather `rank_ribbon.tga` cropped to avoid striped end artifacts, with a narrow 412×34 dark backing and two subtle metallic side bevels, keeping the actual faction crest and truthful two-tier unavailable rank. The conspicuous 44 orange rank image no longer loads.
- Preserved owner-approved frame structure, two outer/inner borders, consistent backdrop, rank text hierarchy, centered lower columns, zero/0%/favorite-dash conventions and top gold/bottom green color semantics. No stats/SavedVariables mutation, and no faction-banner code or assets modified.
- CI rebuilt clean ZIP commit `f3d7874066e116da055ac3a5798e6741ba00eb7f`, blob SHA `84eccc2086fc52b3dd505ec4d4bdbc4bf59572ff`. Verified read-back: **15 Deflate runtime files** under `WarScore/`; no rejected graphic TGAs in install ZIP, and packed `UI/General.lua` CRC32 `1e01a52e` matches live source. Prior check script initially compared against the wrong expected count (14) but actual count is 15 and all structural/CRC checks passed; count must be treated as dynamic in CI, not hardcoded.
- **Owner QA pending**: replace whole install directory, run `/reload`, `/ws version` should report 45, view `/ws`. Confirm the orange slab and clip-art are gone, background and two frames unchanged, rank label readable, six fallback icons legible, no Lua errors. Continue realistic icon asset discovery/creation after client pass, not another geometric cartoon icon set. No automated client tests or visual sign-off for iteration 45.

## Iteration #45 — owner screenshot review (2026-11-17)

- Owner tested the corrected iteration 45 in Forever and provided screenshot: the awful clip-art icons and the bright orange rank slab are gone. Back to restrained native WoW glyphs and the prior dark ribbon. Dual window frames and the 2×3 stat rows remain readable, with consistent gold/green zeroes, HK 32, PvP deaths 9 and HK/D 3.56. Outer shell appears functional. **Limited visual PASS for rollback only; not acceptance of rank/icon artwork.**
- Rank still reads as a straight strip with a conspicuous stray vertical gold line at the right. Six native icon tiles are much better styled than 44 but remain visibly square. Banner artwork **remains frozen** by owner's explicit instruction.

## Iteration #46 — native glyph masking and ornamental rank ends (2026-11-17)

- Code commit `1ce42f855698d28e1a821d778f2d0e8a9eb1fb5c` updates `UI/General.lua`, version diagnostic to 46.
- Native WoW six metric icons enlarged 32→37 px and given an optional alpha mask using the existing `portrait_mask.tga`. The API `CreateMaskTexture/AddMaskTexture` is client-guarded under `pcall` and retains prior square-icon fallback if unsupported. No new geometric/cartoon icons or destructive texture cropping. Masked effect **not yet verified in client**.
- Removed the two isolated right/left 2px gold end strokes around rank plate, reduced/cropped ribbon ends further, and reused the existing transparent gilded `hk_laurel.tga` mirrored at x=±207, width 43, to give the rank ribbon ornamental side treatment. Its faction crest and truthful two-line rank remain. This is another visual experiment, **not automatically approved**.
- All banner textures and logic untouched per freeze. Outer/inner frames, zero/gold/green rules, real data, ratio calculations and storage unchanged.
- Fresh CI-produced ZIP commit `ea2cda9ea16b04a8e2dce329cb9cfa902f149916`, blob `8ba33b9ccf5633f267b476b6a9db30e406b990b8`, 116,298 bytes. Readback verified 15 Deflate files under `WarScore/`, no development files, valid central-directory structure, packed `General.lua` CRC32 `12e8f885` equals current source; no rejected clip-art TGAs included.
- **Owner QA:** replace old addon folder with clean ZIP; `/reload`, `/ws version` expected 46, then `/ws`. Check six masked icons have no ugly cutoff/empty tiles, both rank laurels actually render in correct direction/without overlap, no reintroduction of orange slab or stray line, historic counters still read correctly, and no Lua errors. Should this be worse than 45, revert only ornaments/masks rather than compromising approved structure. No automated in-game Lua tests or final fidelity approval.

## Iteration #46 — owner screenshot review (2026-11-17)

- Owner screenshot shows the six circularly masked native icons loading in Forever, and explicitly requests making them **slightly larger**. The rank's mirrored miniature laurel decorations resemble disconnected branches on the ribbon instead of coherent ornamental endcaps. HK=32, PvP deaths=9 and HK/D=3.56 remain consistent; upper gold and lower green empty-value conventions, centered labels and nested frames remain intact. This is limited owner visual feedback, not sign-off of final rank/icon fidelity.
- Owner wants uninterrupted implementation rather than lengthy plans or asking to proceed. After any in-game screenshot, continue directly with implementation and deliver installable ZIP when possible. Do not promise autonomous work after responding. Banner work remains **frozen** until other milestones are accepted.

## Iteration #47 — bigger icons and cleaner rank silhouette (2026-11-17)

- Code commit `03bbdeb476d55ef4d29df485b5abdae830a6760a` in `UI/General.lua`; `/ws version` now 47.
- Increase six lower native icons 37px→43px, shift left anchor 10px→8px, retain already client-tested circular alpha-mask path and fallback; decorative icon stays independent from text/value centering.
- Remove both little `hk_laurel` ornaments from the rank plate, reducing ribbon width 438px→432px and dark backing 408×31→403×30 to keep one restrained coherent shape. Preserve the actual faction crest, genuine unavailable rank text and two-line layout.
- No gameplay, saved-variable, PvP calculations, colors, empty-data formatting, main structure or banners changed.
- **Package verified:** GitHub Actions refreshed ZIP commit `289c4d7e4aec728dd94e178d438c5905faa8eb4b`, ZIP blob `203bdcd85adaf9cbf93a1de114577b508706f473`, 116,253 bytes, 15 deflated runtime files, with packaged `UI/General.lua` CRC32 `c150ec3e` matching repo source. No docs/OpenSpec/tools in the package.
- **Owner QA pending:** completely replace addon folder, `/reload`, `/ws version` should display 47; check 43px icons no longer look tiny and don't overlap centered text, and rank no longer has detached gold foliage. Send screenshot and note any Lua errors. Further proper art direction remains pending after validation; banners remain frozen.

## Iteration #47 — owner screenshot review (2026-11-17)

- Owner screenshot displays six now-larger native circularly masked stat icons, centered text/value columns, cream titles, top gold zeros and lower green 0%/dash, all inside the proven two-frame window. The rank ribbon is visibly plain with the detached miniature laurels removed; no new visual artifact seen. HK=32, PvP deaths=9, HK/D=3.56 and unavailable KB/D/rank remain unchanged in this character's test screenshot. The user has not explicitly signed off on finished visuals. Banners stay frozen.
- The next priority is increasing the rank panel's perceived depth and aligning its text without another cartoon or orange rectangle, while preserving all successful layout fixes.

## Iteration #48 — contained ribbon metalwork and centered inscription (2026-11-17)

- Code commit `f47530d4478b07c9bc2c6ad23cbb2dfbda9795a5`, `UI/General.lua`; `UI_ITERATION = "48"`.
- Rank: retain previously client-tested dark leather ribbon; slightly widen its dark inset backing to 404×32 and change backing color subtly. Add two continuous 362px fine metallic top/bottom details **inside** the plaque, intentionally avoiding loose endcaps and laurel fragments; make both small rank title and dynamic value exactly horizontally centered (x=0) within the full plaque. Slightly reduce the faction crest holder to 39px while preserving the true faction and two-line unavailable rank state. No new art files or clipping masks.
- No modifications to lower 43px native masked icons, 2×3 centered band composition, level/portrait/HK/ratio calculations, missing-value presentation, shell frames, or deliberately frozen Horda/Alliance banners. Status remains visual preview rather than completed match to source artwork.
- CI-produced `dist/WarScore.zip` after commit `65d0d54059c82775c1d37959df8915e6f1b783af`, blob SHA `4d15954294d0a396fdd74d34be19a1455c74b58b`. Readback independently verified ZIP central directory, 15 Deflate files rooted under `WarScore/`, no docs/OpenSpec/tools, current `UI/General.lua` CRC32 `88702245` identical to archived version; size 116,329 bytes.
- **Owner QA pending**: full clean folder replacement, `/reload`, `/ws version` = 48, `/ws`; inspect ribbon top/bottom highlights, small headline clearance, crest fit, no unnatural free-floating gold strokes or overlaps, stable stat rendering and 43px six glyphs. Send screenshot. In-game build 48 and multi-scale/Alliance data tests not yet run, and final WoW-reference match is not accepted.

## Iteration #48 — owner screenshot review (2026-11-18)

- Owner supplied a screenshot showing consistent UI composition but identified a **major outstanding reference discrepancy**: the mockup's backdrop is warm, greyish and subtly textured (stone/leather/grain), whereas the live UI had an almost black flat background. This needs direct art correction, not another description-only handoff. No new acceptance of banners or rank artwork; banners remain explicitly frozen.
- Owner corrected prior assistant claim of missing repository write access: the GitHub connector is operational, and the agent must **check the actual installed tools before claiming lack of access**.

## Iteration #49 — warm-grey grain and soft vignette (2026-11-18)

- Asset commit `fe2ff3d53a4f278fd0ee00f87498340a6ef6fa7c` adds original `Media/General/panel_stone_dark.tga`: opaque 256×256 TGA with warm charcoal-grey/aged-stone base, restrained multiscale grain, warm marbling and a faint dark-edge/central-light vignette. The TGA's average red is about 33/255; range 21–46, intentionally dark enough to preserve cream/gold text contrast.
- UI commit `540708fd04174046d73bc1cea957dc175bd7a2cf` changes `UI/General.lua` to version **49**, replacing only the prior `WHITE8X8` flat near-black shellBackground with the new original TGA at full tint, still inset 12px within the native WoW border. This leaves the dual frame, core UI and dimensions intact; all banners, stats, rank ribbon, icons, nil-display formatting and SavedVariables are unchanged.
- CI-created `dist/WarScore.zip` (build commit `611c70a95be1b74f19b035fcc5ed770b7c3a702c`), blob `6e51c786a18d5af7c2c749f4ffe70e9a13cbcec0`, 171,054 bytes. Independent ZIP central-directory validation confirms **16 Deflate runtime entries**, current `General.lua` CRC32 `8aaf67ed` matches its packaged copy and the new TGA CRC32 `c0dd2dec` matches its packaged copy. No docs/OpenSpec/tools in package. This fixes the earlier incorrect assistant statement about unavailable GitHub rights.
- **Owner QA pending:** completely replace installed WarScore folder, `/reload`, check `/ws version` = 49, open `/ws`. Compare texture to mockup: warm grey, subtle grain and no visible repeating/stretch pixels, no hard rectangular overlay, text still legible, borders still define outer extent. Screenshots can reveal if texture is too dark/too bright/too uniform at game resolution. Do not claim in-client acceptance before screenshot.

## Iteration #49 — owner screenshot review (2026-11-18)

- Owner supplied the in-game screenshot after iteration 49 and regards the warm grey textured background as a better direction. General composition and larger lower icons remain stable; this is **not** full visual acceptance.
- PvP rank plaque remains visually flat and far from the reference; no banner approval. Priority next: rank sculpture. Retain 43px masked native lower icons and gold/green missing-value rules.

## Iteration #50 — sculpted rank silhouette and integrated faction boss (2026-11-18)

- Code commit `6d165e724bf664648a35f294d41edb00a0e1f93b` updates `UI/General.lua`; `/ws version` reports **50**.
- PvP rank uses more of the existing authored `rank_ribbon.tga` (texture coordinate range 0.035–0.965 instead of 0.12–0.88), increases visible sculpted ribbon ends and reduces flat rectangular backing. Restrained inset metal lines are shortened and contained.
- Replaces the crest's square tooltip border with the existing transparent gilded portrait ring, places the faction icon in a round boss overlapping the ribbon and applies the already used guarded circular mask with safe fallback.
- No new icon artwork, no orange rank panel, no disconnected leaves; no changes to banners (still **frozen**), lower 43px icons, HK/death/ratio calculations, placeholder values, storage or outer/inner frame.
- **QA NOT RUN in Forever**. Owner should install fresh `dist/WarScore.zip` only after CI refresh is confirmed, run `/reload`, `/ws version` (50), `/ws`, send screenshot. Check ribbon ends are elegant (not cropped sharply), crest circular/correct faction/no square artifacts, title and unavailable value clear, no overlap with HK divider, no Lua errors.
- If fully revealed ribbon ends or circular boss appear worse than 49, adjust/revert only this rank treatment. Final approval, Alliance, alternate scales and populated BG data still pending. Banners stay frozen.

## Iteration #50 — owner screenshot review (2026-11-18)

- Real Forever screenshot confirms textured warm-grey panel, stat hierarchy, 43px lower icons, gold/green zero conventions and clean circular rank crest. Historical counters visible: HK 32, PvP deaths 9, HK/D 3.56.
- **FAIL rank art:** the UVs newly exposed in iteration 50 render obvious parallel gold scratch-like lines at the right ribbon end. Plaque still reads flat rather than sculpted. Neither the end treatment nor rank as a whole is approved. Banners remain frozen.

## Iteration #51 — remove right-ribbon hatch and improve rank text (2026-11-18)

- Code commit `0192472be154772cb72ebae43efc9aaaf73d79af` updates `UI/General.lua`; `/ws version` = **51**.
- Return rank ribbon to previously tested safe texture UV crop (0.12–0.88 / 0.13–0.87) so the visible right-edge scratch artifact introduced by iteration 50 should disappear. Keep circular crest treatment established in 50.
- Slightly taller rendered ribbon (48px), layered dark underlay/leather backing, restrained continuous interior upper glint and lower shadow. Rank labels enlarge to 13/18px and shift 12px right for optical balance with the left circular emblem.
- No new artwork or rank invention. Band icons, borders, textured background, actual statistics, data placeholders and both **frozen** faction banners remain untouched.
- **Owner QA pending**: replace addon folder with the freshly rebuilt ZIP; `/reload`, `/ws version` should return 51, `/ws`; send screenshot evaluating whether the striped right-end artifact is gone, rank text legible and crest properly aligned. Check for Lua errors/overlaps.
- The shape still relies on the inherited authored ribbon asset; a true high-fidelity sculpted rank asset remains a later optional milestone and requires real screenshot signoff. Do not claim full visual acceptance.

## Iteration #51 — owner screenshot and explicit reference review (2026-11-18)

- Owner screenshot of 51 still shows **parallel scratches / hatching on the right edge of the PvP rank ribbon**; prior UV adjustment did not fix the issue. Its round faction badge looks unnatural, stuck to the plaque, and does not resemble the integrated heraldic shield in the owner's original mockup.
- User explicitly confirmed **background and all six lower statistic icons are NOT approved**. The dark textured shell still differs significantly from the richer dark leather/stone mockup, while lower icons remain circularly masked inventory assets rather than polished illustrated icons.
- Original reference image was supplied directly: top crossed-weapons header medallion, strong native WoW metallic nested border, richly textured dark interior, curved rank ribbon with heraldic shield incorporated at left and laurel end treatment, and coherent high-quality bottom icons. **Reference contains fictional example data**; never substitute its rank, class or counters into live data. Maintain current user-approved HK → PvP deaths → ratios order, which differs from mockup.

## Iteration #52 — rank badge removal and cropped art (2026-11-18)

- Code commit `ec1b50c0d6187694ff0db4cbd9f68ccff7e49be6`; `/ws version` = **52**.
- Removes the rejected circular faction badge entirely instead of replacing it with another superficial clip-art emblem. Future milestone requires an actual shaped, integrated Warcraft-style shield, **not** the round ring and square inventory icon.
- Narrows the existing ribbon's UV crop (0.18–0.74) to exclude the persistent right-side scratched region visible in the latest screenshot; retains warmer layered dark leather and quieter inset metal rim, centers rank text on full plaque. Retains 'No disponible' without inventing PvP rank.
- No modifications to the frozen banners, native lower icons, background texture or data model. **Background, lower icons and PvP rank artwork remain provisional and not approved.**
- **Owner QA pending:** install fresh CI-generated ZIP, run `/reload`, `/ws version` = 52, `/ws`; send screenshot, checking right-hand scratch removal, rank spacing, text and absence of Lua errors. Full shield/matching materials will be separate iterations. If this crop loses too much ornamentation, plan fresh authored rank asset rather than endlessly stretching the old one.

## Iteration #52 — owner screenshot and new direction (2026-11-18)

- Owner's in-client screenshot verifies the round faction boss is absent and the right-edge scratches are no longer present. However the PvP rank strip now reads as a plain orange-brown rectangle; **not visually accepted**.
- Owner explicitly asks to remove BOTH side banners, restore the faction symbol on the rank ribbon as a left-hand overlapping piece (like the reference's heraldry), and reserve a WoW-style settings gear in the TOP-RIGHT CORNER INSIDE the inner panel, separate from the exterior close X. The gear is a visual placeholder only.
- Background and lower-stat icons remain NOT approved, as already documented.

## Iteration #53 — remove banners, place rank heraldry and settings placeholder (2026-11-18)

- Code commit `77c3f3f9352e6b0cdf151c92da25680fca8ebb7c`; `/ws version` = **53**.
- Stop rendering either faction banner in `UI/General.lua`; existing media is left in the source repo but omitted from runtime ZIP when unreferenced.
- Place native faction banner emblem at left of PvP plaque inside an overlapping 51px gold-edged badge (NOT the rejected circular portrait ring). The item artwork and rectangular mount are **provisional** and deliberately do not claim to equal the integrated shield in the mockup; owner screenshot will decide whether to keep or replace.
- Add a 36px WoW-style gold-edged settings frame 12px inset from the INNER frame's top-right corner with native `INV_Gizmo_02` gear asset and guarded circular cutout. Hover says 'Ajustes (próximamente)'; no settings functionality and no SavedVariables changes. This is not the top-right outer close control.
- Keep all PvP counters, rank-unavailable state, current HK → deaths → ratios ordering, textured shell, panel borders, lower masked icons and gold/green empty values. No attempt to claim the backdrop, lower icons or rank art as approved.
- **Owner QA required:** clean addon installation; `/reload`, `/ws version` = 53, `/ws`; verify no side banners, settings cog displays in INNER top-right and doesn't overlap tabs or X, rank emblem visually acceptable or not, no Lua errors. More substantive artwork/background work is still pending.

- Packaging cleanup commit `c040b4cc18d452efbb9c76f9c3f25acbbd2f2052` deletes the now-unused banner renderer and texture references from `UI/General.lua`; the banner source artwork remains in Git for history but should no longer be included by `tools/package_addon.py` in the final runtime ZIP. CI packaging/parity should be checked after this commit.

## Iteration #53 — owner screenshot review (2026-11-18)

- Owner screenshot confirms the two large faction banners are gone, exposing more space. The 53 rank emblem is present but placed too far left on the ribbon; user requests shifting it rightward. Visual mount remains provisional.
- Settings button is correctly placed near upper-right of INNER frame but native `INV_Gizmo_02` visually does **not** resemble a gear. Reject this glyph; the location remains intended, gear design not accepted.
- User explicitly reports unchanged background and weak depth compared with mockup. Prefers the previous near-black backdrop / lower-card black material if it improves contrast. Current grey shell and iconography remain NOT accepted. Do not claim final fidelity.

## Iteration #54 — darker recessed shell, genuine gear glyph and heraldry inset (2026-11-18)

- UI commit `4ec052185a17020ea348d252b3fcf1b900d4e6bc`; `/ws version` = **54**.
- Darkens the previously too-grey `panel_stone_dark` texture with warm brown-black vertex tint (0.61, 0.55, 0.49), preserving its organic grain. Adds a low-alpha feathered brown patina layer behind the central statistics using pre-existing `section_plaque`. This is a deliberate material/background change, not just documentation.
- Swaps the unsuitable settings icon to the native `Interface\\Icons\\INV_Misc_Gear_01` mechanical cog candidate and tightens its UI treatment; still in upper-right INSIDE inner frame, no settings feature implemented. Client test must confirm that this particular icon exists in WoW Forever.
- Moves the 51px faction mount 36px to the right, overlapping the plaque more centrally; slightly shifts dynamic rank text right for spacing. Not a final heraldic shield.
- Banners stay removed and do not enter packaged runtime; bottom native icons remain provisional, all PvP stats and color/missing-data semantics unchanged.
- **Owner QA required:** clean ZIP, `/reload`, `/ws version` = 54, `/ws`; check cog texture is a recognizable gear and not green/missing, dark background retains subtle detail, rank emblem/text spacing works, and no Lua errors. If native Gear icon is unavailable or visually poor, replace it with a proven client texture or purpose-built original cog asset. No in-client acceptance yet.

## Iteration #54 — owner screenshot (2026-11-18)

- The owner screenshot verifies the 54 color correction makes the shell almost black. Overall color/depth remains provisional, with the central area reading quite uniform. Lower cards still have stronger contrast than the interior.
- **FAIL settings:** WoW native `INV_Misc_Gear_01` resolves to a miscellaneous object (looks like a grey coil), not a legible settings gear. Do not keep guessing inventory assets.
- The faction emblem stays on the rank plaque after moving it inward. Rank's overall finish and six lower card icons are still **not accepted**; no data-model problems shown.

## Iteration #55 — original material textures and legible cog (2026-11-18)

- Asset commit `38d364d79e6408e94812c89131e15f727e4bf7e0`: new **original** transparent 128×128 TGA `Media/General/settings_cog.tga`, designed as a 10-tooth metallic gold/bronze gear with circular center cutout; new original opaque 512×512 TGA `Media/General/panel_dark_leather_v55.tga`, dark warm near-black organic leather/stone finish with multiscale mottling, fine grain, slight fibers and edge falloff.
- UI commit `e2594a5b4875ebd5ac258d7d022a0af09f2254ef` updates `UI/General.lua` to **55**. Loads both original assets rather than the misleading inventory icon or previous grey shell. Removes extra center-patina layer so the textured material is not visually flattened by a redundant overlay.
- Settings remains 36px in the upper-right INSIDE the inner frame, uses a 30px new cog, tooltip 'Ajustes (próximamente)', no functional settings. No new APIs required for cog alpha texture.
- No changes to PvP statistics, rank data, faction emblem placement, approved HK → deaths → ratio ordering, lower-band counts/color conventions. Banners remain removed.
- **Owner QA pending:** clean ZIP install; `/reload`, `/ws version` = 55, `/ws`; inspect whether cog now clearly reads as toothed wheel, whether new dark material is organic and legible rather than dirty or tiled, and report texture failures/Lua errors. Neither background nor rank/iconography is accepted merely by implementation.

## Iteration #56 — owner-supplied Horde banner integration (2026-11-18)

- Owner supplied a 1024×1536 RGBA PNG of an original hanging Horda cloth banner: full dark metal rod with gold/crimson fittings, red torn fabric and central painted Horde crest, transparent outside silhouette. **This replaces earlier artificial faction banner art**; owner specifically requests testing it in the next iteration.
- Asset import commits `46da53516abb65790b377c5d1108d4a657d0a100` and `46a3160fd9529ead7c2a521e1c48fdaf3b15f204`: converted source image into WoW-compatible **256×512 uncompressed 32-bit RGBA TGA** `Media/General/banner_horde_supplied.tga`, retaining transparency; color indexed/resampled to fit WoW texture size. Source remains in conversation; the asset's downsampling means pixel-perfect original PNG fidelity should not be claimed.
- UI commit `2444374d3ba891a0069ee19c9a57faec7e04fbf4`; `/ws version` = **56**. Reintroduces the supplied banner **on both sides**, each 144×230 anchored at x ±268, y -121 relative to the main frame. Entire rod/crest/cloth is one transparent texture: no independent fake rods, borders, squares, or extra emblems. No Alliance banner from this Horde asset: Alliance character deliberately has none until suitable art exists.
- The earlier user request to remove the side banners is superseded by the explicit later request to test the new supplied banner. **This banner integration is experimental, not approved.** Other UI elements (rank crest/plaque, background, cog, lower six icons, stats) remain unchanged and pending their respective acceptance.
- **Owner QA:** replace the addon folder using freshly rebuilt runtime-only ZIP, `/reload`, `/ws version` must show 56, open `/ws`. Verify transparent torn outline renders, artwork proportions/rod do not look stretched, left/right alignment stays inside frame and text/portrait aren't occluded. A screenshot and any Lua error details are needed for further refinements.

## Iteration #56 — owner screenshot and supplied integrated frame (2026-11-18)

- Owner screenshot validates the actual transparent cloth asset on both sides and settings cog at upper-right. **Horde banners accepted as individual artwork**, but their attachment to the window feels arbitrary; owner wants them emanating from the ornamental upper rule of a nested inner box.
- Owner supplied a second PNG: a complete gilded inner panel with a textured dark center, two integrated torn-Horde banners hanging from the top rail, and two empty rectangular tabs protruding above that rail. The intention is an **inner frame within the full WarScore window**, not a replacement of the exterior window or a third nested rectangle. General/Hoy live text should be positioned in the baked blank tabs.

## Iteration #57 — integrated nested panel from owner's asset

- Artwork commit `7e798576ed434300166bdf255034238ddb414ed3` adds `Media/General/inner_frame_owner_v57.tga`: cropped/converted owner PNG to WoW-compatible 512×512 uncompressed 32-bit TGA, removing connected exterior-black area to expose alpha, retaining its interior dark patina. Cropping/scaling is a first in-client visual test; source image quality is higher and can be revisited.
- UI commit `3371098286cfea66b8b7148448421c92335290b7`; `/ws version` = **57**. One 710×920 painting at window top offset -59 now contains the ornamental **inner frame, hanging flags, and two tabs**; removes separate banner sprites and duplicated tooltip-border inner frame/corner overlays. The full exterior window and live portrait/stats/lower band frames are retained.
- The General and Hoy button hitboxes are repositioned to the painted tabs, with only live names on top and today's existing nonfunctional message intact. Gear stays in upper-right of inner content frame; metadata/metrics unchanged.
- Note **Horde graphics are baked into this provided integrated asset**, so this prototype is Horde-specific. Future Alliance graphics require a different integrated frame or a separate compositing strategy; do not claim this is faction-neutral. No artificial player rank is created.
- **Owner QA pending**: clean install, `/reload`, `/ws version` = 57, `/ws`. Check tabs align to painted recesses, banners truly attach to the rail and don't obscure portrait/rank/HK, art's outer contour clean, gear doesn't overlap rail and bottom edge doesn't collide with lower cards. If art is overly squashed/soft, consider a higher-resolution native texture or segmented art.
- Background and lower card icons/rank artwork are still provisional; owner has NOT signed these off.

## Iteration #57 owner screenshot → supplied outer frame (2026-11-18)

- Owner screenshot: imported Horde inner frame and protruding tabs render, but the previous native exterior border/window dimensions do **not** align with that artwork: insufficient separation between frame hierarchy, inaccurate fit at the bottom and duplicated/competing trim.
- User supplied `marco exterior.png`: a full external WoW-style metal frame with crossed-swords header medallion, dark title bar, a painted red/gold X and its own obsolete internal gold border. Explicit instruction: use BOTH supplied assets, with outer providing the window and inner providing the content boundaries.

## Iteration #58 — owner outer/inner geometry integration (2026-11-18)

- Added `Media/General/outer_frame_owner_v58.tga` based on the actual user-supplied exterior PNG, cropped to remove empty margins, converted to transparent 512×1024 WoW-compatible 32-bit TGA, and excluded the redundant gold internal border from this outer art so the supplied inner frame remains the ONLY internal ornament. The original exterior metal perimeter, swords medallion, top title bar and close X are retained.
- UI commit `c3babe023ebfa787beb0d8361f2e4c6b297092c7`: `/ws version` **58**. Main frame from 750×990 to 870×1060 so the outer user asset is not squeezed into the earlier narrow box; new inner asset at 760×890, centered and moved down 110px, providing a clear inset and two projecting tabs under the outer header. Original dynamic stat positions/metrics preserved.
- Removed old hand-built exterior native border, header plaque and extra accents that would compete with the supplied painting. Uses the decorative outer art for crossed swords and X, retains live WarScore title and a transparent clickable close button positioned on that X. Moves General/Hoy labels and hitboxes to the raised tabs, and puts settings gear near the upper-right inner rail (above the right banner).
- No modifications to PvP data, KB/D placeholders, rank text, no-data conventions, lower card icons, or historical stats. Those lower icons and the rank's illustration are still **not approved**. The new art has Horde banners baked into the supplied inner frame; Alliance needs a future matching treatment.
- **Static assembly preview inspected**, not in-game acceptance. Fresh ZIP must be checked for outer asset, inner art, source parity, correct game-compatible dimensions; user to test `/reload`, `/ws version` = 58 and `/ws`, then screenshot and inspect frame alignment, bottom card clearance, tab centers, native X click hitbox and settings gear position. Do not mark full design accepted without in-client screenshot.

## Iteration #58 — owner screenshot review (2026-11-18)

- Owner screenshot shows both authored frames in client, the painted crossed-swords medallion, both Horde flags and tabs. However a broad dark/black external backing still makes the shell look like a separate rectangle; inner/exterior rails compete near the top/bottom.
- Portrait physically overlaps the tab rail and the inactive Hoy tab; main rank/name are crowded. Lower bars need bottom clearance checked against inner border. The UI is **not approved as aligned**.
- Owner requested a coordinated layout cleanup of the residual black shell, panel fit, portrait, tabs, rank, settings placement and lower cards, preserving all real statistics and unfinished lower icon art.

## Iteration #59 — clean up shell and content vertical spacing (2026-11-18)

- Source commits `2ff2ac197eb18fc7093f2c8f3b9e7268f0639db6` and `86056357baf62a378709d8852f74497bc9b4b028`; `/ws version` = **59**.
- Removed redundant full-window `shellBackground` leather texture. Outer + inner owner-painted frame art remain, so alpha outside their silhouettes should now show the game world. If the screenshot still reveals black outside the art, inspect the **alpha of the outer TGA itself**, not just the Lua layers.
- Portrait frame from 126→106px, face 108→90px, moved from y=-105 to -168 to avoid collision with the tab plates. Live player name/level and rank were repositioned to y=-279/-310/-341 respectively.
- Lifetime HK/deaths/ratios, fine separators, laurel ornaments and lower cards moved downward to keep a coherent layout under the portrait/rank. First row from y=-727→-758; second from -846→-878, leaving ~10px before the inner art's bottom at -1000. Separator widths reduced 650→632px where updated.
- Settings gear stays top-right inside the nested frame (x=-77,y=-123); corrected to avoid touching right cloth. Tabs retain existing user-asset alignment. No changes to SavedVariables, calculations, real PvP data, available/nonavailable rank behavior or lower stat icon images.
- **QA pending**: clean ZIP install, `/reload`, `/ws version`=59, `/ws`. Confirm black outer rectangle is gone, frame contours clean, portrait doesn't overlap tabs/name, rank and separators remain apart, two metric rows fit inside the lower border, gear doesn't collide with right flag, X stays clickable, no Lua errors.
- The source frame assets remain experimental in layout. **Rank artwork and lower six icon images remain unapproved**.

## Iteration #59 — owner screenshot FAIL: inner frame transparency (2026-11-18)

- Real WoW Forever screenshot shows the frame background is severely broken: the desert world shows through broad irregular gaps between the painted upper rail, both banner sides and the dark center, plus bottom-side holes. This is a direct consequence of deleting the entire shell background rather than confining it behind the authored nested frame.
- Successful parts to preserve: owner outer metal chrome, medallion, live tab text, attached banners, centered smaller portrait without tab occlusion, rank and historical statistics, 2x3 stat rows. HK 32, PvP deaths 10, HK/D 3.20 were displayed and must remain live.
- Owner explicitly wants conservative repair and no invented replacement artwork; ask for separate assets only if truly needed.

## Iteration #60 — restore only the interior material behind transparent holes (2026-11-18)

- Code commit `ded5868182ee9467a576ae07d3d9ef0599260f06`, diagnostic `/ws version` = **60**.
- Restore the existing tested `panel_dark_leather_v55.tga` as a *constrained* opaque backing, 744×875 at frame TOP y=-115, on BACKGROUND sublevel -7 **behind** the supplied 760×890 inner panel and the external metal frame. This should cover its transparent holes and ragged top/sides without recreating a giant 870×1060 external black rectangle.
- Leave native dynamic stats, 2×3 cards, title/close handling, profile, settings, banners baked in the inner asset and current proportions unchanged. This iteration is a targeted alpha/compositing correction; both user-supplied frame assets are still used.
- **Not yet in-client validated.** Owner to cleanly install refreshed `dist/WarScore.zip`, `/reload`, `/ws version`=60 and `/ws`. Specifically inspect desert visibility through the upper tab rail, banner gutters and center/bottom; verify outside the external frame is transparent, dark material stays inside trim, no new hard-edged black rectangles, and no Lua errors.
- If gaps persist along the irregular silhouette, refine the existing alpha mask/backplate geometry or request specifically a dedicated *opaque interior material layer* from the owner rather than inventing incompatible decorative graphics. Rank plaque and lower 6 glyphs remain unapproved.

## Iteration #60 owner screenshot → #61 confined gutter correction (2026-11-18)

- Owner supplied a screenshot of v60 in a bright outdoor scene. The central dark backing works, the client displays real HK=32, PvP deaths=10 and HK/D=3.20 and both supplied frame assets, but **daylight is still visible in vertical gaps between exterior rails and the inner gold frame**, notably at left/right and beneath the tabs. The v60 744px backing was narrower than the 760px inner artwork and far narrower than the space just within the exterior rails.
- Owner requests continued iterations; when separate assets become necessary, ask them explicitly. **Never invent/custom-generate substitutes for missing art.** This rule is now binding in root `AGENTS.md` for all agents.
- UI commit `f656535a6644c54ffdce2654199141332110712b` updates `/ws version` to **61**. Reuses the existing `panel_dark_leather_v55.tga` as a 790×930 opaque backing from y=-97, behind the inner/outer owner paintings, attempting to fill the outer-frame gutters while leaving 40px side clearance inside the 870px window.
- This is a **limited repair, not a final alpha-mask solution**. Neither user art was changed, no visual assets were generated, and no player data, stats or lower icons/rank art were modified.
- **Owner QA pending:** clean ZIP, `/reload`, `/ws version`=61, `/ws`, screenshot in daylight. Check both side strips, tabs and top rail for world showing through, dark rectangle protruding past outer trim, bottom gold border clearance, close button and Lua errors.
- If a rectangular backing cannot cover the precise interior contour without protruding, stop guessing and **request a separate owner-provided opaque interior backing/mask** aligned to the external border, preferably PNG with alpha at the exterior canvas aspect ratio. Keep rank plaque and lower icons unapproved.

## Iteration #61 screenshot → iteration #62 narrow-gutter adjustment (2026-11-18)

- Owner's v61 screenshot confirms the broad transparent holes from v59 are substantially closed and the two painted owner-provided frames, banners, tab labels, portrait, gear and historical stats remain intact. Residual bright daylight remains in a **thin vertical gutter at the left exterior metal rail** (check symmetric right edge in further QA); background and rank/lower icons remain unapproved.
- Iteration 62 UI commit `a1c8d19b69fd8b6b2ec8d09e4a4e0f4800fae21a` increases only the existing dark leather backdrop from **790×930 to 808×930**, still TOP y=-97, centered and layered below both existing owner art textures; `/ws version` = **62**. No asset was invented, generated or modified.
- **Owner QA pending**: in daylight, check residual side gutter and especially whether the extra 9px per side creates a black protrusion beyond the exterior metal contour. Check no changes to tab alignment, close hitbox, lower rows and Lua behavior.
- **Stop widening if imperfect**: ask owner for a **separate opaque dark interior backing asset with outside alpha**, aligned to the external frame dimensions (PNG transparent beyond the metallic contour; approximately the exterior asset canvas aspect ratio), for precise compositing instead of guessing rectangle dimensions. Root `AGENTS.md` requires agents to request missing artwork instead of inventing it.

## Iteration #62 screenshot and designer's exact reference → iteration #63 (2026-11-18)

- The owner supplied **a new, high-detail transparent inner-frame PNG** `Marco interior con estandartes rojos(3).png` (1199×1312 RGBA), with empty center, protruding gold tab artwork and integrated Horde banners. Its center is truly transparent (verified alpha=0): there is no baked black background. It supersedes `inner_frame_owner_v57.tga`.
- The owner also supplied a **generated composite PNG as a layout reference only**, explicitly **NEVER include the composite as a runtime asset**. Separately supplied coordinate JSON is authoritative for the intended design arrangement: reference canvas 1199×1312; outer (0,0,1199,1312); inner frame x=66 y=101 w=1067 h=1167; inner scale ~=0.89, centered horizontally. The example Lua's `W*0.89` / `H*0.89` is approximate and corresponds to the reference canvas, **not actual 870×1060 WoW UI coordinates**.
- The designer warns the original exterior PNG has an extra baked gold trim that cannot be removed by shifting a texture. The existing `outer_frame_owner_v58.tga` has an earlier trim cleanup, but double-border appearance still requires the owner's visual verification. Do not invent/remove artwork without owner direction.
- Asset commit `7983709bb5fefde74a2f55acd06bd4b9a67a9ec4` imports `Media/General/inner_frame_owner_v63.tga` from the NEW transparent original at 512×1024 with alpha for WoW. Uses limited-color downsampling for game-format compatibility; original high-res PNG remains the gold standard for fidelity, not the generated combined mockup.
- UI commit `bc779ca17d94a3db6a2c734696ad04797ce84b02` sets `/ws version`=**63** and uses 774×943 inner frame centered at y=-82 inside the unchanged 870×1060 outer window (x=(870−774)/2=48). This projects the designer's x≈66/1199 and y≈101/1312 into the addon frame; exact output may vary by rasterized pixel edges. Previously improvised 760×890 / -110 is removed.
- Existing `panel_dark_leather_v55` backing is narrowed from 808 to 784px and retained beneath the transparent inner canvas; no original backdrop illustration was replaced or invented. The separately owner-provided leather PNG is **not yet integrated** because its fade and masking need a distinct verified placement; avoid introducing fresh black-rectangle regression.
- Dynamic tab labels, title, portrait, rank, live metrics, settings and cards are preserved pending screenshot. **No approval of final inner alignment, rank banner, bottom icons, compositing, or alternate faction**.
- **Owner QA:** install freshly built ZIP, `/reload`, `/ws version`=63, `/ws`. Check tabs land on gold recesses, outer and inner metal rails are separated/centered, dark backing stays within exterior, bottom margin isn't clipped, and no world leaks through. Also verify 512×1024 TGA preserves flags and corner resolution. If further precision requires a matching alpha backing or trim-free exterior asset, ask the owner.

## Iteration #63 owner screenshot FAIL, re-supplied source assets → iteration #64 (2026-11-18)

- Owner's v63 screenshot shows incorrect outer/inner presentation, a conspicuous rectangular backing and misfit around the lower edge. Owner re-sent **marco exterior(2).png** and **Marco interior con estandartes rojos(4).png**, explicitly identifying them as the correct author-supplied assets.
- Byte-for-byte inspection of mounted PNGs established these uploads **exactly match** `marco exterior.png` and `Marco interior con estandartes rojos(3).png` supplied previously. The root defect is **not a different drawing**, but previous extraction/texture compositing and rectangular matte layers. Original 1199×1312 RGBA assets retain irregular transparent edges and the inner asset's alpha=0 center.
- Asset commit `0a5c7bab49e1fe8cb48d759287bf6b86ed9f3c3f` imports new WoW-compatible TGA conversions of those exact supplied PNGs, `outer_frame_owner_v64.tga`, `inner_frame_owner_v64.tga`, plus `leather_backing_owner_v64.tga` made **only** by resizing/cropping the owner's already-provided leather texture and constraining its alpha behind the supplied outer frame's internal metal rails. No new artistic decoration was generated. PNG to TGA conversion uses 512×1024 RGBA with 240-color indexed RGB and 4-bit alpha working quantization; fine art fidelity still requires in-game visual QA.
- UI commit `9cc8a45b55c6cae23c6e7e0b545962b0d80b7ec6`: `/ws version` = **64**. The matte and external TGA now match the full outer canvas, and the inner TGA remains independently centered 774×943 at y=-82, following designer's ~89% reference. Removed the manually sized 784×930 rectangular leather layer. All real data and established widget positions preserved.
- **Potential issue to validate:** original exterior source contains its own inner gold border. If this appears as unwanted **third border**, a carefully alpha-masked exterior variant (removal of redundant baked border, no redrawing) is necessary; the designer previously warned repositioning cannot remove an existing drawn border. Ask owner before further alteration if it compromises preferred original artwork.
- **QA not run in client:** install ZIP, `/reload`, `/ws version`=64 and `/ws`. Compare dark backing outside rails (should be transparent), left/right margins, top tab alignment, bottom border, banner attachment, medallion and X hitbox. Return screenshot. Do not mark the framing accepted, nor rank plaque or six lower icons.

## Iteration #64 screenshot → #65 micro-adjustments (2026-11-18)

- Owner's real-client screenshot of v64 is **substantially improved**: outer/inner frame, owner leather, red banners, gear, profile, counters and lower cards are generally aligned. The counters are still real (HK 33, deaths 10, HK/D 3.30).
- Two focused defects remain: a very thin perceived double frame line at the right side; General/Hoy live text hangs low in the painted tab recesses.
- Code commit `08a39e308dbb310aab551d7af27795b1cc9d2129` bumps diagnostic to **65**. Shift the inner frame painting **5 UI units right** without scaling or editing the owner's art; shift both tab hitboxes likewise, and lift them **22 UI units** (y=-124→-102) so General and Hoy align with the center of the raised plates.
- Do not adjust other content, outer frame, background matte, stats, rank or lower icons. Treat right-hand double contour as **hypothesis** until next client screenshot; if clearly baked into the outer asset and persisting after this optical adjustment, request owner-approved masking/edit of the actual asset rather than fabricate another border.
- **Owner QA pending**: install fresh ZIP, `/reload`, `/ws version`=65, `/ws`; screenshot focusing on tabs and narrow right rail. Test Hoy click and external X. The six lower icons and PvP rank remain provisional.

## Iteration #65 owner approval and #66 genuine PvP rank artwork (2026-11-18)

- Owner screenshot of v65 was explicitly received as **"Perfect!"** for the adjusted outer/inner alignment and centered General/Hoy tab text. Do not alter the two owner-supplied frames, backing matte, stats positioning, tab labels or settings gear without a separate request. The user then supplied `placarangopvp.png`, an original **2048×682 transparent PNG** of a polished Horde PvP rank plaque featuring shield, red leather/metal bar, golden laurels and a central ruby; this asset is specifically authorized for integration.
- Art commit `5f888c2cc9c8302d0c43afc7556e7deab8a23283`: `Media/General/rank_pvp_horde_owner_v66.tga` is a WoW-compatible 1024×256 32-bit transparent TGA adapted from the supplied PNG. Crop only transparent-padding margins (original source rectangle x=42..2006, y=110..561) before downsampling; no artwork was fabricated or drawn. The 4:1 displayed texture gives a wide ornamental rank plaque without crushing its shield or eating the HK title area. The original PNG remains the quality reference.
- UI commit `155cbe6ab92711107a47e9bb5a71808d9d380efc`: `/ws version`=**66**. Horde rank now renders the single supplied plaque at **452×113**, centered around the existing rank frame, with all old synthetic background, square inventory-icon shield, inset rim lines and duplicate border removed. Live text `Rango PvP` and real rank/unavailable state remain dynamic and render above the asset. For Alliance (no equivalent asset supplied), retain the existing neutral ribbon instead of incorrectly displaying a Horde shield.
- For Horde only, the former straight rule/diamond beneath the rank is hidden: the supplied graphic already includes a gold lower edge and central gem. The darker HK section backdrop and all the existing real counters, ratios, lower stat bands, portrait, title, tabs, exterior and interior frames remain unchanged.
- **Real-client QA pending:** fresh package, `/reload`, `/ws version`=66, `/ws`, screenshot. Verify that the artwork isn't visibly stretched/cropped, shield protrudes naturally, the dynamic two-line text stays centered on the red surface, banner doesn't overlap the player level or HK title, and no black rectangle/graphic artifacts appear. Check no Lua errors; a separate Alliance plaque would require an owner-provided asset. **Lower six icons are still unapproved**; do not redesign them without asking for assets.

## Iteration #66 owner screenshot → #67 center axis and double frame (2026-11-18)

- Real-client screenshot of #66 confirms **owner rank artwork renders with good clarity**; the user reports that Krawer / level / rank inscription / HK should share one visible horizontal centerline. Existing rank label/value were offset **+30 UI units**, while name, level, HK title and HK number were anchored at x=0. This is a true code alignment discrepancy, not an issue with the original rank PNG.
- The same screenshot shows a small **double left gold frame border**. Code inspection confirms there is no longer any legacy border-frame renderer in `build()`. The extra gold inner trim is baked into `outer_frame_owner_v64.tga`, overlapping the owner-provided `inner_frame_owner_v64.tga`. Do **not** add another painted overlay or make the frame wider.
- Source art commit `0da5a4c73e9f032417d729f5dc2318842d3a1b8d`: `Media/General/outer_frame_owner_v67_trimmed.tga` is a **derived alpha-masked variant of the original owner-supplied exterior**, removing only the redundant internal gold-frame painting (masked region on original 1199×1312 canvas x=98..1103, y=162..1250) while retaining exterior steel rail, sword emblem, title bar and close X. The original `outer_frame_owner_v64.tga` is untouched in Git. This is corrective masking, not newly created ornamentation.
- UI commit `20aec51cca9b1798f59a1f5e8644cc4e1ff4ae0d`: `/ws version` = **67**. Switch external frame texture to new trimmed TGA; change live `Rango PvP` and `No disponible` text x=+30 → x=0, matching the window X axis used by portrait, name, level, HK headline and HK total. Horde rank asset itself, card stats, portrait, tabs and inner frame are unchanged.
- **WoW Forever QA NOT RUN**: install new `dist/WarScore.zip`, `/reload`, `/ws version`=67 and `/ws`. Inspect whether left dual trim is gone **without new transparent gaps/black blocks**, the exterior metal is undamaged, the lower-right corner is intact, live rank inscriptions are readable and truly centered, and there are no Lua errors. If the alpha mask clips needed steel, revert only the v67 exterior asset to v64 and refine the mask, not user artwork.
- PvP rank illustration acceptance is still pending explicit owner confirmation, and lower six icons remain not approved. Maintain no-invented-assets rule.

## Iteration #67 screenshot approved direction → #68 owner HK ornament (2026-11-18)

## API audit evidence — expanded PvP statistics (2026-11-18)

The owner ran `/wsdiag` and PvP statistic categories in WoW Forever 1.60.1. This is data evidence only; no UI or `Core/Stats.lua` implementation changed.

Observed direct returns: `GetPVPLifetimeStats: 34 | 0`, `GetPVPSessionStats: 2 | 0`, `GetPVPYesterdayStats: 0 | 0`.

Observed category data:

- PvP general: deaths by players `1501=10`; opposing-faction deaths `318=10`.
- Honorable kills: total `588=34`; world `381=34`; dominant continent `1458=27 (Kalimdor)`.
- Killing blows: total `1487=1021`; world `1488=828`; dominant continent `1489=458 (Kalimdor)`.
- Battleground category exposes 19 counters for global/per-BG played and wins plus objectives; all are `--` for this character.
- Duel category exposes wins `319` and losses `320`; both are `--`, with native UI comparison confirming `0/0`.

Next evidence required: complete one BG and one duel if possible, rerun categories 136/137/153/154, and compare killing-blow values with the native statistics panel before enabling KB/D. Keep rank unavailable: `UnitPVPRank` and `GetPVPRankProgress` are nil in Forever, while lifetime rank returns `0` for the tested character.

Category audit correction: Forever exposes 26 statistic categories. Category `137` (Golpes de gracia) has parent `128` (Víctimas), while category `21` is PvP and category `154` is Mundo under PvP. Because `1487/1488/1491` are under the general Victims branch and `1487=1021` is incompatible with HK `92`, they must not be presented as enemy-faction PvP killing blows. Historical PvP KB remains unconfirmed; investigate BG scoreboard and future event tracking instead.

Honor API validation:

- `/wsdiag honor` returned `UnitHonor(player)=0`, `UnitHonorMax(player)=5500`, `UnitHonorLevel(player)=1`.
- `GetInspectHonorData` returned `0 | 0 | 0 | 0`; `NotifyInspect` and `RequestInspectHonorData` are unavailable in this client.
- Honor current is therefore available for a progress graphic, but it must not be described as lifetime total honor. Honor today/yesterday remains unvalidated.

## API audit follow-up — first battleground activity (2026-11-18)

The owner produced the first positive battleground evidence:

- Total HK `588=92`.
- World HK `381=34`.
- Battleground HK `382=58`.
- Dominant battleground `1719=58 (Warsong Gulch)`.
- Warsong HK `1115=58`; other per-BG HK counters remain `--`.
- General counters: kills `1197=4517`, kills granting experience/honor `1198=4174`, own deaths `60=46`.

The arithmetic `34 world HK + 58 BG HK = 92 total HK` validates the world/BG split. Killing-blow values remain `1487=1021`, `1488=828`, `1491=--` despite the BG HK activity, so KB/D remains pending native-panel comparison and further BG evidence. The 1197/1198/60 counters are not to be treated as PvP-specific metrics.

Follow-up after one completed BG:

- `839` BG played = `1`.
- `52` Warsong matches = `1`.
- `395` Warsong flags captured = `1`.
- `840` BG wins, `105` Warsong wins and `586` flags returned remain `--`.
- Category 137 remains `1487=1021`, `1488=828`, `1491=--`.

This validates positive BG history and objective tracking. Compare the native statistics pane before treating `--` as zero for wins or returned flags; do not infer the match result from the API alone.

- Owner's v67 real-client screenshot received with positive feedback (**"Perfecto! Muchísimo mejor"**). The accepted direction retains the new Horde PvP rank plaque, centered text, author-supplied nested frames, background, tabs and settings cog. Existing historical stats live data remained HK=34, deaths=10, HK/D=3.40 in screenshot.
- Owner provided **`Marco ornamental dorado con laureles(1).png`** (1448×1086 RGBA). The actual artwork occupies roughly alpha x=87..1358, y=364..699, with a top/bottom gilded rail, central diamond details and left/right laurels; the central field is transparent. Use it **instead of the previous separate two laurels and the lower HK divider**. Do not invent artwork.
- Artwork commit `d2c2b7052ee7a48ac6817e5adba5612edef79305`: the owner's PNG is cropped only to the artwork's transparent bounds (72,350,1372,706), resized to WoW-friendly 1024×256 and exported as `Media/General/hk_frame_owner_v68.tga` with alpha. Converted asset retains both laurels and the upper/lower rails. The original high-res PNG remains the quality reference.
- UI commits `67d1581b4869f6130c75d07f0c141bbe2f9e4a43` and `ef6a2171cb795c90c1094efe5413f2bfef489926` implement **`/ws version` = 68**: center a 600×119 ornate asset at y=-407, draw live `MUERTES CON HONOR` (23pt y=-425) and live HK count (61pt y=-452) on top, remove the prior `hk_laurel` textures, separate HK plaque backing and extra divider/diamond at y=-514/-512. Preserve the external independent section dividers elsewhere.
- The rank plaque is lowered from y=-341 to **-347** for 6px extra breathing room below `Nivel 30 · Sacerdote`; portrait/name/level and all historical PvP calculations unchanged. Rank label/value remain x=0, as do HK title/number. The Horde rank image still renders its own ruby and gilded edge.
- **Real-client QA NOT RUN**: install fresh `dist/WarScore.zip`, `/reload`, `/ws version` should report 68, `/ws`; screenshot to verify gold top line doesn't cross the PvP-rank ruby, owner HK laurel proportions, caption/number centered in empty field, lower rail doesn't clash with PvP deaths label, no cropping or Lua errors. Fine-tune only UI geometry if needed. No changes to unapproved six lower statistic icons or unsupported Alliance custom art.


## Iteration #68 client screenshot → #69 ornamental ratio dividers (2026-11-18)

- The owner supplied the original ornamental ratio divider PNG and a separate overall target mockup (reference only, never runtime art).
- The new ornamental gold horizontal rails, blue diamond intersections, and central gold post replace the legacy individual lines, diamonds and center divider around HK/D and KB/D. Preserve the live labels, ratios, microcopy and untouched other UI.
- Art source: `docs/assets/ratios_frame_owner_v69_source.png` (512×128 indexed, transparent, reduced for transport from the 2048×682 owner PNG). CI converts it to `Media/General/ratios_frame_owner_v69.tga` 1024×256 using Pillow. Full-resolution owner PNG remains the quality reference; potential palette reduction requires client QA.
- UI v69 renders the TGA at 632×140, top y=-615 and removes the old rules at y=-624/-749 and center post. No other layout/data modifications.
- GitHub packaging workflow now generates the TGA before packaging, and commits both TGA and verified installable `dist/WarScore.zip`. The archive must contain only `WarScore/` runtime files.
- **Client QA NOT RUN:** install latest ZIP, `/reload`, `/ws version`=69, `/ws`. Screenshot the ratio module and check rail alignment, diamond color, post overlap, text clearance and lower band spacing. Do not mark accepted until owner screenshot.


## Iteration #69 owner screenshot → #70 ratio ornament texture repair (2026-11-18)

- Real-client screenshot confirms v69 ratio ornament positioning, spacing, center post and text are visually correct, but the owner reports severe broken/noisy lower gold rail.
- Root cause hypothesis: v69 source was reduced to a very low-resolution indexed 512×128 transfer with aggressive palette quantization and then expanded to 1024×256 TGA, exposing jagged partial alpha in thin strokes.
- The owner-supplied original 2048×682 RGBA image was recovered. A higher-resolution 1024×256 transparent indexed transfer was prepared from this original, without changing the artwork, and CI now generates `ratios_frame_owner_v70.tga`. This may not fully eliminate thin-line artifacts; only client QA can establish success.
- UI iteration bumped to 70 and asset path switched; identical artwork geometry and all text/statistic layouts preserved. v69 artwork left in repository for history.
- **Client QA NOT RUN:** download `dist/WarScore.zip`, `/reload`, `/ws version`=70 and screenshot. Inspect the LOWER gold rule left/right of sapphire for any speckling or transparency holes. If still noisy, use an unquantized full RGBA source as the next step.


## Iteration #70 screenshot → #71 ratio text containment (2026-11-18)

- The owner confirms the improved v70 ornamental gold rails render satisfactorily, but the two bottom explanatory microcopy strings fall across/outside the lower rail, while ratio headings visually touch the upper rail.
- No new art was requested and no functionality changes are allowed. Preserve the 632 UI-unit width and the existing ratio texture `ratios_frame_owner_v70.tga`.
- Geometry-only change: ratio ornament height 140→172, top anchor -615→-610 to gain room inside the two gold rails without moving secondary statistics bands; both ratio headings y -636→-644; value text y -668→-673 and size 39→36 with height 44; explanatory texts remain y=-711, font 12. UI diagnostic version = 71.
- **Client QA NOT RUN:** install fresh full ZIP, `/reload`, `/ws version`=71, `/ws`. Check headings clear upper rail, values legible, descriptions entirely above lower rail, and bottom rail does not intersect the top border of first secondary stat band. No art regeneration necessary.


## Iteration #71 owner feedback → #72 compact ratio typography (2026-11-18)

- Owner says v71 is much better but ratio headings still cross the upper gold divider; requests ≥5% smaller ratio values and slightly smaller overall text contents. The existing owner art and geometry must not be changed.
- Keep `ratios_frame_owner_v70.tga` at 632×172, anchor y=-610. Move ratio headings to y=-660, reduce 20→18pt and box 29→22. Reduce ratio value 36→34pt (5.56% reduction), y=-682, box 37. Shift microcopy y=-718, reduce 12→11pt and box 18, preserving both live string contents.
- All other UI, functionality, assets and secondary cards are unchanged. Version diagnostic = 72.
- **IN-GAME QA NOT RUN:** freshly install `dist/WarScore.zip`, `/reload`, `/ws version` 72, `/ws`; verify headings no longer overlap top rail and descriptions remain above bottom rail. Await screenshot before declaring visual acceptance.


## Iteration #72 owner screenshot approved → #73 section spacing refinement (2026-11-18)

- Owner confirms v72 ratio font size and the full ornamental ratio frame look good. Requests slightly lower placement for the entire "MUERTES PvP SUFRIDAS" caption and value, so it is centered between the HK lower rail and the ratios upper rail; also move ratio block up very slightly (about 2–5%) to gain separation before the first secondary-card row.
- Geometry-only v73: death caption y=-534→-544; death number y=-563→-573. Ratio frame y=-610→-600 and ALL its live text anchors +10 UI units (headings -660→-650, values -682→-672, descriptions -718→-708). Exactly preserve internal spacing, fonts and ratios frame 632×172, texture v70. Leave `sectionPlaque`, HK art, rank, cards, logic and all other UI unchanged.
- Packaging expected through existing GitHub Actions to `dist/WarScore.zip`; `/ws version`=73. Real WoW client QA NOT RUN: check that deaths sit visually centered and ratio top rail does not crowd death numeral, while lower ratio rail has more clearance above first card row. Adjust only if fresh screenshot shows a regression.


## Iteration #73 owner screenshot approved → #74 upper card owner ornament (2026-11-18)

- Owner explicitly approves v73 composition and provides `Marco dorado ornamentado con tres columnas(1).png` (2048×682 RGBA) exclusively for the FIRST lower stat row (duels won / battlegrounds played / BG wins). The second lower stat row has different separators and must remain unchanged.
- Owner's artwork features one gold perimeter, bevelled corners, and symmetric full-height vertical gold separators. Integrate it in `statBand` only when `secondary=false`; suppress the previous tooltip-border, manually painted horizontal/side rails, 30×30 corner textures and manual column dividers only for that row. Keep the dark backing, native icons, labels and dynamic values; `secondary=true` retains all previous decorations and geometry exactly.
- Transport source `docs/assets/stat_band_top_owner_v74_source.png`: a palette-reduced 512×128 PNG of the owner's artwork, with original transparent interior. CI crops only alpha padding and converts the asset to 1024×256 RGBA `Media/General/stat_band_top_owner_v74.tga`. Reduced source is provisional: original 2048×682 owner PNG is the reference for any required fidelity refinement.
- No adjustments to upper sections, second card, KPI positions or stats calculations. Diagnostic version 74. GitHub Actions packages complete `WarScore/` ZIP into `dist/WarScore.zip`.
- **WoW-client visual QA NOT RUN:** install fresh ZIP, `/reload`, `/ws version`=74, `/ws`. Inspect upper frame corners and lines for distortion/cropping, duplicate borders, separators intersecting text, contrast/alpha, and relative alignment with the unchanged second row. Request screenshot to refine as needed.


## Iteration #74 owner screenshot approved → #75 bottom secondary card owner art (2026-11-18)

- Owner screenshot confirms top card frame v74 visually accepted. Owner supplied `Marco dorado ornamental con tres secciones(1).png` RGBA 2048×682 for the SECOND (lower) card row ONLY: BG win rate, duel win rate and favorite battleground. This asset has asymmetrical full-height separators at original x≈519 and x≈946, giving more room to the favorite BG column.
- v75 adds `stat_band_bottom_owner_v75.tga`, built in existing CI via `tools/prepare_card_asset.py` from a cropped owner-provided transparent indexed transport PNG at `docs/assets/stat_band_bottom_owner_v75_source.png` (512×128, visual source is the original owner 2048×682 PNG). Like the first card, uses the owner painting directly, not a generated facsimile.
- Remove synthetic border and separator primitives for the secondary card; render only the new frame and existing dark backing. Preserve v74 top card owner's exact texture, dimensions and contents.
- For the bottom row set relative column widths 171 / 153 / 380 (total 704 units) matching the asymmetrical painted separators rather than the old equal-third layout. Preserve all the original dynamic FontStrings, values, icons, statistics calculations and row anchor/size 704×112. The top row retains equal thirds.
- Diagnostic iteration 75. Packaging workflow stages both owner-card TGAs and the full verified ZIP.
- **WoW CLIENT QA NOT RUN:** install fresh `dist/WarScore.zip`, `/reload`, `/ws version`=75, `/ws`. Check lower artwork sharpness, both divider x-positions vs their text and icons, frame corner alignment with upper row and that favorite BG text has adequate space. Validate before further tweaks.


## Iteration #75 owner screenshot → #76 lower card horizontal inset (2026-11-18)

- The owner reports both bottom cards protrude over the LEFT inner gold rail of the parent panel, despite v75 frame artwork and data alignment being otherwise accepted. Scope is ONLY horizontal fit of both lower rows.
- Reduce shared `statBand` width 704→688 UI units (8 units of clearance per side), still centered at x=0, same y positions and 112 height. The existing owner PNG-derived TGA artworks are scaled by `SetAllPoints(band)`, so the illustrations shrink with the frame and stay centered.
- Upper row remains three equal columns, now each `688/3`. Lower row maintains asymmetrical proportions `171:153:380`, scaled proportionally to 688 UI units. Existing text strings, labels/font sizes, icon sizes, frames, bindings, statistics, all previously approved upper sections, and both original TGA files unchanged.
- Diagnostic version 76; full package created via GitHub Actions.
- **WoW CLIENT QA NOT RUN:** install fresh `dist/WarScore.zip`, `/reload`, `/ws version`=76, `/ws`; screenshot the left/right gutters, inspect both frames for parent rail overlap and watch for caption encroachment on inner separator lines. Await owner screenshot for acceptance.


## Iteration #76 screenshot accepted → #77 owner icon trio for top stats (2026-11-18)

- Owner explicitly confirms the v76 horizontal frame inset is now correct and supplies three original transparent RGBA illustrations (1254×1254): gold-hilt crossed silver swords for `DUELOS GANADOS`, crossed Horde flags for `CAMPOS DE BATALLA JUGADOS`, and golden trophy for `BG GANADOS`.
- Replace ONLY the icons on the upper three-column card using `ownerIcon` texture paths. Keep live captions, numeric counters, the v74/v75 band art, band width 688, column geometry, lower-card icons and all upper UI unchanged.
- Owner icons are placed 50×50, left inset 10, vertically 8 UI units below centre; transparency at full alpha; do not apply native inventory icon circular portrait mask (the supplied images are already transparent). Existing secondary row uses its old icon sizes/masks.
- The upload transport in this environment is a transparent 64×64 indexed PNG for each icon (cropped only to artwork, centered, scaled/quantized); `tools/prepare_top_icons.py` converts these to WoW-compatible 128×128 RGBA TGA. The original 1254×1254 user art is the source of truth for any later high-fidelity update; transport compression may lose fine detailing.
- Diagnostic version = 77; CI packages and verifies the full `WarScore/` ZIP. **WoW client QA NOT RUN**: install the new ZIP, `/reload`, `/ws version` 77, `/ws`, and screenshot to review icon scale, transparency, label collision and balance. Only iterate on upper icon treatment unless separately requested.


## Iteration #77 screenshot → #78 upper duels icon clearance (2026-11-18)

- Real WoW Forever screenshot of v77 confirms all three owner icons render; crossed swords for Duelos Ganados appear too close to the left-hand gold bevel, while BG Played flags and BG Wins trophy are acceptable.
- Geometry-only correction: for top-row owner icon i=1 increase left inset 10→24 UI units (+14) while leaving it 50×50, original y=-8, full alpha. Other top-row owner icons stay x=10; second-row native icons stay x=8 with their existing masks.
- Preserve both stat-card owner artwork and dimensions, typography, counters, data binding, and every other previously accepted UI element. Bump diagnostic to 78.
- **CLIENT QA NOT RUN:** install the new complete ZIP, `/reload`, `/ws version`=78, `/ws`; confirm that crossed swords have breathing space without colliding with the title/counter; inspect that flags/trophy remain unchanged.


## Iteration #78 approved → #79 owner icon trio for secondary row (2026-11-18)

- Owner accepted v78 top card icon positions and supplied three transparent 1254×1254 source PNGs for lower row: crossed white gold-trimmed flags to represent **WIN RATE BG**, gold-hilt crossed swords for **WIN RATE DUELOS**, and blue-and-gold battleground pennant for **CAMPO DE BATALLA FAVORITO**.
- Preserve the entire already accepted v78 General layout: both owner frame textures, first-row icons, width 688, column proportions, dynamic texts and values, and all statistics calculations.
- Only secondary row gets the three new texture paths (via `definition.ownerIcon`). Remove the native icon mask for owner icons, render at alpha 1. Lower row sizes 46×46 for first two and 52×52 for favorite BG; x-insets 13/11/16 respectively; y offset -7. Top owner swords retain their v78 x-inset 24.
- Transport PNGs: `docs/assets/icon_bg_rate_owner_v79_source.png`, `icon_duel_rate_owner_v79_source.png`, `icon_favorite_bg_owner_v79_source.png`, compact palette-reduced 64×64 transparent images from the owner's originals. Convert via `tools/prepare_bottom_icons.py` to 128×128 RGBA TGA in `Media/General` before verified ZIP packaging. Source artwork is provisional for fidelity; original uploads are the high-quality master.
- Version diagnostic = 79. **WoW CLIENT QA NOT RUN:** install full ZIP, `/reload`, `/ws version` 79, `/ws`; verify all three icons are correct, not obscured by dividers and do not overlap the titles or rate values, then refine using the owner's screenshot.


## Iteration #79 screenshot → #80 lower card icon scale harmonization (2026-11-18)

- User's WoW screenshot of v79 confirms bottom-row owner assets load correctly, but their visual prominence differs: win-rate duels swords appear too large; win-rate BG crossed white flags and favorite battleground blue pennant appear too small. User approved the proposed modest 50×50 shared viewport and inset correction as the next test.
- v80: set `iconSize = ownerIcon and 50 or 43`, giving ALL owner icons the same 50×50 texture viewport, with old native fallback still 43×43. Top row already used 50×50 and retains its approved placement.
- Secondary-row icon left inset becomes 13 / 13 / 18 (previously 13 / 11 / 16), retaining y=-7 and full alpha; no circular masking. This changes only the size/position of the three lower icons. Existing text, values, frames, assets, and calculations unchanged.
- Important QA note: equal texture viewport size does not guarantee equal visible artwork scale if source alpha padding differs. If perceptual disparity persists, normalize alpha bounding boxes in the asset-conversion script rather than randomly changing individual sizes.
- Diagnostic version 80. **IN-GAME QA PENDING:** install verified ZIP, `/reload`, `/ws version` 80, `/ws`; inspect comparative visual weight and clearance from both gold dividers.


## Iteration #80 owner screenshot → #81 bottom icon optical-size correction (2026-11-18)

- Owner reports lower three icons still significantly mismatched in the v80 real-client screenshot even though all texture viewports equal 50×50. White flags for WIN RATE BG and blue banner for favorite BG look noticeably small; crossed swords for WIN RATE DUELOS dominate the row.
- Root cause verified by examining the compact transparent PNG sources: at alpha≥24 their bounds are BG flags (7,14)-(57,50), duels (5,4)-(60,59), favorite banner (10,7)-(55,56) in 64×64. The files encode different subject proportions and padding; identical UI texture sizes cannot yield identical visible weight.
- v81 updates only `tools/prepare_bottom_icons.py`: crop alpha bounds with 2px antialiasing pad, preserve aspect ratio, and re-center in transparent 128×128 output. Tuned target longest subject sides: BG white flags 110px, duels swords 96px, favorite blue banner 112px. This enlarges the smaller motifs and tones down crossed swords while retaining the original illustrations and transparency. Same filenames/TGA paths reused. Adjust lower icon left insets from 13/13/18 to 16/15/18 to leave consistent margin from separators. All icon UI viewports remain 50×50, anchored at y=-7.
- v78 top icons and ALL frames, texts, statistics, tabs and upper sections remain unchanged. Diagnostic v81. **WoW CLIENT QA PENDING:** screenshot after installing the verified ZIP; compare visible dimensions and left clearance inside all 3 lower cells. If still off, tune each target subject size only, not global card geometry.


## Iteration #81 screenshot → #82 lower win-rate icon and percentage alignment (2026-11-18)

- User's client screenshot of v81 confirms both bottom-row percentage values visually interfere with their icons, with duels swords still oversized. The user requests no new art: reduce the BG win-rate crossed-flags icon 5%, reduce duel win-rate crossed swords 10%, retain favorite battleground icon, and center each win-rate value properly in its own fixed content region.
- Keep existing owner art PNG→TGA processing from v81 and 50×50 top-row icons. In secondary row set the actual texture viewport to 47.5×47.5 (BG), 45×45 (duels), and unchanged 50×50 (favorite). Retain existing insets and vertical positioning.
- The percentage FontStrings for *only* the first two secondary cells now use independent static positioning x=+18 relative to their respective segment centers, width=105, fixed y=-53 and existing 29pt font. This keeps the value centered within an explicit region to the right of its icon and prevents overlap. BG favorite value remains exactly at its earlier anchor/size. Titles, cards, other stats and calculations unchanged.
- Diagnostic version 82. **WoW QA NOT RUN:** after full ZIP installation, `/reload`, `/ws version`=82, `/ws`; inspect both '0%' values for correct spacing from icons and from gold column dividers, and assess relative icon weight. Send new screenshot for acceptance.


## Iteration #82 screenshot → #83 fine alignment of lower win-rate metrics (2026-11-18)

- Real WoW screenshot of v82 shows a significantly improved lower card; the owner requests only a tiny additional reduction of the duel-win-rate swords and review of icon/value alignment. Previous iteration proposal approved: 45→44 UI units for the swords (2.2% reduction, a minimal one-unit visible adjustment), 15→16 for its left inset, and both fixed win-rate percentage caption anchors x=18→19. Text width 105 and y=-53 preserved.
- Keep WIN RATE BG flag icon 47.5×47.5 and its existing x=16, favorite BG pennant icon 50×50 and x=18, all original texture sources/TGAs, frame positions, row widths, border artwork and dynamic values unchanged. Upper stat row and entire upper screen untouched.
- Diagnostic `UI_ITERATION = 83`. No new art conversion required. Package and validate standard `dist/WarScore.zip` via GitHub Actions.
- **WoW CLIENT QA NOT RUN:** install new complete ZIP, `/reload`, `/ws version` (83), `/ws`. Screenshot to confirm even spacing between lower icons, percentages and ornamental dividers before accepting.


## Repository restructuring after UI v83 — CraftAtlas-style addon layout (2026-11-18)

- The owner explicitly requested the repo layout of [hectoresen/CraftAtlas](https://github.com/hectoresen/CraftAtlas), in particular the installable `addon/<AddonName>/` source directory, plus refreshed README and functional/technical documentation. This is a **repo organization** change, not UI iteration 84.
- Moved all 48 runtime files (manifest, Core, UI and Media) byte-for-byte from root into `addon/WarScore/`. Runtime TGA paths remain `Interface\\AddOns\\WarScore\\Media\\...` as before. The installed directory continues to be `Interface/AddOns/WarScore/`.
- Updated all four PNG→TGA preparation tools to write to `addon/WarScore/Media/General/`; updated `tools/package_addon.py` to read the new addon root; CI triggers and asset staging paths updated. The existing `dist/WarScore.zip` URL and single `WarScore/` top-level archive structure are maintained.
- Refreshed README, new architecture/functional/installation/development docs and reconciled stale status claims in AGENTS, OpenSpec README, MVP context and GENERAL_VIEW. Do not use historical proposal descriptions as evidence that already-implemented UI is absent.
- **Automated packaging succeeded. WoW client smoke test NOT RUN after relocation.** The user should install the new ZIP and check `/ws version`=83, `/ws`, `/wsdiag`, image paths and full layout. Preserve v83 screenshot as visual baseline. Do not start another UI change until explicitly requested.


## Iteration #83 in-game BG validation → #84 favorite battleground name fit (2026-11-18)

- Following the repository-layout migration, the owner successfully played one battleground and shared an actual screenshot: HK 92, PvP deaths 14, HK/D 6.57, BG played 1, BG wins 0, BG win rate 0%, favorite `Garganta Grito de Guerra`. This is useful first positive BG-counter evidence and confirms the relocated install runs visually; it does not validate all client APIs or universal BG behavior.
- Observed defect: the third bottom card renders `Garganta Grito de Guerra...` clipped/ellipsized because its dynamic value FontString shares a 145-unit width with the narrow cells despite the favorite section spanning ~371 units.
- v84 changes **only** the favorite BG value anchor to x=+22 and width 265, leaving y=-53, font size 17, height 45, original favorite string (name + newline + played count), blue pennant and card decoration untouched. The two percentage value areas and upper row keep v83 geometry; Lua calculations remain exactly the same.
- No new asset, no API change, no gameplay reclassification. Version diagnostic = 84.
- **Client QA NOT RUN:** install new `dist/WarScore.zip`, `/reload`, `/ws version`=84 and `/ws`. Verify that the full `Garganta Grito de Guerra` and played count appear inside the favorite cell without touching the pennant or the right gold border, with the title above them undisturbed.


## Iteration #84 screenshot → #85 favorite BG played count typography (2026-11-18)

- Owner's WoW screenshot confirms full `Garganta Grito de Guerra` visible inside wide favorite BG card after v84. New request: the `x veces jugado` subtitle must be noticeably smaller and italic, following the original long-term design mockup. No new image assets needed.
- v85 splits the favorite name and match-count into independent FontStrings. Preserve the long green favorite name at 17pt, x=22, width=265, anchored y=-49 with height=28. Add smaller 13pt count at the same horizontal center, y=-74, height=20, cream color, using client's `ITALIC_TEXT_FONT` face with `FRIZQT__.TTF` fallback (WoW `SetFont` flags are not an italic switch). In refresh, handle singular/plural: `1 vez jugado`, `N veces jugado`; clear the secondary caption when favorite is unknown.
- First two secondary cells, all icons, borders, other text, data collectors and UI geometry stay unchanged. Diagnostic `/ws version`=85. **CLIENT VISUAL QA NOT RUN**: screenshot both long-name and played-count line, ensure no overlap with label/title and lower border. If `ITALIC_TEXT_FONT` is not available on the Forever client, the safe fallback is upright; verify in game before claiming true italic acceptance.
- Additional real diagnostic evidence supplied (v84): `GetPVPLifetimeStats()` → `92 | 0 | nil | nil`; `GetPVPSessionStats()` → `60 | 0 | nil | nil`; `GetPVPYesterdayStats()` → `0 | 0 | nil | nil`; `GetStatistic(319)` → `-- | false | 319 | nil`; `GetStatistic(1487)` → `1021 | false | 1487 | nil`; `GetStatistic(1501)` → `14 | false | 1501 | nil`. The HK lifetime and PvP death reads match current UI and v84 screenshot. Session HK 60 must **not** yet be assumed to represent the calendar day; ID 1487 remains unvalidated for PvP-only killing blows. No calculation changes in this iteration.


## Iteration #85 screenshot → #86 favorite count alignment and native italic face (2026-11-18)

- Owner screenshot shows v85 successfully separated `Garganta Grito de Guerra` and `1 vez jugado`, but subtitle still appears upright and aligns to the green name rather than the vertical axis of the `CAMPO DE BATALLA FAVORITO` header.
- Root cause 1: v85 attempted `ITALIC_TEXT_FONT or "Fonts\\\\FRIZQT__.TTF"`; on the tested client the global italic font path is absent, so the regular Friz Quadrata fallback is rendered. v86 retrieves the native `QuestFont:GetFont()` font path if available (WoW's quest-text italic candidate), then `ITALIC_TEXT_FONT` if set, keeping the existing text face only as last fallback. This is an unverified font availability/appearance test, not proof of actual italics in Forever.
- Root cause 2: v85 positioned name and subtitle at x=+22. V86 keeps the green BG name x=+22, width=265, and places **only** its played-count FontString at segment center x=0, width=190, y=-74 to share the title's vertical axis. The 13pt size, text, color, singular/plural, and panel art stay unchanged.
- No changes to stats readings, ratios, other cards or assets. Diagnostic version 86.
- **GAME QA NOT RUN:** install ZIP, `/reload`, `/ws version`=86, `/ws`. Inspect center alignment with favorite title and verify whether native QuestFont actually renders italic. If not, a confirmed italic TTF asset/license or designer-approved non-italic fallback is necessary; do not falsely mark typographic requirement complete.


## Iteration #86 screenshot accepted for alignment → #87 genuine italic font (2026-11-18)

- Owner confirms v86 favorite play-count alignment is now correct, but text remains upright. Owner approves v87 dedicated exclusively to actual italic typography. No additional visual layout changes.
- v87 replaces the unreliable `QuestFont` / `ITALIC_TEXT_FONT` logic with a real `Spectral-Italic.ttf` (Google Fonts Spectral project, SIL Open Font License 1.1). Only the 13pt `x veces jugado` FontString uses `Interface\\AddOns\\WarScore\\Media\\Fonts\\Spectral-Italic.ttf`. All x/y positions, labels, other font faces, portrait, frame art, assets, statistics and ratios remain unchanged.
- Font source: `google/fonts/ofl/spectral/Spectral-Italic.ttf`, pinned Git blob SHA `99d6c2def129dea2daa47652c2168c271c7a59a7`; `tools/prepare_italic_font.py` verifies SHA, downloads only when not already present. `Media/Fonts/OFL.txt` is included in distributed ZIP for license compliance. `tools/package_addon.py` resolves runtime TTF paths as well as TGAs; GitHub Actions verifies and commits the TTF alongside the installable ZIP.
- Diagnostic = v87. **IN-GAME QA NOT RUN:** install fresh `dist/WarScore.zip`, `/reload`, `/ws version` 87, `/ws`; verify true slanted italic letters, subtitle horizontally centered under the section title and no clipping, and confirm the font loads without LUA errors.


## Iteration #87 visual confirmation → #88 bottom-card clearance (2026-11-18)

- Owner screenshot validates the italic favorite BG count in v87 and reports a faint external dark background / apparent second frame overlapping the parent panel's **bottom inner gold rail**, directly beneath the second (win-rate) stat card. Scope is solely lower-card containment, not a redesign of the approved texture.
- Existing `statBand` renders a dark rectangular backdrop plus the owner full-frame TGA at the exact band extents. The second card was anchored at y=-878, height 112. Conservative v88 geometry correction: change only the second statBand anchor to y=-870, lifting its entire background, asset, icons, texts and values together **8 UI units** to give the parent lower border additional visual clearance; top card stays y=-758 and its art untouched. No height, width or relative child offset changes; no custom asset replacements.
- UI diagnostic `/ws version`=88. **CLIENT QA NOT RUN:** install fresh verified ZIP, `/reload`, `/ws` and inspect the gap below the second card, whether the parent inner border is unobscured, and whether the increased separation from the first card is still visually acceptable. If a residual seam persists, investigate `statBand`'s solid dark backdrop/texture alpha rather than shrinking the owner's ornament.


## Iteration #88 owner screenshot accepted → #89 honor and PvP deaths metric swap (2026-11-18)

- Owner's v88 screenshot confirms the lower-card bottom-border collision is resolved. Next requirement: KB/D is permanently unsuitable for the MVP because WoW Forever does not expose validated PvP-only killing blows. Replace the right-hand KB/D field with **MUERTES PvP SUFRIDAS** in red, move the existing `1501` PvP-death value into that frame; replace the central red `MUERTES PvP SUFRIDAS` block with **HONOR** and its live current spendable honor value.
- Honor source documented and manually checked through `/wsdiag honor`: `UnitHonor("player")` returns current honor, `0` in the tested character; it is **not** lifetime earned honor and may fall after spending. `Core/Stats.lua` now guards `UnitHonor` with `type`, `pcall`, numeric nonnegative validation and returns `honorCurrent` or nil. UI displays `—` on unavailable values, not an invented zero.
- Central HONOR label/value remain at the existing positions (-544/-573), now gold; same section background and 39pt value. Right-hand ratio cell becomes 16pt red `MUERTES PvP SUFRIDAS` and 34pt red counter at existing anchors (-650/-672). HK/D left and its formula unchanged. The KB/D descriptive subtitle is removed; the right-hand area has no redundant description.
- All other cards, portraits, icons, dynamic statistics, stage geometry, font files, artwork, and packaging unchanged. Diagnostic version 89.
- **CLIENT QA NOT RUN:** install new ZIP, `/reload`, `/ws version`=89, `/ws`. Confirm central HONOR shows the actual spendable value, right cell shows death count (e.g. 14), title does not overflow or collide with sapphire separator, and no duplicate deaths/KB/D appear.


## Iteration #89 screenshot → #90 align right PvP death KPI (2026-11-18)

- The owner tested v89 in the WoW client. The new center `HONOR 0` is rendered correctly and the right-hand `MUERTES PvP SUFRIDAS 14` text is functionally correct, but the latter pair looks shifted toward the right of its ornamental half-cell.
- v90 is an intentionally isolated visual adjustment: title and red death counter now share `rightMetricX = +150` relative to the window center, replacing their previous independent +165 anchors (15 UI units left). Preserve the existing y anchors (-650 and -672), text sizes (16 and 34), colors, font, widths, actual death value, divider artwork and UI frame dimensions. Left HK/D remains at -165; all other UI parts and Stats.lua unchanged.
- Diagnostic version = 90. **CLIENT QA NOT RUN:** install ZIP, `/reload`, `/ws version`=90 and `/ws`; inspect optical centering of both the red heading and value in the right half without touching the central sapphire divider or frame edge.


## Iteration #90 accepted → #91 replace close button artwork (2026-11-18)

- Owner confirms v90 is correct and provides an original transparent 1262×1246 PNG showing a square steel frame, red enamel and gold X. The explicit request is to replace the **close X button**, placed at the existing top-right close control seen in the design example; this is **not** the settings gear below it.
- The v90 close X was baked into `outer_frame_owner_v67_trimmed.tga`, with a transparent 43×43 hit area. v91 adds the owner's self-contained square close asset as a 50×50 texture over that location, with a dark underlay to occlude the old painted X, and keeps `close:SetScript(OnClick, window:Hide())`. Placement remains TOPRIGHT of window, x=-48/y=-28, corresponding to the established close control. It is not a second active X.
- `docs/assets/close_button_owner_v91_source.png` is a 96×96 optimized RGBA-preserving transfer copy cropped from the owner's attached PNG. `tools/prepare_close_asset.py` converts it to a 128×128 transparent TGA for the game. CI builds and commits the TGA and validates the same `dist/WarScore.zip` installable structure and embedded `UI_ITERATION = 91`.
- Other visual elements, settings gear, gameplay statistics, fonts and frame borders untouched. **WoW QA pending:** install fresh version-pinned ZIP, `/reload`, `/ws version`=91, `/ws`; check the new gold X frame covers the previous baked art cleanly, aligns with the header, and closes on click. If a dark square is exposed around transparent corners, refine the underlay/masking using actual client screenshot.


## Iteration #91 client screenshot → #92 restore close-button exact footprint (2026-11-18)

- The owner reports the v91 replacement gold X appears mispositioned compared with its original embedded counterpart. Side-by-side comparison of the actual v90 and v91 screenshots confirms that the new 50×50 button is noticeably taller/wider than the original control and juts beyond the top-right header rail.
- Root cause: v91 changed the original close hitbox from **43×43 to 50×50**, while preserving its top-right offset `(-48,-28)`. Expanding toward the left and bottom displaced the visual center and increased the apparent external frame.
- v92 retains the owner's gold X artwork/underlay and tested `OnClick` behavior but **restores the original 43×43 footprint and the original TOPRIGHT `(-48,-28)` anchor**, with the overlay using `SetAllPoints(close)`. Other controls, including settings, are untouched.
- Diagnostic = 92. **CLIENT QA NOT RUN:** install verified ZIP; compare the gold X position to the header's right edge and confirm there is no double X/old ornament bleed-through, dark square artifact or loss of close click area.


## Iteration #92 screenshot → #93 restore close X, relocate gear and fix Honor currency (2026-11-18)

- Owner rejects v91/v92 close-X replacement as a regression: screenshot shows misplaced duplicate art. Explicitly restore **the v90 close control verbatim** (original X baked into the exterior frame, 43×43 transparent click target TOPRIGHT -48/-28, no underlay or extra texture). Stop building v91 close-button TGA into distribution; preserve source history only.
- Owner's intent is a **single settings gear directly under the close X**, as in the earlier design mockup. Reuse the current `settings_cog` texture and bordered 36×36 frame rather than inventing another asset. Move only its frame from TOPRIGHT (-77,-123) to (-51.5,-85), putting its horizontal center on the close X center and separating their vertical footprints. The previous gear location is no longer occupied. Settings remain a placeholder with existing tooltip.
- Owner requests the actual **currency Honor (ID 1792)** from `C_CurrencyInfo.GetCurrencyListInfo`, not `UnitHonor`. The proven diagnostic `/wsdiag currencies` returned list row index 2, `Puntos de honor | cantidad 252 | max 25000 | ID 1792`. Since GetCurrencyListInfo takes a list index rather than currency ID, the implementation safely enumerates from 1 to `GetCurrencyListSize()`, matches `currencyTypesID` or `currencyID` == 1792, and extracts `quantity` (or `count`) and `maxQuantity`. Lua API functions are guarded with `type` and `pcall`; a missing currency results in nil rather than assumed 0. No `UnitHonor`, `UnitHonorMax` or `GetInspectHonorData` is used for the General balance.
- Central HONOR now displays `cantidad / máximo` with thousands separators (e.g. `252 / 25.000`); max unavailable => `252 / —`, currency absent => `—`. Font reduced from 39 to 32 to accommodate the pair, existing center axis and gold color preserved. Other metrics and ornamental assets untouched. UI diagnostic version 93.
- **Client QA PENDING:** install commit-pinned ZIP, `/reload`, `/ws version` 93, `/ws`. Confirm v90-style X, exactly one cog below it, click-to-close, and honor 252 / 25.000 from currency 1792 without Lua errors; confirm no regression to other fields.


## Iteration #93 owner screenshot → #94 real gear asset below close X (2026-11-19)

- Owner confirms Honor `252 / 25.000` reads correctly from currency 1792. The issue is visual: the settings gear still uses the older black/small graphic. The owner has now supplied the **correct transparent gold gear asset** with red enamel and beveled metal frame, explicitly distinct from the previously and mistakenly sent X asset. **Do not touch the X**, which is baked into the window's outer-frame art with a transparent 43×43 click target.
- v94 removes the old cog's BackdropTemplate, separate WoW border and legacy `settings_cog` texture, replacing all with a **single 38×38 owner-provided framed gear texture** `settings_gear_owner_v94.tga`. Anchor TOPRIGHT x=-50.5, y=-78: vertically 7 units below the original close X (top -28, height 43, ends -71); both horizontal centers share x=-69.5 from the window right. Tooltip and nonfunctional placeholder stay unchanged.
- Source `docs/assets/settings_gear_owner_v94_source.png` is an 80×80 transparent palette-optimized transfer copy of the user's 1262×1246 PNG, with alpha-space cropped to the full ornament. `tools/prepare_settings_gear.py` converts it into an RGBA 128×128 TGA under `addon/WarScore/Media/General/`. The CI generates the asset and commits the distributable with `dist/WarScore.zip`, checking embedded UI version 94. The original higher-resolution upload remains the master for future upgrades.
- No changes to honor logic, other statistics, X artwork, UI panels, textures, or font styling. **Client visual QA PENDING**: download the commit-pinned ZIP, `/reload`, `/ws version` 94, `/ws`; verify gold gear appears centered below X, only one gear exists, no extra border, and no visual clash with upper-right corner of the inner frame.


### v94 CI transport image correction

- The initial v94 source PNG blob was corrupt in GitHub despite working on the local machine; CI correctly rejected its broken image stream and **no v94 ZIP was released**.
- Replaced source with a CRC-valid 48×48 transparent palette-optimized copy of the original owner art (Git blob SHA `00cde674f21aa97a60b7e02d6cdbe62243ed8a89`, validated against local bytes). The final game TGA is still 128×128 with full alpha. This smaller transfer size is suitable for the 38×38 UI draw area.
- Re-run CI packaging and confirm source read, TGA, and embedded `UI_ITERATION = 94` before distributing.


## Iteration #94 owner screenshot → #95 settings-gear optical alignment (2026-11-19)

- The owner reports that the new gold cog appears slightly right and low compared to the existing top-right X. The owner explicitly instructed to iterate without asking for confirmation whenever the requested adjustment is clear.
- v95 moves **only** the existing settings gear frame by 3 UI units left and 2 UI units up: TOPRIGHT from (-50.5,-78) to (-53.5,-76). Keep its 38×38 size, owner-supplied TGA, tooltip, transparency and single-instance behavior. The original built-in X and its click target remain untouched; all gameplay stats, honor currency, other assets and panels remain unchanged.
- UI diagnostic = 95. **IN-GAME QA PENDING:** install the pinned verified ZIP; `/reload`, `/ws version` 95, `/ws`; inspect the visual alignment of the gear directly below the X without overlap or offsets.


## Iteration #95 owner screenshot → #96 settings gear and 'Hoy' tab alignment (2026-11-19)

- Owner's v95 in-game screenshot confirms gear asset is correct but still requires a slight placement refinement; the owner additionally requests that the dynamic `Hoy` label be visually centered within its inactive painted tab. No new assets requested.
- Move the **single** framed settings gear a further 4 UI units left and 1 unit up: TOPRIGHT `(-53.5, -76)` → `(-57.5, -75)`. Leave its 38×38 size, graphic, tooltip and the **X close art/click area** completely unchanged.
- Move only the `Hoy` FontString 5 UI units left relative to its existing button: x `0` → `-5`, y remains `-2`, 15pt font, 135×29 text frame and unchanged tab hitbox. The General tab, backgrounds and other UI are untouched.
- Diagnostic version = 96. **WoW screenshot QA pending:** install verified ZIP, `/reload`, `/ws version`=96, `/ws`; inspect gear center relative to X and optical horizontal centering of `Hoy` inside painted tab, with no effect on closing or hover tooltip.


## Iteration #96 screenshot → #97 settings gear final micro-alignment (2026-11-19)

- Owner visually inspected v96 and asks for another tiny optical correction of the gear: approximately 1 mm to the left and 2 down. This translates to a conservative 1 UI unit left and 2 UI units down for an in-game follow-up, with no other changes.
- v97 adjusts only the same settings-gear TOPRIGHT anchor from (-57.5,-75) to **(-58.5,-77)**. Keep the owner's 38×38 gold gear art, its tooltip, the original baked close X and click target, General/Hoy tabs, and all stats unchanged.
- Diagnostic UI iteration = 97. **Client QA pending**: install version-pinned ZIP, run `/reload`, `/ws version` (97), `/ws`, verify centered alignment under the X without touching the tab/inner border.


## Iteration #97 accepted → #98 Hoy hover and Honor asset (2026-11-19)

- Owner confirms v97 gear and close alignment satisfactory and requests the usual installable addon iteration, **not a mockup**. Two changes only.
- Add `Hoy` hover tooltip using the same `GameTooltip:SetOwner(self, "ANCHOR_RIGHT")`, gold text and `OnLeave` dismissal as the current Ajustes tooltip. Exact wording: `Hoy (Próximamente)`. Existing inactive tab click/message remains unchanged.
- Integrate the user's supplied transparent crimson-and-gold **Honor frame with raised central plaque** in the central Honor area: `honor_panel_owner_v98.tga`, displayed 640×134 at center TOP -520. Remove the former plain `sectionPlaque` behind Honor to avoid duplicated ornaments. Keep HONOR heading dynamic at y=-544 and currency value at y=-573 with unchanged font size/color, retaining live currency ID 1792 `cantidad / máximo` formatting and the left/right ratio statistics below.
- The source is derived exclusively from the user's `Marco de honor dorado con panel carmesí(1).png`, transparent central panel crop (approximately original x=55..1990, y=134..537), resized to 256×64 with 48-color palette optimization and stored as a compact PNG transport under `docs/assets/honor_panel_owner_v98_source.png`. The reproducible converter `tools/prepare_honor_panel.py` creates the 1024×256 alpha TGA for the installable addon; CI commits it and the verified `dist/WarScore.zip`.
- Diagnostic version 98. **In-game QA pending**: verify tooltip appears on hover only, that Honor panel fits between 92 HK and ratio rails without overlapping either, HONOR and value stay centered, and the rest of the layout/X/gear remain unchanged. No new mockup is a substitute for this game test.

- Transport asset checked against local original conversion (Git blob `9e33ef95ddfe069784363d14bfda31e5cd542df9`). Optimized small source for runtime display; original upload remains the high-quality master.


## Iteration #98 client screenshot → #99 Honor heading optical alignment (2026-11-19)

- User confirms the ornamental Honor frame is appropriate but notes the `HONOR` FontString sits too low within the small raised top plaque. Keep its x center = 0 and font size = 17 while moving it vertically 10 UI units up: y -544 to -534. Currency value, gear/X, tooltips, and the entire rest of the UI remain unchanged.
- Visual softness of the gold borders diagnosed: earlier asset was downsampled from owner's high-resolution original to **256×64 with only 48 palette colors**, then enlarged to 1024×256 before being drawn at 640×134, losing genuine detail. The original 2048×682 RGBA user asset was located again and should be the source for a future unquantized revision; stretching after aggressive downsampling cannot restore lost detail. Do not request another original from the owner.
- UI version 99; WoW visual QA pending.


### v99 — recovered original source / Honor frame quality correction

- Follow-up confirms the exact original uploaded owner asset was still available at full RGBA resolution **2048×682**. The coarse v98 frame came from the 256×64 transport image enlarged to 1024×256. That downsample and 48-color quantization caused visibly soft/pixelated gold edges.
- A **new, directly cropped source** from the original alpha content (crop x=60..1988, y=150..535), resampled **once** to 512×104 and optimized as a compact RGBA-preserving indexed PNG, now replaces the 256×64 source under `docs/assets/honor_panel_owner_v98_source.png`. The new PNG blob is `4b8d00b3e92c5d7c2c07494f505b270b940872ae` (verified exact SHA against generated bytes). The TGA converter now expects 512×104, still produces a transparent 1024×256 TGA. No new input is required from the owner.
- FontString `HONOR` is 10 units higher so its vertical center matches the small raised title plaque; currency value stays dynamic and unchanged. The rest of the UI remains exactly as v98. **WoW screenshot QA is needed** to determine final perceived sharpness and precise alignment.


## Iteration #99 → #100 PvP rank bar and real Rank Points (2026-11-19)

- Use the **21 owner-authored 900×50 fill PNGs** in `docs/assets/rank bars/WarScore_RankFill_000..100.png` plus `Placa dorada hexagonal para rango PvP.png`, as described by `WarScore_coordenadas_marcos.json`. CI `tools/prepare_rank_bar.py` converts all images to TGA without generating replacement illustrations. All variants have identical extents; user sees 5% rounded segments, not an interpolated fake fill.
- Get live PvP-rank data only from the verified Forever major faction `C_MajorFactions.GetMajorFactionProgressionInfo(2800)`: `renownLevel` (0=sin rango), `renownReputationEarned` (points), `renownLevelThreshold` (goal), and `maxLevel` if supplied. Guard with `type()`, `pcall()`, non-negative number parsing, nil for unavailable. Never confuse Honor currency 1792 with Rank Points currency 3468. `UnitPVPRank` and `GetPVPRankProgress` are not available.
- PvP rank localizations: first actual rank 1 maps to `PVP_RANK_5_<faction>` (Horde 0, Alliance 1); at rank 0 show `Sin rango`, and next rank name from level+1. Missing localized title uses `Rango N` as a label, not a fabricated named PvP rank. The current plaque becomes dynamic.
- Layout: existing rank plaque untouched, insert 330×22 bar at top -451 with two 139×40 nameplates and live `points / threshold PR` label above plus real percent below. Shift all subsequent existing blocks (HK, Honor, ratios, two cards) down **85 units as a coordinated group** while expanding the overall window height 1060→1145, preserving their approved internal alignments and spacing. Keep Honor graphic and currency display as in v99.
- Progress availability: percent is calculated only with valid points and threshold>0, clamped 0..100 then nearest 5% image; missing threshold shows `—`, no fake 0%. The complete 100% state also represents the validated maximum rank if the major-faction API provides maxLevel. Points remain raw integers with thousands separators.
- Diagnostic `/ws version`=100. **CLIENT QA PENDING** for authentic art placement, whether nameplates have correct aspect ratio, text overlap, overall height, and runtime data at level 0; obtain screenshot and iterate without asking for routine confirmation.

- CI fix: package_addon.py enumerates all 21 dynamically chosen `rank_fill_000..100.tga` files; the partial literal path `rank_fill_` is not a physical file. Asset-generation order remains before packaging.


## Iteration #100 screenshot → #101 Honor removal and accurate full-frame rank bar (2026-11-19)

- The v100 screenshot exposed three clear regressions: an improvised skinny track instead of the user's fully framed gold rank bar; stretched, detached rank plaques; and over-expansion of the window with lower cards shifted too far down.
- The owner supplied a **new complete gold-framed PvP progress bar** in `Marco dorado de barra de progreso fantástica(1).png`, original 2048×682 with transparent margins. v101 uses its authentic frame silhouette, cropped from the source (x=145..1905, y=220..450), then a transparent 512×64 transport PNG and a 1024×128 RGBA TGA. No extra bevels/lines or stretched separate plaques.
- Keep the 21 originally supplied progress-fill textures and real Major Faction 2800 source. Fill lies inside the central portion of this one 640×72 frame at top -440. Rank-current/next names live inside the end portions, current/threshold PR is centered *inside* the bar, and percentage is a small secondary value at its lower center. The 0%, partial and 100% fill states remain dynamic; no fake percentages. The old external rank-name plates are no longer referenced or shipped.
- Temporarily remove the entire Honor card from the General UI (no title, no graphic, no live counter). **Do not remove or alter collection of currency 1792 in Core/Stats.lua**, so it remains ready for a future redesign.
- Reflow: HK card top -512, ratio ornament top -640, first and second statistic bands top -817 / -936. Overall window height reduces from 1145 to 1105, preserving about 58 px to the bottom border; extend the interior artwork height from 943 to 985 so it encloses the lower cards. Other visuals and the upper PvP plaque remain untouched. Rank bar and cards remain horizontally centered.
- CI generates the rank-bar TGA from the transport PNG and verifies the addon ZIP contains only runtime files. UI diagnostic version **101**.
- **Real WoW screenshot QA pending**: inspect frame and fill alignment, visibility of both names, text legibility at 25/750 and bottom clearance. Iterate from screenshot, do not assume code is a substitute for in-client visual validation.


## Iteration #101 screenshot → #102 separated rank components and card clearance (2026-11-19)

- Confirmed client's v101 screenshot: decorative long gold bar had been incorrectly drawn 640 UI units wide, thus enclosing rank names and fill inside one panel, instead of gold center bar plus separate side rank plates; lower stat bands also overlap the inner parent frame's bottom rail.
- **Rebuild only rank arrangement** using the real v101 owner frame at 365×48, x0, y=-451 as a separate central texture. Reuse all 21 progressive fill textures inside at 326×19, x0, y=-466. The real current/next values and PR numerator/denominator remain dynamic, with PR centered *inside* bar at y=-463; percentage is a small caption immediately beneath at y=-499. Honor remains temporarily absent.
- Restore separately generated `rank_name_plate_owner_v102.tga` from the actual original 1 MB PNG `docs/assets/rank bars/Placa dorada hexagonal para rango PvP.png`. Crop transparent empty margins, preserve the source aspect in a 256×128 alpha canvas (no stretched 139×40 nameplate). Draw two independent plates at x±257, y=-446 with 136×55 viewports and names centered x±257 at y=-460. Plates visually flank the meter; neither is inside the meter's gold border.
- Lift first/lower statistics rows from -817/-936 to **-793/-908** respectively. Their painted background height changes 112→104, segment viewport 108→100; interior texts/icon offsets remain untouched. This provides clear bottom inset and retains a modest gap between two rows.
- Keep main window size/outer texture, gear/close, portraits, rank API and HK/ratio layout unchanged. UI iteration = **102**.
- **WoW visual QA pending:** inspect side-plate shapes, center PR text and actual bar fill, ratio-to-first-card margin, bottom clearances, overflow, hover text. Fine-tune from in-game screenshot.


## Iteration #102 screenshot → #103 (2026-11-19)

- The user clarified the previously generated image is **only the visual reference**. v103 implements actual WoW Lua and assets, not another mockup.
- Fix pointed PvP rank plates: original source has stray near-transparent pixels; crop using alpha >= 8 before resizing to existing 256x128 TGA. Draw each plate at 185x115, x ±267, top -417, with dynamic 13pt labels centered x ±267 at y -462. Visible plates are enlarged and closely flank the 365x48 gold central progress bar; the central bar and live 25/750 PR remain unchanged.
- Move both lower statistic rows upward by 18: first y -793 to -775; second y -908 to -890. Both share a 688x104 frame size and preserve the intentionally different column divisions and live text. Normalize the bottom card PNG alpha crop using the same threshold/2px expansion already used on the upper PNG to eliminate source-padding variations in painted outer dimensions.
- Version 103; no Honor card, no changes to PvP rank API, X, gear, portrait or stats. Client screenshot validation pending.


## Iteration #103 screenshot → #104 — precise owner rank frame, captions and cards (2026-11-19)

- Owner supplied *this precise* pointed gold-edge dark-panel PNG `Placa dorada hexagonal para rango PvP(2).png`, 2048×682. Use it **only for the central rank progress container**, not the lateral nameplates, and do not draw an invented substitute. The alpha-visible artwork (crop x105..1938, y173..500) was downsampled once into a 384×72, 128-color transparent PNG transport `docs/assets/rank_bar_frame_owner_v104_source.png`; converter produces 1024×128 RGBA TGA `rank_bar_frame_owner_v104.tga`. Keep the uploaded original as the master outside the repository; only transport is committed.
- Remove the external percentage below the bar entirely, while keeping the 21 5%-increment author textures, real points data and central `actual / goal PR` text. Keep layout central frame at 365×48, top -451, names left/right using the independent original pointed nameplates at 178×108, centered x ±269, y -421; live names at x±269, y -462.
- Lower rows: use **exactly the same shared band width 688** and height 100, centered x=+3 for both, preserving intentionally different per-cell divider widths. Move upper from -775→-767 and lower -890→-878, producing consistent gaps and added clearance above the parent's lower border. Preserve all icon/text data and all outer artwork.
- Raise ratio art and its descriptions 7 units to preserve breathing room above top row, without altering the HK title or portrait.
- UI version 104. Client visual QA pending: assess frame fidelity and side labels, confirm raw PR centered, and inspect equal row widths and bottom inset. Keep Honor removed until a future specified iteration.

- Final v104 rendering correction before distribution: the original asset's alpha-visible aspect is ~5.61:1, so its in-game view is 365×65 (not horizontally stretched to 365×48). The rank frame uses BORDER instead of OVERLAY layer, allowing the authentic 0–100% dynamic ARTWORK fill to remain visible above its dark interior; content stays inset inside golden edges and data text remains above both.


## Iteration #104 screenshot → #105 (2026-11-19)

- Actual WoW addon iteration only (no mockups). User v104 screenshot shows too much height in central rank container, lower card rows too high, and card values/icons too close to their bottom rims, especially italic favorite play-count.
- Keep **exactly the existing owner v104 ornamental frame TGA**; narrow its displayed vertical height from 365×65 at y=-441 to **365×48 at y=-450**. The existing dynamic rank fill becomes 326×21 at y=-464 to occupy the interior more closely. Raw current/goal PR remains centered; all 21 progress steps and rank API remain unchanged.
- Move both stat-card rows down **12 UI units**, first y=-767→-779 and second y=-878→-890; retain their identical **688×100** frames and current divider arrangements.
- Scale all six icons and numeric values to **95%** without scaling the frames; shift icons 2 units inward/up and values 3 units up. Favorite play-count italic is font 12.35, raised from y=-74 to -66, with its independent centered caption preserved. Captions and stat readings remain dynamic and unchanged.
- UI diagnostic version = **105**. Client QA pending for centered fill, breathing room and lower-frame clearance.


## Iteration #105 screenshot → #106: rank frame fitting and symmetric plaques (2026-11-19)

- User explicitly requests **only a real addon iteration, never mockups**. Keep all other v105 visuals, cards, statistics, and layout untouched.
- Retain the exact designer-supplied central rank bar texture `rank_bar_frame_owner_v104` and existing 21 increment textures; the central frame is **365×38** (was 365×48), top **-455** (was -450), maintaining the exact center and width. Increase dynamic fill to **326×25** (was 326×21), top **-461** (was -464), to occupy the visibly reduced interior. Real PR values stay centered and unchanged.
- Reuse exact owner-pointed nameplate texture `rank_name_plate_owner_v102`: shrink both plates by approximately 5%, from **178×108 to 169×103**. Center both at **x=-265/+265** (previously -269/+269), top **-423** (previously -421) so their outer edges are equal and now farther inside the surrounding parent border. Center the labels on the same ±265 axes with 143-wide text areas; no other text changes.
- Increment `UI_ITERATION` to 106. Leave lower rows exactly as validated in v105. **WoW client visual QA pending** on gold bar fit, 5%-step fill overlay, left/right margins and titles.


## Iteration #106 screenshot → #107: rank bar fill and left nameplate (2026-11-19)

- Owner's in-game v106 screenshot: the left `Sin rango` plate is visually crowded by the inner left border/banner, while the right `Explorador` plate looks acceptable. The 5%-progress circular golden cap is vertically undersized relative to the center ornamental frame.
- UI code commit `61b3eb3b61e22b25e922977ed5068cfd05447225`: retain **the identical** `rank_name_plate_owner_v102` TGA for both sides and existing 169×103 display sizes. Move only the left plate and its centered title from x=-265 to x=-255, leaving the right plate at +265. This is an *optical* adjustment in the presence of the banner, not a claim that the TGA shapes differ.
- Keep central `rank_bar_frame_owner_v104` unchanged at 365×38, top -455. Increase the existing, authentic rank-fill texture from 326×25 to **326×32**, top from -461 to **-458**, retaining its center. This makes the source 5% gold cap occupy more of the available frame height; the progress remains a real 5%-step alpha image and not a generated/stretched solid track. Note that source fill 005 contains a gold starting disk plus transparent pixels, so the rest of the bar is correctly unfilled.
- Increment UI diagnostic from 106 to **107**. No new texture assets were authored, changed or substituted. No changes to PvP data, current/next rank names, numeric PR label, banners, HK, ratio or lower cards.
- Static review only: **client screenshot QA still pending**. Reinstall packaged v107, `/reload`, `/ws version`, `/ws`; verify that both plate margins appear balanced and the gold cap fits inside the central frame without covering its outlines. If the source art's intrinsic margins continue to defeat acceptable alignment, **request correctly matched owner PNG assets** instead of recreating them.


## Iteration #107 screenshot → #108: unified designer-authored PvP rank progress (2026-11-19)

- Owner accepted v107 composition but provided a new original 2048×682 transparent PNG containing **all three rank-meter compartments in one continuous gold frame**, with two red gems dividing current rank, progress and next rank.
- UI iteration 108: replace all three old rank panel/nameplate textures with a **single 730×69 owner frame** at top y=-440, and center live rank names at x=-281/+281, y=-461. Preserve `points / threshold PR` at x=0/y=-463 and continue displaying the 21 real fill textures for 0..100% in 5% steps, now within center section (362×32, top=-459). All other metrics, bands, portrait, API calls and stored statistics unchanged.
- Asset transport is authored from owner's supplied artwork; the first pass downsampled/quantized transport image uses 1024×128 RGBA-compatible source dimensions, then converts directly to a TGA using `tools/prepare_rank_bar.py`. Keep the original user PNG as the visual master for any future quality improvement.
- One-time GitHub bootstrap uses an uploaded Git blob plus checksum-verified correction segment, and commits the transport PNG so subsequent builds are self-contained. The packaging workflow must include the new `rank_panel_owner_v108.tga` in the addon ZIP and validate that `/ws version` reports 108.
- **Owner native-client QA pending**: check all three compartments, 5% fill visually matching the center track, rank titles do not cross red gems, and no collisions with banner or HK module. Verify both 0% and 100% when attainable. Reiterate only from owner's screenshot.


## Iteration #108 screenshot → #109: inset complete rank frame and align fill/labels (2026-11-19)

- Owner's real v108 screenshot: the single-piece gold PvP frame renders successfully, but its side compartments sit too close to / beyond the inner window edges. The 5% fill overlaps the center gold rails instead of fitting fully inside its dark center aperture. The current/next names must stay centered in their separate boxes.
- Change **only** `addon/WarScore/UI/General.lua`: unified `rank_panel_owner_v108` frame from 730×69, top -440 to **690×65, top -442**, preserving the original image aspect ratio and center. Both outer ends are now inset by 20 units per side, without modifying other UI components.
- Authentic 21-step fill is unchanged as an asset and still selected from real PvP rank points; resize from 362×32, top -459 to **310×24, top -462**, so the round 5% gold cap fits within the center dark aperture, without painting over the border/gems.
- Re-anchor real current/next rank labels from x±281 to **x±259**, top -462, width 132 (was 155), matching the panel's left/right compartments. PR label remains x0, top -463 and unmodified. No new assets or fake progress graphics.
- Diagnostic `/ws version` increments to **109**. No changes to major faction data, rank name resolution, counters, cards, banners, portrait, or frame visuals elsewhere.
- Packaging CI must produce a fresh installable `dist/WarScore.zip` containing v109, generated from the existing original textures; verify ZIP version parity and valid TGA paths. Client render is still pending owner screenshot; check margins, gem clearance, 5% gold cap, and 0%/100% progress as possible.


## Iteration #109 screenshot → #110: center owner triptych; temporarily hide progress fill (2026-11-19)

- Owner's in-game v109 screenshot confirms the unified three-box PvP rank frame is close to the intended result, but looks offset left against the inner-window border. User requests moving **the complete frame, both rank names and the PR counter** slightly right together.
- Move owner `rank_panel_owner_v108` 690×65 from x=0 to **x=+8**, keeping top=-442 and existing proportions/texture. Move the live left rank caption x=-259→**-251**, right rank caption x=+259→**+267**, and center PR x=0→**+8**, so the entire module shifts as one unit.
- Per explicit owner instruction, temporarily **remove the rendered 5%-step progress fill**; the center compartment displays only the live real `points / threshold PR` text. Remove runtime creation/use of `fields.rankFill` to prevent an accidental fill rendering. Preserve all original 21 0–100% texture assets, percentage calculation helper and real PvP-rank data acquisition for future iterations.
- All three gold boxes, red divider gems, rank-name localization, character/rank plaque, HK, deaths, ratios and lower stats cards are unchanged. UI diagnostic `/ws version` increments **109→110**.
- CI package must contain updated `UI/General.lua` reporting v110; installable `dist/WarScore.zip` must be verified. In-game screenshot QA pending for balanced left/right margin, aligned live captions and empty dark center compartment.


## Iteration #110 screenshot → #111: 95% PvP rank triptych and true horizontal centering (2026-11-19)

- The owner's real v110 screenshot confirms all three rank/points compartments and labels render correctly and the graphical progress fill is absent. The owner requests only a **5% reduction of the entire three-compartment asset** and accurate horizontal centering.
- Keep the same original `rank_panel_owner_v108` texture; change displayed frame **690×65 → 655.5×61.75** (95% in each dimension), x **+8→0** relative to the window center. Shift top **-442→-443.625** so its vertical center remains unchanged.
- Reposition live labels to the scaled, truly symmetric compartment centers: current rank x **-246.05**, next rank x **+246.05**, and current/threshold PR x **0**. Names use width 125.4 and top -463; points width 285 and top -464.125. Font sizes unchanged to preserve text legibility.
- Progress fill remains entirely absent. No change to the real rank API, value formatting, 21 preserved source fill textures, other metrics, banners, cards, or overall window layout.
- `/ws version` now **111**. CI rebuilds the clean installable `dist/WarScore.zip`. The resized result still requires real WoW screenshot QA from the owner.


## Iteration #111 screenshot → #112: optical centering of two rank captions (2026-11-19)

- Owner confirms v111 unified rank module geometry and size are acceptable, but current/next rank text is slightly off-center inside its respective gold-bordered compartment. **Change only the live text position**, leaving the gold panel, its scale, and all other UI intact.
- In `addon/WarScore/UI/General.lua`, move `fields.rankFrom` x **-246.05 → -238** and `fields.rankTo` x **+246.05 → +238**, both inward by 8.05 UI units. Keep widths 125.4, y=-463, font 13, colors, dynamic localization and point label exactly as in v111.
- The 655.5×61.75 single-piece `rank_panel_owner_v108` stays at x=0, top=-443.625. Progress fill remains hidden; 21 pre-existing fill assets remain available for potential future work. No change to PvP data acquisition or other UI modules.
- Set `UI_ITERATION = "112"` for `/ws version`. GitHub Actions should rebuild and validate the clean installable `dist/WarScore.zip`. Native WoW screenshot QA remains pending to confirm optical centering.


## Iteration #112 screenshot → #113: PvP rank triptych 10% narrower (2026-11-19)

- Owner accepts v112 three-compartment rank module and live text positions, but requests that the whole module be about **10% less wide**, preserving its horizontal center and without changing other modules.
- In `addon/WarScore/UI/General.lua`, change display width of the existing single-piece `rank_panel_owner_v108` **655.5 → 589.95** (10% less); **height remains 61.75**, top remains -443.625 and X remains exactly 0. This is an intentional horizontal-only compression; no new texture was generated.
- Keep labels positioned within their own resized chambers: current and next x **±238 → ±214.2**, widths **125.4 → 112.86**, same vertical coordinates and font sizes. The current/threshold Rank Points label remains x=0, with width **285 → 256.5**. Maintain live rank strings and points formatting.
- Graphical progress remains hidden, and all original 0..100% fill textures remain available for future iterations. No changes to data acquisition, character/rank plaque, banners, honor kills, deaths, HK/D, lower cards, or outer frame.
- Set `/ws version` = **113**. CI must generate and validate the updated clean installable `dist/WarScore.zip` before delivering. Owner in-game screenshot QA still pending.


## Iteration #113 screenshot → #114: 5% extra width reduction and title within header (2026-11-19)

- Owner's real v113 in-client screenshot validates the narrower unified rank/PR module and requests one more modest 5% width reduction, along with ensuring the dynamic brand `WarScore` text sits inside the painted steel header rather than touching/overlapping its upper rail.
- In `addon/WarScore/UI/General.lua`, preserve original unified owner TGA, rank panel height 61.75 and central x=0. Reduce only its width **589.95 → 560.4525** (5% less); keep top=-443.625. The current and next title offsets scale symmetrically from ±214.2 to **±203.49**; their text widths from 112.86 to **107.217**. Center PR x=0, width from 256.5 to **243.675**. All label vertical positions, fonts and real data remain unchanged.
- Header title: adjust only `brandTitle` from font **33→31**, y **-27→-36**, caption box height **43→40**; keep x=0 and dynamic text. This moves painted glyphs inward/down from the upper metal rail without changing the supplied header asset.
- Rank progress fill remains hidden; retain 21 original 5%-interval fill assets, real PR/threshold string and localized titles. Other UI sections, portrait, flags, counters, cards and faction/point API unaffected.
- Update `UI_ITERATION` to **114**. Build/verify clean `dist/WarScore.zip` using GitHub Actions before delivery; screenshot QA still requires owner test inside WoW.


## Iteration #114 → #115: three new owner-authored ornaments above/below approved rank module (2026-11-19)

- The owner approves the entire v114 unified PvP-rank triptych and requests explicitly that **its frame, dimensions, dynamic rank captions and PR text must not be modified again**. Three separate uploaded PNGs are authoritative: `WarScore_Etiqueta_Actual(1).png`, `WarScore_Etiqueta_Siguiente(1).png`, and `WarScore_Divisor_Avance(1).png`.
- Source transport PNGs are stored under `docs/assets/rank_label_current_owner_v115_source.png`, `rank_label_next_owner_v115_source.png` (512×64), and `rank_divider_advance_owner_v115_source.png` (1024×64). Originals were preserved visually, converted to transparent power-of-two canvases for compatibility, and `tools/prepare_rank_bar.py` converts them to independent alpha-preserving TGA textures under `Media/General/` without repainting or merging with the existing frame.
- `UI/General.lua` version **115** introduces only three ARTWORK textures: current title at x=-203.49/top=-404, next title at x=+203.49/top=-404 (each 155×28), and decorative advancement separator at x=0/top=-500 (560.4525×25). All coordinates are relative to the original main window. Decorative elements do not change PvP calculations or the temporarily hidden graphical progress fill.
- **No changes** to the gold owner triptych at 560.4525×61.75/top=-443.625, rank name/PR bindings, player plaque, HK, ratio, lower cards, tabs, panel backdrop or banner art.
- CI workflow now stages the three new TGA outputs before committing `dist/WarScore.zip`. CI must validate ZIP contents and `/ws version=115`, with no documentation or tools in the clean installable archive.
- **Pending in-game QA**: verify the line-and-title artwork centers above the left/right plates, the advancement motif sits between the rank panel and HK divider without overlap, original ranks and points remain readable, no stretched/broken alpha and no Lua errors. Fine-tune only these three new elements from the owner's screenshot.


## Iteration #115 screenshot → #116: correct invisible rank ornaments without touching approved rank triptych (2026-11-19)

- The owner's real v115 screenshot shows none of the three added original ornamental PNGs (current title, next title, advance-chevron divider). Original TGA files are actually present in the GitHub addon media tree and have valid BGRA pixels with nonzero/opaque alpha; this rules out missing, fully transparent source art. **The precise WoW rendering cause is not independently confirmed**.
- v116 addresses draw/layer visibility by rendering each ornament in its own `CreateFrame("Frame", nil, window)`, frame level `window:GetFrameLevel()+8`, texture on `"OVERLAY"`, explicitly visible with white vertex color and alpha 1. Ornament frame mouse interaction is disabled. Texture paths are static Lua string literals so the existing clean ZIP packager includes their TGAs.
- Current/next `Actual` and `Siguiente` labels: x=±203.49, top=-400, display 175×32. Bottom ornamental chevron: x=0, top=-498, display 560.4525×30. They are **decorative only**, preserving the live dynamic rank captions and current/threshold PR text exactly.
- The owner-approved rank module, its TGA, width 560.4525, height 61.75, top -443.625, the dynamic rank names, PR text, header and all other modules remain unchanged. Graphical progress fill remains hidden.
- GitHub Actions ZIP validation now also checks all three expected TGAs exist inside `dist/WarScore.zip`, have their exact power-of-two dimensions and contain visible alpha pixels. `/ws version` increments **115→116**.
- The next in-game screenshot must confirm that the three ornaments appear, are positioned above/below the rank boxes, do not overlap the HK rail or portrait plaque, and that no UI modules moved. If still absent, use in-game texture-loading inspection before further cosmetic adjustments.


## Iteration #116 screenshot → #117: align three visible ornaments closer to PvP rank boxes (2026-11-19)

- Owner's v116 screenshot confirms all three original TGA ornaments render successfully in raised independent UI frames. The two title ornaments are too far above `Sin rango` and `Explorador`, and the horizontal advance-divider is too far below the center `25 / 750 PR` chamber.
- **Only three Y positions change** in `addon/WarScore/UI/General.lua`: `rank_label_current_owner_v115` and `rank_label_next_owner_v115` move from top=-400 to **top=-432**, preserving X ±203.49, size 175×32, original artworks and raised rendering layers. The `rank_divider_advance_owner_v115` moves from top=-498 to **top=-488**, preserving X=0 and size 560.4525×30.
- The entire approved single-piece main triptych `rank_panel_owner_v108`, live localized rank captions, `points / threshold PR`, hidden progress fill, header, HK and other UI modules are unchanged. No new art or files.
- UI diagnostic increments `/ws version` **116→117**. GitHub Actions rebuilds and verifies clean `dist/WarScore.zip`. Native-client QA still needed for precise clearance to panel gold borders and HK section.


## Iteration #117 screenshot → #118: true horizontal centering of Actual/Siguiente ornament art (2026-11-19)

- The owner's screenshot of the working v117 UI confirms both title ornaments now render at the correct vertical level directly above the left/right rank compartments, but their optical horizontal centers remain too far toward the inner red gem separators. Preserve the approved single-piece rank frame, live current/next text, PR counter and bottom decorative advance-chevron.
- Align the standalone original owner PNG titles against the **actual left/right gold compartment centerlines**, not the inner live-caption offsets. Set `rank_label_current_owner_v115` x **-203.49 → -220** and `rank_label_next_owner_v115` x **+203.49 → +220**. Both stay at y=-432, size 175×32, with unchanged texture, alpha and raised frame level, ensuring equal vertical alignment and consistent clearance to the gold frame.
- No modifications to the gold rank panel (560.4525×61.75), title strings inside it, PR, lower arrow, HK, PvP stats, header, banners or other UI. Only two X offsets and the diagnostic `UI_ITERATION 117→118` change.
- GitHub Actions must produce and validate a new clean installable `dist/WarScore.zip`; in-game screenshot QA is still required.


## Iteration #118 screenshot → #119: single shared axis for side ornaments and live rank labels (2026-11-19)

- The owner's v118 in-game screenshot shows the `Actual`/`Siguiente` ornaments and the dynamic text `Sin rango`/`Explorador` still slightly misaligned relative to their respective rank boxes. Review of the existing authored one-piece frame shows side compartments centered symmetrically approximately ±213 UI units from the main frame's center; the old live captions were at ±203.49 while the ornamental headings were at ±220.
- `addon/WarScore/UI/General.lua` v119 now defines a **single `local sideRankCenter = 213`** and uses -sideRankCenter/+sideRankCenter for both the live labels (`rankFrom`, `rankTo`) and the ornament frames (`rank_label_current_owner_v115`, `rank_label_next_owner_v115`). This corrects horizontal misalignment at the source and makes later edits consistent.
- Retain existing vertical placement: rank names top=-463 and title ornaments top=-432, both aligned across sides. Retain the exact 175×32 and 107.217×25 sizes and typefaces. Titles are still immediately above their chambers, not inside the PR counter.
- **Do not touch** the unified owner rank panel dimensions/position, red-gem separators, center numeric PR, advance-chevron below, portrait, HK, bottom stats, header, banner art, or underlying PvP API/storage. All existing original assets are preserved; progress fill remains disabled.
- `/ws version` increments to 119 and GitHub Actions produces a clean installable `dist/WarScore.zip`. In-game visual QA pending to validate optical centering.


## Iteration #119 → #120: owner-provided ornamental Honor & HK card (2026-11-19)

- The owner explicitly closes the complete PvP-rank module in v119. **Do not alter** its background, side rank names, ornamental `Actual`/`Siguiente`, current/threshold PR text, advance-chevron, nor their positions/assets. New work is confined to the old `Muertes con honor` strip beneath it.
- Source reference: an illustrative mockup with a large gold main Honor value and lower lifetime `MUERTES CON HONOR (HK)` count. The owner supplies an **empty gold/beveled frame with real red gems**: `Marco ornamental dorado con gemas rojas(1).png` (2048×682 transparent). A transparent, proportion-preserving 512×128 transport derived exclusively from this artwork is stored at `docs/assets/honor_frame_owner_v120_source.png`; no texts or amounts are baked into the artwork. `tools/prepare_honor_panel.py` converts it to `Media/General/honor_frame_owner_v120.tga`.
- In `UI/General.lua`, replace the old v68 HK ornament and huge central HK counter with this single 600×128 HONOR/HK art at x=0/top=-508. Render three live text areas: `HONOR` heading (23pt y=-519), current/max Honor currency (37pt x=0 y=-547), and lower `MUERTES CON HONOR (HK)` (17pt x=-83 y=-597) alongside live `fields.hk` (32pt x=+197 y=-592). Preserve ratio section below at -633 and the advance-chevron above without modifying their geometry.
- Honor values use existing domain data `ns.Stats.ReadHistorical().honorCurrent/.honorMaximum` (Honor currency 1792) and `formatHonorNumber` for thousands separators, with honest `—` fallback. **The mockup's `252 / 25.000` is only an example; do not hardcode or substitute rank points.** Lifetime honorable kills remain sourced exclusively from `data.honorableKills` (GetStatistic 588/fallback) and formatted as before.
- No changes to Core/Stats, rank calculations or other cards. Version diagnostic increments `/ws version` **119→120**. CI requires the honor TGA in the clean addon ZIP and checks image dimensions and visible alpha before committing `dist/WarScore.zip`.
- Native-client QA still pending: actual Honor availability, ratio section clearance, panel size, text positions inside top/lower compartments, and preservation of the finalized rank module.


## Iteration #120 screenshot → #121: Honor/HK typography refinement (2026-11-19)

- Owner's v120 in-game screenshot approves the new original ornamental Honor panel and its geometry. Request: make the dynamic Honor balance a barely perceptible 2% smaller, reduce the size of the HK count, match its color to the "MUERTES CON HONOR (HK)" caption, and keep both visually centered.
- In `addon/WarScore/UI/General.lua` only: Honor currency amount font **37 → 36.25** (~2% smaller), with its existing x=0/y=-547, width 460 and height 42 unchanged.
- HK count font **32 → 28** and color **GOLD → CREAM**, matching the caption. Keep horizontal positioning x=197 within the right side of the Honor panel; change count label top **-592 → -594** and height **40 → 36** to retain the vertical centerline at -612. Update count shadow to match caption.
- No changes to the approved ornamental `honor_frame_owner_v120`, its title, HK caption, the currency/statistic read paths, or any of the finalized rank UI, lower metric panels and other assets. `UI_ITERATION` increments to **121**.
- Verify GitHub Actions rebuilds a fresh installable `dist/WarScore.zip` containing the matching v121 `UI/General.lua`, then request user screenshot for visual approval.
