## Context

Classic Forever builds two three-cell bands. The Simple renderer consumes formatted values from the same General refresh.

## Goals

Keep the favorite battleground icon, translated name and match count, including the existing missing-data state.

## Decisions

Use the favorite cell of the existing lower-band artwork as a single centered card. Populate the Simple model directly with the existing count and percentage formatters during the same historical refresh. Keep all other General regions in their existing positions.

## Risks

The cropped artwork edge and spacing need visual confirmation in the game. Check both languages and style switching through Settings.
