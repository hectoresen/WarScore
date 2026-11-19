# feat002 — UI localization foundation

**Status: APPROVED by owner (2026-11-19); implementation in progress, pending client QA.**

## Why

WarScore's visible UI copies are currently hardcoded in Spanish. The upcoming settings interface needs a language selection, but the UI should first have a single localization layer so Spanish and English can be switched without duplicating layout code.

## Scope

- Add a localization module with Spanish as the default language and English as the first alternative.
- Move all player-facing General-view copies into a translation catalog.
- Include labels, tabs, placeholders, tooltips, empty states, statistic titles, units and temporary messages.
- Persist the selected language in `WarScoreDB` without adding settings UI yet.
- Add a temporary slash command for testing, for example `/ws lang es` and `/ws lang en`.
- Refresh the open General view after a language change.
- Keep diagnostics and internal technical comments out of the player-facing catalog unless they are intentionally localized later.

## Out of scope

- No language selector button, panel, dropdown or other visual settings control.
- No automatic locale detection unless explicitly added later.
- No translation of documentation, code comments or API diagnostic output.
- No layout redesign or statistic-source changes.

## Acceptance

- Spanish remains the default and preserves current visible wording unless a copy is deliberately normalized.
- `/ws lang en` changes the open General view to English.
- `/ws lang es` restores Spanish.
- The selected language survives `/reload` through `WarScoreDB`.
- No visible General-view string remains hardcoded outside the localization layer, except dynamic game-provided names and native API labels.
- Missing translation keys fall back to Spanish, then to the key itself, without Lua errors.
