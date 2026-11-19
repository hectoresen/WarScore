"""Prepare the designer's 21 PvP rank-fill variants and nameplate for WoW.

Assets reside in docs/assets/rank bars/. Keep native 900x50 bar proportions
while converting into power-of-two RGBA 1024x64 textures for compatibility.
All fill states share the same canvas so texture switching cannot move the bar.
"""
from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parents[1]
source = root / "docs/assets/rank bars"
out = root / "addon/WarScore/Media/General"
for percent in range(0, 101, 5):
    file = source / f"WarScore_RankFill_{percent:03d}.png"
    with Image.open(file) as original:
        original.load()
        if original.size != (900, 50):
            raise ValueError(f"Unexpected fill asset dimensions {file}: {original.size}")
        image = original.convert("RGBA")
        if percent and not image.getchannel("A").getbbox():
            raise ValueError(f"Empty authored rank fill: {file.name}")
        image.resize((1024, 64), Image.Resampling.LANCZOS).save(
            out / f"rank_fill_{percent:03d}.tga", format="TGA"
        )

plate_file = source / "Placa dorada hexagonal para rango PvP.png"
with Image.open(plate_file) as original:
    original.load()
    plate = original.convert("RGBA")
    bbox = plate.getchannel("A").getbbox()
    if not bbox:
        raise ValueError("Owner rank plate has no visible content")
    plate = plate.crop(bbox)
    # Convert into an alpha-preserving rectangular horizontal nameplate.
    # The source's ornamental aspect ratio will be inspected in game.
    plate.thumbnail((256, 128), Image.Resampling.LANCZOS)
    transparent = Image.new("RGBA", (256, 128), (0, 0, 0, 0))
    transparent.paste(plate, ((256 - plate.width)//2, (128 - plate.height)//2))
    transparent.save(out / "rank_name_plate_owner_v100.tga", format="TGA")
print("Prepared 21 rank-fill steps and 1 PvP-rank nameplate")
