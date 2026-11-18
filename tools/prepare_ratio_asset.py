"""Convert the owner-supplied indexed PNG artwork into a WoW TGA texture.

The PNG is a lossily palette-reduced copy of the provided art so it can be
stored and transferred; no additional ornament is drawn.
"""
from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parents[1]
source = root / "docs/assets/ratios_frame_owner_v69_source.png"
target = root / "Media/General/ratios_frame_owner_v69.tga"
with Image.open(source) as img:
    art = img.convert("RGBA").resize((1024, 256), Image.Resampling.LANCZOS)
    art.save(target, format="TGA")
print("Generated", target, target.stat().st_size, "bytes")
