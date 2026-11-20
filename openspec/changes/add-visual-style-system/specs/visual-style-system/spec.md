# Visual style management — requirements

**Status: PROPOSED / NOT APPROVED**

## ADDED Requirements

## Requirement: Stable registry of visual styles

WarScore SHALL register each supported visual style with a stable internal identifier distinct from its displayed/translated name. The registry SHALL include `classic-forever` (default) and `classic-forever-simple`.

### Scenario: Display label is renamed
- **GIVEN** a player has saved `classic-forever-simple`
- **WHEN** the displayed name is changed or localized in a later version
- **THEN** the selected renderer remains the same and the saved stable ID is unchanged.

### Scenario: Unknown saved style
- **GIVEN** `WarScoreDB.settings.visualStyle` is missing or is an unregistered ID
- **WHEN** WarScore initializes the General UI
- **THEN** it falls back safely to `classic-forever` without resetting other preferences or statistics.

## Requirement: Functional Settings style selector

The Settings visual-style dropdown SHALL list available implemented styles, allow selection, indicate the active style, and use the existing Settings appearance.

### Scenario: Select Simple without reload
- **GIVEN** the player has the Settings screen open with Classic Forever selected
- **WHEN** the player selects Classic Forever Simple
- **THEN** WarScore applies the new General renderer immediately, updates the dropdown selection and stores `classic-forever-simple` under `WarScoreDB.settings.visualStyle`
- **AND** does not require `/reload`.

### Scenario: Return to Classic Forever
- **GIVEN** Simple is selected
- **WHEN** the player selects Classic Forever
- **THEN** the original approved General view is restored with its original ornamental layout.

### Scenario: Reload and reopen
- **GIVEN** a supported style is stored
- **WHEN** the player closes/reopens WarScore or reloads the interface
- **THEN** the selection and active presentation remain consistent.

## Requirement: Shared window and Settings chrome

Both styles SHALL use the same outer window, flags, header, tabs, Settings page, scale controls, gear, X, navigation behavior and minimap access. Styles SHALL vary the General content only.

### Scenario: Switch styles repeatedly
- **WHEN** the player switches style multiple times
- **THEN** only one General renderer is visible/interactive, the shared chrome is not duplicated, and no extra event or refresh handlers accumulate.

### Scenario: Escape, close, and navigation
- **WHEN** the player presses Escape or X in either style, opens Settings via gear or `/ws settings`, navigates Back or toggles the minimap button
- **THEN** these controls behave as in current Classic Forever.

## Requirement: Compatibility with scale and language

Style selection SHALL be independent of language and UI size. The shared UI scale baseline remains `0.7179` for 100%, with existing 75% and 125% options.

### Scenario: Scale and language change
- **GIVEN** either style is active
- **WHEN** the player changes scale or language
- **THEN** the chosen style persists, all visible labels refresh, and the interface retains proportional geometry without an extra reload.

## Requirement: No changes to data semantics

Styles SHALL consume the same current-character statistic sources, data normalization and derived calculations and SHALL refresh on opening General and after switching styles.

### Scenario: Equivalent metrics
- **GIVEN** an identical live character/stats snapshot
- **WHEN** either style renders General
- **THEN** numeric values, missing-data behavior, character identity and PvP rank information are equivalent; only layout and visual assets differ.

### Scenario: Unknown values
- **GIVEN** the game returns unavailable statistics
- **WHEN** either style is displayed
- **THEN** the renderer uses the existing unknown/zero semantics and does not fabricate values.

## Requirement: Preservation of legacy style

Classic Forever SHALL be preserved as the default, with no intentional change to its approved artwork, layout or rendering values.

### Scenario: Existing installation
- **GIVEN** an existing user without a visual-style setting
- **WHEN** the updated addon is launched
- **THEN** the user's existing Classic Forever presentation is visually unchanged, and all existing SavedVariables are preserved.
