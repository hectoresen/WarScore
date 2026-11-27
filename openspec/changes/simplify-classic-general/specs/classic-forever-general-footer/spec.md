## ADDED Requirements

### Requirement: Classic Forever lower-row icon visibility

Classic Forever General SHALL omit only the decorative icons for duel wins, battlegrounds played, battleground win rate and duel win rate. It SHALL preserve both stat bands, all captions and values, and the battleground wins and favorite battleground icons.

#### Scenario: Open Classic Forever General
- **WHEN** General is shown in Classic Forever
- **THEN** all six cards appear in their existing positions and the four selected icons are absent.

#### Scenario: Switch to Classic Forever Simple
- **WHEN** the player switches to Classic Forever Simple and opens General
- **THEN** its composition and metrics are displayed as before.
