# Visual style system and Classic Forever Simple

**Status:** PROPOSED — awaiting explicit owner approval and source PNG assets. No runtime implementation is authorized by this document.

## Why

WarScore currently has one hard-coded General layout and a disabled, fixed "Classic Forever" visual style selector. The owner wants an extensible visual-style system and a second layout, **Classic Forever Simple**, following the owner-supplied screenshot (2026-11-20, "WarScore Forever SIMPLE.png") as the definitive visual reference.

## What changes

- Add a registry of visual styles identified by stable internal IDs, independent of translated or future renamed display names.
- Keep the current General design as the default **Classic Forever**, rendered unchanged.
- Make the Settings **Visual style** dropdown functional, selectable and persisted.
- Add **Classic Forever Simple** as a separate General presentation of the *same* stats and derived data, using the owner-supplied PNGs and the definitive screenshot.
- Change styles immediately, without UI reload; preserve the user's language and 75/100/125% interface scale.
- Share the existing outer window, header, flags, close button, settings gear, tab navigation and Settings screen between both styles.

## In scope

Architecture of visual style registration, stable selection, SavedVariables migration/default behavior, lifecycle and refresh, localized display labels, distinct General view construction, QA with screenshot and supplied art, documentation and regression tests.

## Out of scope

- PvP data sources, calculation logic, new statistics, altering the existing Classic Forever artwork, changes to Settings other than enabling Visual style and its entries.
- Reimplementing tab features that are currently placeholders.
- Creating/approximating graphical assets, moving approved shared chrome or changing the default window scale.
- Remote services, changes to release versioning, merging into main or releasing the addon.

## Dependencies and constraints

- **Authoritative visual reference:** owner-provided screenshot in the conversation on 2026-11-20, labelled "WarScore Forever SIMPLE.png". This image is NOT yet a committed runtime asset.
- The owner will supply required source PNG assets **after reviewing this specification**. Inventories, image dimensions and precise bindings are finalized when they arrive, before implementation.
- World of Warcraft Forever interface 16001: prefer native APIs and confirmed existing UI methods; retain compatibility fallbacks.
- The General screenshot depicts tab text "Hoy", while the current localized code labels that placeholder as "Estadísticas"/"Statistics". Navigation labels and behavior belong to the shared shell and must remain current unless the owner separately approves a change; the screenshot's central General arrangement remains the fidelity target.
- The existing data model includes rank-progression details; Simple must not silently drop an existing live metric. Resolve any screenshot-level placement or compact display approach with the owner during asset/fidelity review if necessary.
- Preserve owner control: documentation/specification only until approval; all code in the task branch; no PR, merge or changes to main unless requested.

## Acceptance

See `specs/visual-style-system/spec.md` and `specs/classic-forever-simple/spec.md`. Real-client fidelity is accepted only from owner screenshots/tests; static validation cannot substitute for an in-game test.
