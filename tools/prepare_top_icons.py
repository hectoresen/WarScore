"""Convert owner-supplied top-card icons to native WoW transparent TGA.

Source PNGs are deliberately downscaled/palette-limited transport copies.
The original user-supplied 1254×1254 RGBA artwork remains the visual reference.
No illustration is redrawn or substituted.
"""
from pathlib import Path
from PIL import Image
root = Path(__file__).resolve().parents[1]
sources = {
    "icon_duels_owner_v77": "icon_duels_owner_v77_source.png",
    "icon_bg_played_owner_v77": "icon_bg_played_owner_v77_source.png",
    "icon_bg_wins_owner_v77": "icon_bg_wins_owner_v77_source.png",
}
for name, source in sources.items():
    path = root / "docs" / "assets" / source
    dest = root / "addon" / "WarScore" / "Media" / "General" / (name + ".tga")
    with Image.open(path) as original:
        original.load()
        if original.size != (64, 64):
            raise ValueError(f"Unexpected icon source geometry: {path}")
        result = original.convert("RGBA").resize((128, 128), Image.Resampling.LANCZOS)
        if not result.getchannel("A").getbbox():
            raise ValueError(f"Transparent icon source: {path}")
        result.save(dest, format="TGA")
    print("Converted owner icon", name, dest.stat().st_size)
