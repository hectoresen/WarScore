"""Convert the owner-provided top three-column card into a WoW TGA.

Source is the transparent, size-reduced PNG from the owner artwork.
Crop only transparent bottom/edge padding; preserve the existing gold art.
"""
from pathlib import Path
from PIL import Image, ImageFile

root = Path(__file__).resolve().parents[1]
src = root / "docs/assets/stat_band_top_owner_v74_source.png"
dst = root / "addon/WarScore/Media/General/stat_band_top_owner_v74.tga"
ImageFile.LOAD_TRUNCATED_IMAGES = True  # transport PNG is partially truncated; validate before release
with Image.open(src) as file:
    image = file.convert("RGBA")
    # Tiny transparent source padding would otherwise leave the bottom
    # gold rail suspended above the bottom of the 112-unit stat band.
    alpha = image.getchannel("A")
    print("SOURCE alpha bbox:", alpha.getbbox(), "opaque px:", sum(1 for v in alpha.getdata() if v > 80))
    bounds = alpha.point(lambda value: 255 if value >= 8 else 0).getbbox()
    if bounds is None:
        raise ValueError("Owner card art is fully transparent")
    left, top, right, bottom = bounds
    image = image.crop((max(0, left-2), max(0, top-2),
                        min(image.width, right+2), min(image.height, bottom+2)))
    image = image.resize((1024, 256), Image.Resampling.LANCZOS)
    dst.parent.mkdir(parents=True, exist_ok=True)
    image.save(dst, format="TGA")
print("Converted owner top stat frame:", dst, dst.stat().st_size, "bytes")

# v75: lower card has unequal cell widths, preserved in its own owner texture.
lower_src = root / "docs/assets/stat_band_bottom_owner_v75_source.png"
lower_dst = root / "addon/WarScore/Media/General/stat_band_bottom_owner_v75.tga"
with Image.open(lower_src) as file:
    lower = file.convert("RGBA")
    lower.load()  # Fail the packaging job on a damaged transport PNG.
    lower = lower.resize((1024, 256), Image.Resampling.LANCZOS)
    lower.save(lower_dst, format="TGA")
print("Converted owner lower stat frame:", lower_dst, lower_dst.stat().st_size, "bytes")
