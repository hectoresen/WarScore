"""Create WoW-compatible close button TGA from the owner's transparent PNG.

This 96x96 PNG is an optimized transport copy cropped from the supplied
1262x1246 RGBA artwork, not a newly generated approximation.
"""
from pathlib import Path
from PIL import Image

repo = Path(__file__).resolve().parents[1]
source = repo / "docs/assets/close_button_owner_v91_source.png"
target = repo / "addon/WarScore/Media/General/close_button_owner_v91.tga"
with Image.open(source) as source_image:
    source_image.load()
    if source_image.size != (96, 96):
        raise ValueError(f"Unexpected owner close source size: {source_image.size}")
    artwork = source_image.convert("RGBA")
    if not artwork.getchannel("A").getbbox():
        raise ValueError("Missing alpha artwork in owner close asset")
    artwork = artwork.resize((128, 128), Image.Resampling.LANCZOS)
    artwork.save(target, format="TGA")
print("Prepared new owner close button TGA:", target.stat().st_size)
