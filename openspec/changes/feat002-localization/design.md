# Technical design — UI localization foundation

**Status: APPROVED by owner (2026-11-19); implementation in progress, pending client QA.**

## Module boundary

Add `Core/Localization.lua` before `UI/General.lua` in `WarScore.toc`. Expose a small namespace API:

```lua
ns.L = ns.L or {}
ns.L:SetLanguage("en")
ns.L:GetLanguage()
ns.L:Get("key", ...)
```

The catalog should contain `es` and `en` tables. Spanish is the fallback language and the initial persisted value.

## Persistence

Store only the language code in the existing SavedVariables structure, for example:

```lua
WarScoreDB.settings = WarScoreDB.settings or {}
WarScoreDB.settings.language = "es"
```

Do not break existing character data or replace the current database shape.

## Runtime refresh

`UI/General.lua` should request copies through `ns.L:Get(...)`. The localization module can notify a registered refresh callback when the language changes; the UI should refresh text only, not rebuild the window or alter geometry.

## Temporary command

Extend the existing `/ws` slash handler with:

```text
/ws lang es
/ws lang en
/ws lang
```

The command is temporary developer functionality and must not create a visible settings control. Invalid language codes should print the supported values and leave the current language unchanged.

## Catalog coverage

At minimum, migrate the visible strings currently in `UI/General.lua`: product title where applicable, `General`, `Hoy`, the coming-soon tooltip/message, settings tooltip, `Rango PvP`, rank fallback, `HONOR`, `MUERTES CON HONOR`, `MUERTES PvP SUFRIDAS`, `HK/D`, `DUELOS GANADOS`, `CAMPOS DE BATALLA JUGADOS`, `BG GANADOS`, `WIN RATE BG`, `WIN RATE DUELOS`, `CAMPO DE BATALLA FAVORITO`, `vez jugado`, `veces jugado`, unavailable markers and any other user-visible copy discovered during implementation.

Dynamic battleground names and rank titles supplied by WoW should remain dynamic. If a copy is intentionally native/client-provided, document that exception instead of duplicating it in the catalog.
