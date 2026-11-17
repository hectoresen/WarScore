# feat001 — General PvP dashboard

**Status: DRAFT — OWNER APPROVAL REQUIRED. No implementation authorized yet.**

## Why
WarScore currently has a Lua scaffold and diagnostics but no functioning General view. Real Forever 1.60.1 tests have confirmed lifetime HK and PvP deaths and identified duel/BG statistic IDs. A chosen ornate Warcraft-style reference and measured reconstruction guide exist. The next increment is a working General tab that reads real character data and resembles that reference.

## Scope
- Native, movable WarScore window with header, close control, General tab and visible adjacent Hoy tab (Hoy content remains out of scope).
- Current-character portrait, identity, class/level; PvP rank plate with honest unavailable state until rank source is verified.
- Lifetime HK, HK/D, PvP deaths, reserved KB/D location with unavailable state; tooltips/microcopy.
- Secondary rows: duels won, BG played, BG won, BG win rate, duel win rate, favorite BG and its match count.
- Safe parsing of `GetStatistic`, missing values and zero denominators; native data only.
- Reusable frame/texture layout primitives and asset manifest, screenshot comparison against approved reference.
- Keep existing diagnostics operational and no network dependency.

## Out of scope
- Computing KB/D from `1487` without PvP semantics; invented rank names; historical PvP records not available through client.
- Functional Hoy metrics, daily snapshots, duel/BG history screens, combat logging, online services.
- Full multi-character selector/navigation in this increment; preserve data-layer extensibility for later spec. Do not silently display another character's live data.
- GitHub rulesets, CI, two-PR governance, releases or asset scraping without rights.

## Acceptance and risks
Acceptance is defined by `specs/general-dashboard/spec.md`. The largest risks are real-client support for portraits/masks, texture assets and visual fidelity, font differences and API semantics. Fallbacks must be documented and reviewed rather than fabricated.

**Approval request:** approve scope, exclusion of multi-character selector from v1, and implementation plan. No code/UI changes in this proposal phase.
