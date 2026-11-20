# Implementation tasks and acceptance ledger

**Status: OWNER-APPROVED (2026-11-20) — initial implementation in progress; artwork integration and in-game QA pending**

## Proposal / approval

- [x] Review owner answers: instant switch, same data, screenshot as definitive target.
- [x] Inspect current General, Settings, stats, SavedVariables, localization, docs and existing OpenSpec structure on main.
- [x] Draft proposal, design, and delta specs for style management and Simple layout.
- [ ] Run the official OpenSpec CLI and validate this change strictly (CLI unavailable in current environment; NOT RUN).
- [x] Owner approved the proposal and supplied the three source assets on 2026-11-20.
- [x] Received three transparent 2048×682 RGBA PNGs: rank plaque, diamond divider and thin divider. Converted to power-of-two TGA files in a separate asset package.
- [ ] Commit those TGA binary files into `addon/WarScore/Media/General/`; the GitHub connector cannot directly upload local image bytes, so this remains a release-blocking dependency.
- [ ] Confirm any screenshot/current UI differences affecting shared navigation or rank-progress text before implementing; no unapproved behavior changes.

## Implementation — owner approved; code started, binary artwork still pending

- [x] Preserve current Classic Forever General view and add a separate Simple renderer with shared window and Settings; client regression confirmation still pending.
- [x] Introduce stable style IDs and registry; update TOC load order appropriately.
- [x] Implement style selection, default/fallback, SavedVariables persistence and in-session switching (pending client QA).
- [x] Implement independent Simple General renderer using current formatted values; art references are wired but binary TGAs must still be committed.
- [x] Reuse current General refresh results and missing-value formatting across styles.
- [x] Localize style names; retain current UI scaling and Settings layout.
- [ ] Validate media/texture references, alpha, packaging, Lua 5.1 and compatibility fallbacks after binary assets are committed. Packaging intentionally requires the three TGAs.
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
