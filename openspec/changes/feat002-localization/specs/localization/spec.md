# Localization requirements

## Requirement: default Spanish catalog

The addon MUST start in Spanish when no language preference exists.

### Scenario: first load

- Given a new or legacy `WarScoreDB` without a language setting
- When the addon loads
- Then the active language is `es`
- And existing General-view copies remain Spanish

## Requirement: English catalog

The addon MUST provide English translations for every migrated General-view key.

### Scenario: switch to English

- Given the addon is loaded
- When the user runs `/ws lang en`
- Then the active language becomes `en`
- And the open General view displays English copies

## Requirement: restore Spanish

### Scenario: switch to Spanish

- Given English is active
- When the user runs `/ws lang es`
- Then the active language becomes `es`
- And the open General view displays Spanish copies

## Requirement: persistence

The addon MUST persist only the selected language code in the existing SavedVariables database.

### Scenario: reload

- Given the user selected English
- When the UI reloads
- Then English remains active
- And existing character/statistic data remains intact

## Requirement: safe fallback

Missing keys MUST fall back to Spanish and MUST NOT raise a Lua error.

### Scenario: missing translation

- Given a requested key has no translation in the active language
- When the UI requests the key
- Then the Spanish translation is returned when available
- And otherwise the key itself is returned
