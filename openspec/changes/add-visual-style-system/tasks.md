# Implementation tasks and acceptance ledger

**Status: SPECIFICATION ONLY — NOT APPROVED FOR IMPLEMENTATION**

## Proposal / approval

- [x] Review owner answers: instant switch, same data, screenshot as definitive target.
- [x] Inspect current General, Settings, stats, SavedVariables, localization, docs and existing OpenSpec structure on main.
- [x] Draft proposal, design, and delta specs for style management and Simple layout.
- [ ] Run the official OpenSpec CLI and validate this change strictly (CLI unavailable in current environment; NOT RUN).
- [ ] Obtain explicit owner approval of this proposed specification.
- [ ] Collect the individual original PNG assets from the owner and inventory each image, resolution, alpha and intended region.
- [ ] Confirm any screenshot/current UI differences affecting shared navigation or rank-progress text before implementing; no unapproved behavior changes.

## Implementation — do not start until approval and assets

- [ ] Extract shared shell and General rendering boundary, preserving existing Classic Forever visual appearance.
- [ ] Introduce stable style IDs and registry; update TOC load order appropriately.
- [ ] Implement style selection, default/fallback, SavedVariables persistence, immediate switching and cleanup.
- [ ] Implement independent Classic Forever Simple General renderer using owner-provided art and existing data snapshot.
- [ ] Preserve native statistics, missing-value rules and refresh behavior across styles.
- [ ] Localize style names; retain current UI scaling and existing Settings layout.
- [ ] Validate media/texture references, alpha, packaging, Lua 5.1 and compatibility fallbacks.
- [ ] Add/update regression tests for style registry, persistence, switching, refresh and legacy layout.

## Validation

- [ ] Lua syntax/compatibility — NOT RUN.
- [ ] Repository and packaging tests — NOT RUN.
- [ ] OpenSpec CLI strict validation — NOT RUN.
- [ ] Confirm unchanged Classic Forever with in-game screenshots at supported scales — NOT RUN.
- [ ] Confirm Simple visual fidelity against supplied screenshot and assets — NOT RUN.
- [ ] Verify real-client switching without reload, ES/EN, 75/100/125%, restart persistence, interactions and statistics — NOT RUN.
- [ ] Owner final acceptance — PENDING.
- [ ] Documentation sync after accepted implementation — PENDING.
- [ ] Archive via official OpenSpec CLI after acceptance — PENDING.

## Delivery constraints

All implementation iterations must remain on the same `feat/visual-style-system` branch. Deliver installable source at `addon/WarScore/`, without ZIP; never push to main, open a PR, merge, or publish a release without explicit owner instruction.
