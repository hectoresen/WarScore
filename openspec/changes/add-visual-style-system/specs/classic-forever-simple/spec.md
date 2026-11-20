# Classic Forever Simple — General layout requirements

**Status: PROPOSED / NOT APPROVED**

## ADDED Requirements

## Requirement: Fidelity to the approved target

Classic Forever Simple SHALL reproduce the General layout shown in the owner-provided screenshot dated 2026-11-20 ("WarScore Forever SIMPLE.png") using the subsequently supplied original PNG assets. The screenshot is the definitive target, not permission to make an alternative design.

### Scenario: Reference-based visual QA
- **GIVEN** the owner has provided required source artwork
- **WHEN** the Simple renderer is tested at 100% UI scale in WoW Forever
- **THEN** its composition, spacing, ornament placement, text alignment, separators, visual hierarchy and colors match the supplied screenshot, subject only to explicitly acknowledged client constraints and owner-approved corrections.

### Scenario: Missing assets
- **GIVEN** an asset required for the screenshot design has not been provided
- **WHEN** implementation is prepared
- **THEN** the implementer requests the necessary original image and does not invent, redraw, substitute or reuse a complete screenshot as runtime art.

## Requirement: Simple General presentation

The Simple style SHALL present the same metrics as Classic Forever, but in a distinct composition: centered circular portrait and character name/class/level, compact ornamental PvP rank display, prominent honorable kills, row-based captions and right-aligned values, subtle horizontal separators, and favorite battleground with match count.

### Scenario: Main stat composition
- **WHEN** the player opens General in Simple
- **THEN** lifetime honorable kills remain visually prominent; Honor, HK/D, PvP deaths, duel wins, battlegrounds played/won, both win rates and favorite battleground are readable in the screenshot's row-based layout.
- **AND** already available rank data and applicable progression details are preserved rather than silently discarded.

### Scenario: Variable character and BG content
- **WHEN** the name, class, rank or favorite BG is long or localized
- **THEN** dynamic text remains readable and does not overlap ornaments; any needed truncation provides a way to recover the complete value when available.

## Requirement: Identical data lifecycle

The Simple renderer SHALL receive the same updated current-character snapshot as Classic Forever, without its own statistical model or cache.

### Scenario: Changing source values
- **WHEN** the game's stats differ from the last General opening
- **THEN** opening Simple shows the refreshed native values, without reusing stale statistics from Classic Forever.

## Requirement: Shared interface unaffected

Classic Forever Simple SHALL not change the external frame, Horde flags, close X, settings gear, Settings screen, shared tabs or the existing scale/language control behavior.

### Scenario: Return from Settings
- **WHEN** the player is using Classic Forever Simple and returns from Settings
- **THEN** the same Simple General layout is shown, while the shared outer shell remains unchanged.
