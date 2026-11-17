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
