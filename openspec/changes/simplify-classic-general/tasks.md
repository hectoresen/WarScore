## 1. Implementation

- [x] Render only the favorite battleground card in the Classic Forever footer.
- [x] Preserve the Simple metrics and shared native refresh.

## 2. Verification

- [x] PASS: strict OpenSpec validation for this change and repository traceability.
- [x] PASS: Lua 5.1 syntax for 9 files, 32 statistics assertions, 20 bundled texture/font references in General, repository/TOC validation and 6 release packaging tests.
- [ ] NOT RUN: WoW Forever visual QA for the card artwork, both languages, favorite with and without match data, and switching styles through Settings.
- [ ] Record owner acceptance before archival.

Repository-wide strict OpenSpec validation still reports failures in the three pre-existing changes.
