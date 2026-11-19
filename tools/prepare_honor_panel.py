"""Convert owner's Honor ornamental frame transport PNG to an RGBA WoW TGA.

The shipped PNG preserves the entire decorated frame including the raised
central title plaque; all wording/currency values are rendered live in Lua.
"""
from pathlib import Path
from PIL import Image

repo = Path(__file__).resolve().parents[1]
source = repo / "docs/assets/honor_panel_owner_v98_source.png"
dest = repo / "addon/WarScore/Media/General/honor_panel_owner_v98.tga"
with Image.open(source) as original:
    original.load()
    if original.size != (512, 104):
        raise ValueError(f"Unexpected honor source size {original.size}")
    art = original.convert("RGBA")
    if not art.getchannel("A").getbbox():
        raise ValueError("Honor panel contains no visible ornament")
    art.resize((1024, 256), Image.Resampling.LANCZOS).save(dest, format="TGA")
print("Prepared owner honor panel:", dest.stat().st_size, "bytes")


# v120: standalone, owner-authored empty gold Honor/HK frame.
# Source is a transparent, aspect-preserving 512x128 transport copy
# cropped from the original 2048x682 PNG; no text/numbers are baked in.
source_v120 = repo / "docs/assets/honor_frame_owner_v120_source.png"
dest_v120 = repo / "addon/WarScore/Media/General/honor_frame_owner_v120.tga"
with Image.open(source_v120) as original:
    original.load()
    if original.size != (512, 128):
        raise ValueError(f"Unexpected v120 honor artwork dimensions: {original.size}")
    art = original.convert("RGBA")
    if not art.getchannel("A").getbbox():
        raise ValueError("Owner's v120 honor frame has no visible alpha")
    art.save(dest_v120, format="TGA")
print("Prepared real v120 honor ornamental frame:", dest_v120.stat().st_size, "bytes")
