# General PvP dashboard — delta specification

**Status: PROPOSED / NOT APPROVED**

## Requirement: Native window and navigation
WarScore SHALL provide a movable native-WoW window with the chosen Warcraft-style General view, working close button, and General and Hoy tabs.

### Scenario: Open General
- **WHEN** the player opens WarScore
- **THEN** General is shown with a centered portrait, header, rank plate, main statistics and two ornamental rows of secondary statistics.

### Scenario: Hoy is not implemented
- **WHEN** the player selects Hoy during this increment
- **THEN** the UI SHALL NOT display invented daily statistics and SHALL clearly indicate the tab is not yet available.

## Requirement: Historical PvP data integrity
WarScore SHALL read current-character historical PvP metrics from verified client APIs and distinguish unknown from zero.

### Scenario: Confirmed counters
- **WHEN** `GetStatistic(588)` returns 32 and `GetStatistic(1501)` returns 8
- **THEN** General SHALL display 32 HK, 8 PvP deaths and HK/D 4.00.

### Scenario: Invalid denominator
- **WHEN** PvP deaths is 0 or unknown
- **THEN** HK/D SHALL display `—`, never infinity or a fabricated number.

### Scenario: Unverified KB and rank
- **WHEN** a PvP-only killing-blow counter or rank source has not been validated
- **THEN** KB/D and rank SHALL display honest unavailable states, not mockup values or guessed titles.

## Requirement: Dueling and battleground metrics
WarScore SHALL show duels won, BG played, BG won, BG win rate, duel win rate, favorite BG and its played count using the IDs and formulas in `docs/PVP_STATISTICS.md`.

### Scenario: No duels or battlegrounds
- **WHEN** duel IDs 319/320 return `--` on a character confirmed to have never dueled, and BG counters are unavailable on a character without BG matches
- **THEN** duels won MAY display 0 per documented normalization, while win rates and favorite BG SHALL display `—` until a valid denominator/inputs exist.

### Scenario: Favorite battleground
- **WHEN** BG played counters have a unique positive maximum
- **THEN** the BG name and its exact played count SHALL appear.
- **WHEN** two or more BG counters share the positive maximum
- **THEN** the UI SHALL explicitly indicate a tie rather than choosing arbitrarily.

### Scenario: Unknown statistics
- **WHEN** an API returns `--` for a counter without verified zero semantics
- **THEN** WarScore SHALL treat the value as unknown and SHALL NOT silently coerce it to zero.

## Requirement: High-fidelity native UI
WarScore SHALL preserve the hierarchy, decorative geometry and two-row card layout specified in `docs/GENERAL_VISUAL_SPEC.md`, subject to documented game-client limitations.

### Scenario: Visual comparison
- **WHEN** the addon is rendered at the reference UI scale
- **THEN** the implementation SHALL be compared to the reference for border proportions, tab positions, portrait, banners, rank plate, HK, ratios, deaths, cards, icons and typography, and deviations SHALL be recorded.

### Scenario: Unsupported visual technique
- **WHEN** a texture format, portrait mask or font cannot be used in Forever
- **THEN** the implementer SHALL document evidence and request a fidelity-preserving alternative, not silently simplify the UI.

## Requirement: Safe operation
WarScore SHALL remain offline, preserve diagnostics and not claim unexecuted game tests.

### Scenario: No network or synthetic data
- **WHEN** the General view opens
- **THEN** it SHALL use only native APIs/local SavedVariables, with no remote calls or sample statistics presented as real.
