# WarScore — agent contract

Applies to all coding agents. **Read first:** README.md, docs/PVP_STATISTICS.md, docs/GENERAL_VIEW.md, docs/GENERAL_VISUAL_SPEC.md, openspec/README.md, and the relevant approved change. Inspect current source; documentation is not proof that a feature exists.

## Scope and boundaries
- Offline native Lua addon for World of Warcraft Forever, TOC Interface 16001. Never assume retail APIs work without in-client evidence.
- Current layout: Core/ (lifecycle, API adapters, normalization, SavedVariables), UI/ (native game frames). Keep calculations deterministic and testable independently from WoW globals. Introduce extra directories only with a justified design.
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
`openspec/changes/feat001-general-pvp-dashboard/` is a **draft awaiting approval**. Its implementation is blocked until the owner explicitly approves. See `openspec/README.md` and `skills/documentation-sync/SKILL.md`.
