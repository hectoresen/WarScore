## ADDED Requirements

### Requirement: Classic Forever lower-row icon visibility

Classic Forever General SHALL omit only the decorative icons for duel wins, battlegrounds played, battleground wins, battleground win rate and duel win rate. It SHALL preserve both stat bands, all captions and values, and the favorite battleground icon.

#### Scenario: Open Classic Forever General
- **WHEN** General is shown in Classic Forever
- **THEN** all six cards appear in their existing positions, the five numeric values are centered in their cells, and only the favorite battleground has an icon.

#### Scenario: Switch to Classic Forever Simple
- **WHEN** the player switches to Classic Forever Simple and opens General
- **THEN** its composition and metrics are displayed as before.
