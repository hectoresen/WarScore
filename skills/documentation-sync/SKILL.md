---
name: documentation-sync
description: Audit WarScore code, approved specs, documentation, and game-test evidence before declaring an implementation ready for review.
---

# WarScore documentation sync

Adapted from CraftAtlas; lightweight, no PR/CI automation requirement.

1. Read AGENTS.md, README.md, the approved OpenSpec change, docs/PVP_STATISTICS.md, docs/GENERAL_VIEW.md, docs/GENERAL_VISUAL_SPEC.md, and affected Lua files.
2. Compare each approved SHALL scenario to actual code. Separate **implemented**, **offline tested**, **tested in Forever by a person**, **not tested**.
3. Update README to describe only implemented features and commands. Keep API IDs, data normalization and evidence in docs/PVP_STATISTICS.md; visual changes in docs/GENERAL_VISUAL_SPEC.md.
4. Review risks: client API, texture format/license, portrait mask, PvP rank, KB/D semantics, localization, missing data and character switching.
5. Update tasks.md with evidence. Do not mark a manual game test as done from a screenshot mockup or static inspection.
6. Report modified files, checks PASS/FAIL/NOT RUN, screenshot comparison status and unresolved decisions. Archive only after acceptance; never silently alter approved scope.

No required GitHub rulesets, PR metadata, auto-merge, CI or two-PR gate in WarScore.
