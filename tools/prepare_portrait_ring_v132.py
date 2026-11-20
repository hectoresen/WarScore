"""Convert the provided WarScore v132 gold portrait ring to client-compatible TGA.

The original uploaded PNG is 1254x1254 with transparency. This repository's
palette-preserving transport is 128x128; the WoW texture retains the full
transparent center and the exact owner's ornamental appearance.
"""
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
source = ROOT / "docs/assets/portrait_ring_owner_v132_source.png"
destination = ROOT / "addon/WarScore/Media/General/portrait_ring_owner_v132.tga"

with Image.open(source) as provided:
    if provided.size != (128, 128):
        raise ValueError(f"Unexpected portrait ornament source size: {provided.size}")
    rgba = provided.convert("RGBA")
    if not rgba.getchannel("A").getbbox():
        raise ValueError("Portrait ring source has no opaque ornament")
    if rgba.getpixel((64, 64))[3] != 0:
        raise ValueError("Portrait ring center must remain transparent")
    rgba.save(destination, format="TGA")
with Image.open(destination) as verified:
    verified.load()
    assert verified.size == (128, 128)
    assert verified.convert("RGBA").getpixel((64, 64))[3] == 0
print("Prepared owner's v132 portrait ring TGA", destination.stat().st_size)
