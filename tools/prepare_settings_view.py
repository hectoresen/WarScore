"""Convert the user's original empty-tab Settings inner frame for WoW.

The provided 1199x1312 RGBA artwork is stored as an alpha-preserving,
palette-optimized 512x560 transport PNG. The complete ornamentation and both
unlettered tabs remain in the image; Lua supplies localized interactive text.

Match the existing General inner-frame display geometry (774x985), using a
power-of-two TGA texture that WoW can load without texture-coordinate tricks.
"""
from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parents[1]
source = root / "docs/assets/settings_inner_frame_owner_v122_source.png"
out = root / "addon/WarScore/Media/General/settings_inner_frame_owner_v122.tga"

with Image.open(source) as provided:
    provided.load()
    if provided.size != (512, 560):
        raise ValueError(f"Unexpected v122 Settings frame size: {provided.size}")
    artwork = provided.convert("RGBA")
    if not artwork.getchannel("A").getbbox():
        raise ValueError("Owner Settings artwork has no visible pixels")
    # The established General panel displays the original 1199x1312 canvas
    # as 774x985; pre-stretch to square TGA to retain that exact drawn layout.
    texture = artwork.resize((1024, 1024), Image.Resampling.LANCZOS)
    texture.save(out, format="TGA")

with Image.open(out) as verified:
    verified.load()
    if verified.size != (1024, 1024) or not verified.convert("RGBA").getchannel("A").getbbox():
        raise AssertionError("Packaged v122 Settings frame is invalid")
print("Prepared original v122 Settings frame:", out.stat().st_size, "bytes")
