# WarScore — agent contract

Applies to all coding agents. **Read first:** README.md, docs/PVP_STATISTICS.md, docs/GENERAL_VIEW.md, docs/GENERAL_VISUAL_SPEC.md, openspec/README.md, and the relevant approved change. Inspect current source under `addon/WarScore/`; documentation is not proof that a feature exists.

## Scope and boundaries
- Offline native Lua addon for World of Warcraft Forever, TOC Interface 16001. Never assume retail APIs work without in-client evidence.
- Current installable source layout: addon/WarScore/Core/ (lifecycle, API adapters, normalization, SavedVariables), addon/WarScore/UI/ (native game frames). Keep calculations deterministic and testable independently from WoW globals. Introduce extra directories only with a justified design.
- Preserve the chosen Warcraft visual design; do not simplify ornamental assets or replace it with web-style cards. Use game-supported textures and FontStrings, not CSS. Assets need provenance and valid WoW formats.
- No fabricated character data, rank, KB/D, BG wins, client test results or API guarantees. Distinguish **identified**, **tested in client**, and **compared with native panel**.
- Code, specs and technical docs in English for new files; addon-visible labels in Spanish initially, with localization planned. Existing Spanish docs remain authoritative until deliberately reconciled.

## Lightweight spec-driven workflow
1. **Explore** code and evidence.
2. **Propose** an OpenSpec change with proposal, design, requirement scenarios and tasks; **stop for explicit owner approval**.
3. **Apply** only approved scope; do not modify approved requirements silently.
4. **Verify** automated tests and manual Forever-client acceptance independently. Mark unavailable checks NOT RUN.
5. **Sync** README, technical docs, specs and task evidence; archive only after acceptance.

No CraftAtlas GitHub rulesets, CI validators, mandatory two-PR process, branch naming policy or auto-merge imported. PRs are optional until owner decides otherwise. Do not change repo governance. A spec proposal is not authorization to implement.

## First change
`openspec/changes/feat001-general-pvp-dashboard/` records the original proposal and implementation process. General is now implemented and has been visually tested in WoW through UI iteration 83. Check pending acceptance requirements before archiving it. See `openspec/README.md` and `skills/documentation-sync/SKILL.md`.

## Context handoff

**Read `docs/DEVELOPMENT_HANDOFF.md` at the beginning of every resumed agent session.** It records the current commit, real-client QA, unresolved defects and the next exact test. Update it after every iteration and maintain honest OpenSpec task status.

## Asset sourcing and owner approval (mandatory)

- The owner supplies Warcraft-themed artwork when custom visuals are required. **Ask for the exact missing asset before creating, generating, painting, approximating, reconstructing or substituting visual artwork.** Do not invent decorative assets to fill a visual gap.
- Existing owner-provided assets may be positioned, cropped, converted to a compatible WoW texture format, alpha-composited and scaled **without redrawing their artistic content**. Explain quality or fidelity limitations when converting.
- Reuse an existing art texture for strictly corrective layout/compositing work when the requested visual treatment already exists (e.g. an interior leather backing). Do not describe this as creating new artwork.
- When requesting a missing asset, name the piece, intended location, required transparency/format, approximate dimensions and whether it needs separable layers. Do not silently substitute native WoW item icons with unrelated artwork.
- Keep art acceptance explicit: visually present in game != approved. Document each user screenshot result and keep rejected/provisional pieces open. Do not modify approved assets except for a specifically requested change.
