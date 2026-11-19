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
    if original.size != (256, 64):
        raise ValueError(f"Unexpected honor source size {original.size}")
    art = original.convert("RGBA")
    if not art.getchannel("A").getbbox():
        raise ValueError("Honor panel contains no visible ornament")
    art.resize((1024, 256), Image.Resampling.LANCZOS).save(dest, format="TGA")
print("Prepared owner honor panel:", dest.stat().st_size, "bytes")
