# Tasks — feat002-localization

**Status: APPROVED; implementation in progress, pending client QA.**

- [x] Inventory every player-facing string in `UI/General.lua` and classify dynamic/native text.
- [x] Add `Core/Localization.lua` with Spanish and English catalogs.
- [x] Add the localization file to `WarScore.toc` before `UI/General.lua`.
- [x] Persist the language code compatibly in `WarScoreDB`.
- [x] Replace hardcoded General-view copies with localization keys.
- [x] Add temporary `/ws lang`, `/ws lang es` and `/ws lang en` commands.
- [x] Refresh an open General view after switching language.
- [x] Add missing-key fallback and invalid command handling.
- [x] Run static checks and inspect the diff for remaining visible hardcoded Spanish strings.
- [ ] Owner tests `/reload`, `/ws`, `/ws lang en`, `/ws lang es` and sends a screenshot or error output.
- [x] Update `docs/DEVELOPMENT_HANDOFF.md` with implementation commit `d6883cc`; client QA remains pending.
