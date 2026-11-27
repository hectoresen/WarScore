## Context

The two ornamental bands contain independent textures for stat icons and separate text for their localized captions and values.

## Decisions

Only build an icon texture when the card definition supplies one. Retain the original position and size of the favorite battleground icon, as well as the existing frames, captions, values, refresh path and Simple renderer. Center each numeric value horizontally and place it below its caption. Align the bottom of single-line and wrapped captions within each row.
