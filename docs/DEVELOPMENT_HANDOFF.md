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
