## ADDED Requirements

### Requirement: Show a first-run welcome once per installation

WarScore SHALL show a single welcome screen on the first opening of a new installation and let the player set language, visual style, faction appearance, and scale.

#### Scenario: Finish setup
- **WHEN** a new player chooses Save and open
- **THEN** WarScore opens General, preserves the current preferences, and skips the welcome on later openings and reloads.

#### Scenario: Defer or close without finishing
- **WHEN** a new player chooses Not now or closes the window with X or Escape
- **THEN** WarScore shows the welcome on the next opening, including after reload.

#### Scenario: Upgrade an existing installation
- **WHEN** WarScore already has saved data without a completion marker
- **THEN** it preserves the preferences and opens its requested view normally.

#### Scenario: Change the welcome language
- **WHEN** the player changes the language during setup
- **THEN** the welcome and preferences are translated immediately.
