"""Prepare the three owner-designed icons for the lower statistic row.

Source images are compact, transparency-preserving transfer copies of the
user's 1254x1254 RGBA PNGs. Do not substitute native inventory icons.
"""
from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parents[1]
icons = {
    "icon_bg_rate_owner_v79": "icon_bg_rate_owner_v79_source.png",
    "icon_duel_rate_owner_v79": "icon_duel_rate_owner_v79_source.png",
    "icon_favorite_bg_owner_v79": "icon_favorite_bg_owner_v79_source.png",
}
for name, filename in icons.items():
    source = root / "docs" / "assets" / filename
    dest = root / "Media" / "General" / (name + ".tga")
    with Image.open(source) as png:
        png.load()  # Fail on truncated or corrupt source bytes
        if png.size != (64, 64):
            raise ValueError(f"Unexpected source size for {name}: {png.size}")
        img = png.convert("RGBA")
        if not img.getchannel("A").getbbox():
            raise ValueError(f"Icon has no opaque artwork: {name}")
        img.resize((128, 128), Image.Resampling.LANCZOS).save(dest, format="TGA")
    print("Converted lower-card owner icon:", name, dest.stat().st_size)
