"""Generate the original WarScore minimap shield at native UI scale.

Source is the user's exact crossed-swords-on-red-shield artwork, resized
and cropped for the tiny minimap slot, without any circular decoration.
The source PNG is a 64x64 color-optimized transparent transport image.
"""
from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parents[1]
source = root / "docs/assets/minimap_icon_owner_v126_source.png"
destination = root / "addon/WarScore/Media/Minimap/warscore_icon_owner_v126.tga"
destination.parent.mkdir(parents=True, exist_ok=True)

with Image.open(source) as image:
    if image.size != (64, 64):
        raise ValueError(f"Unexpected owner minimap art size: {image.size}")
    rgba = image.convert("RGBA")
    if not rgba.getchannel("A").getbbox():
        raise ValueError("Owner minimap art is blank")
    rgba.save(destination, format="TGA")

with Image.open(destination) as image:
    image.load()
    if image.size != (64, 64):
        raise AssertionError("Invalid minimap icon dimensions")
print("Prepared WarScore v126 minimap icon:", destination.stat().st_size, "bytes")
