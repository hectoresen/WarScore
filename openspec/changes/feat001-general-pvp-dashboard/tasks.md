# Tasks — feat001-general-pvp-dashboard

**Status: DRAFT / WAITING FOR OWNER APPROVAL. All tasks unchecked.**

## Approval and prerequisites
- [ ] Owner explicitly approves proposal, exclusions and acceptance criteria.
- [ ] Confirm availability of the original approved expanded PNG; commit as `docs/assets/general-approved-reference.png` if supplied.
- [ ] Inventory supported client font/texture/portrait APIs; document what is tested vs assumed.

## Data layer
- [ ] Implement guarded `GetStatistic` parsing and per-counter unknown/zero semantics in Core/Stats.lua.
- [ ] Implement HK, PvP deaths, HK/D, duel/BG counters, win rates and favorite BG/tie behavior.
- [ ] Ensure KB/D and unverified rank remain unavailable; keep current diagnostics functional.
- [ ] Add deterministic tests for numeric strings, `--`, zero denominators, percentages, favorite/ties.

## Native UI
- [ ] Create reusable theme/layout tokens and texture asset manifest with licensing/provenance.
- [ ] Build movable frame, header, close button, General tab and adjacent Hoy placeholder.
- [ ] Implement centered active-character portrait, identity, faction ornamentation and rank unavailable state.
- [ ] Build HK, HK/D, reserved KB/D, PvP deaths, help labels and separators.
- [ ] Build two lower ornamental rows with duels, BG, win rates and favorite BG.
- [ ] Handle refresh, localization-ready labels, long values and alternate UI scales.

## Verification and handoff
- [ ] Run available offline tests and document PASS/FAIL/NOT RUN.
- [ ] Run Forever client smoke test and compare displayed HK/deaths against native panel.
- [ ] Capture same-scale screenshot and compare with approved image; record differences.
- [ ] Run skills/documentation-sync/SKILL.md; update README and technical docs truthfully.
- [ ] Obtain owner acceptance before marking feature complete or archiving the change.
