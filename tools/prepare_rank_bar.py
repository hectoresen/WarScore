"""Prepare 21 rank fills and the complete ornamental PvP rank bar for WoW.

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

# v101: byte-verified owner PNG, Git blob 355e9981409281e0e2fde15eeb039db429e4824d.
# The owner provided a separate high-resolution PNG in this iteration.
# The transport copy is cropped from its real alpha bounds, 512x64
# and preserves original appearance without rebuilding the border in Lua.
frame_source = root / "docs/assets/rank_bar_frame_owner_v104_source.png"
with Image.open(frame_source) as original:
    original.load()
    if original.size != (384, 72):
        raise ValueError(f"Unexpected rank frame dimensions: {original.size}")
    frame = original.convert("RGBA")
    if not frame.getchannel("A").getbbox():
        raise ValueError("Rank bar frame has no visible pixels")
    frame.resize((1024, 128), Image.Resampling.LANCZOS).save(
        out / "rank_bar_frame_owner_v104.tga", format="TGA"
    )
print("Prepared 21 rank-fill steps and full v101 rank-bar frame")

# v102: restore the original gold hexagonal rank-label plate on each side.
# Cropping out transparent padding before resizing prevents flattening.
plate_file = source / "Placa dorada hexagonal para rango PvP.png"
with Image.open(plate_file) as original:
    original.load()
    rgba = original.convert("RGBA")
    # Ignore faint stray pixels around the source's real pointed silhouette.
    bbox = rgba.getchannel("A").point(lambda alpha: 255 if alpha >= 8 else 0).getbbox()
    if not bbox:
        raise ValueError("Owner rank plate is transparent")
    plate = rgba.crop(bbox)
    # Keep a generous 256x128 alpha canvas, respecting source aspect.
    plate.thumbnail((240, 112), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (256, 128), (0, 0, 0, 0))
    canvas.paste(plate, ((256 - plate.width)//2, (128 - plate.height)//2))
    canvas.save(out / "rank_name_plate_owner_v102.tga", format="TGA")
print("Prepared separate owner PvP rank nameplates")
