## ADDED Requirements

### Requirement: Select faction appearance

WarScore SHALL offer Horde and Alliance appearance options in Settings, save the selection, and apply it without reloading.

#### Scenario: Change appearance
- **WHEN** the player chooses Alliance or Horde in Settings
- **THEN** both styles display the corresponding banners, Classic Forever displays the corresponding rank plaque, and the selection survives reload.
- **AND** rank names and PvP statistics still use the actual character data.

#### Scenario: Open with no valid override
- **WHEN** no valid saved selection exists
- **THEN** Alliance characters see Alliance artwork and other characters see Horde artwork.
