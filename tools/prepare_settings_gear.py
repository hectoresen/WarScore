"""Convert the supplied golden settings gear into a WoW-ready RGBA TGA.

The PNG is an 80x80 alpha-preserving, palette-optimized transport copy,
cropped from the owner's 1262x1246 image. Keep the file under docs/assets/
so the full-quality original can be substituted in a future design iteration.
"""
from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parents[1]
source = root / "docs/assets/settings_gear_owner_v94_source.png"
destination = root / "addon/WarScore/Media/General/settings_gear_owner_v94.tga"
with Image.open(source) as src:
    src.load()
    if src.size != (80, 80):
        raise ValueError(f"Unexpected settings gear source dimensions: {src.size}")
    image = src.convert("RGBA")
    if not image.getchannel("A").getbbox():
        raise ValueError("Golden settings gear artwork is empty")
    image.resize((128, 128), Image.Resampling.LANCZOS).save(destination, "TGA")
print("Prepared golden gear:", destination, destination.stat().st_size)
