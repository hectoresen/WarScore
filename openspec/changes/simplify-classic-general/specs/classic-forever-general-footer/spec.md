## ADDED Requirements

### Requirement: Classic Forever favorite battleground card

Classic Forever General SHALL display only the favorite battleground card in its lower metrics area. Classic Forever Simple SHALL retain its existing metrics and consume the same current native snapshot.

#### Scenario: Classic Forever with a favorite battleground
- **WHEN** General is displayed in Classic Forever and a favorite battleground is available
- **THEN** the lower metrics area displays its icon, localized heading, name and match count as a single card.

#### Scenario: Classic Forever without a favorite battleground
- **WHEN** General is displayed in Classic Forever and the favorite battleground is unavailable
- **THEN** the card displays the existing neutral dash and omits the match count.

#### Scenario: Switch to Classic Forever Simple
- **WHEN** the player switches to Classic Forever Simple and opens General
- **THEN** duel wins, battlegrounds played and won, both win rates and favorite battleground are presented as before using current data.
