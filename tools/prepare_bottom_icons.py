"""Normalize visible artwork on the secondary statistic card.

The three supplied transparent assets have very different alpha padding.
Crop the meaningful alpha extent and center each drawing in a 128x128
RGBA TGA canvas, deliberately harmonizing *visible* visual weight.
The original owner PNGs and all approved card geometry remain untouched.
"""
from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parents[1]
icons = {
    # filename, maximum visible long-side in output pixels
    "icon_bg_rate_owner_v79": ("icon_bg_rate_owner_v79_source.png", 110),
    "icon_duel_rate_owner_v79": ("icon_duel_rate_owner_v79_source.png", 96),
    "icon_favorite_bg_owner_v79": ("icon_favorite_bg_owner_v79_source.png", 112),
}
for name, (filename, target_long_side) in icons.items():
    source = root / "docs" / "assets" / filename
    dest = root / "addon" / "WarScore" / "Media" / "General" / (name + ".tga")
    with Image.open(source) as png:
        png.load()
        if png.size != (64, 64):
            raise ValueError(f"Unexpected icon source size: {name} {png.size}")
        icon = png.convert("RGBA")
        # Ignore low-alpha resampling fringe when measuring the subject.
        alpha = icon.getchannel("A")
        measured = alpha.point(lambda v: 255 if v >= 24 else 0).getbbox()
        if not measured:
            raise ValueError(f"Empty icon source: {name}")
        left, top, right, bottom = measured
        # Retain the surrounding anti-aliased fringe inside the crop.
        pad = 2
        crop = icon.crop((max(0, left-pad), max(0, top-pad),
                          min(icon.width, right+pad), min(icon.height, bottom+pad)))
        scale = target_long_side / max(crop.size)
        width = max(1, round(crop.width * scale))
        height = max(1, round(crop.height * scale))
        drawing = crop.resize((width, height), Image.Resampling.LANCZOS)
        output = Image.new("RGBA", (128, 128), (0, 0, 0, 0))
        output.alpha_composite(drawing, ((128-width)//2, (128-height)//2))
        output.save(dest, format="TGA")
        print(f"Normalized {name}: input bbox {measured}, drawing {width}x{height}, output 128x128")
