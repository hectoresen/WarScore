# Classic Forever Simple — original assets

The owner's three original PNG files are kept at `docs/assets/simple/1.png`, `2.png` and `3.png`.
They have been converted with `scripts/build_simple_assets.py` and **the generated runtime TGA files are tracked in this feature branch**.

| Original | Runtime file | Purpose |
| --- | --- | --- |
| `1.png` | `addon/WarScore/Media/General/simple_rank_plaque_owner.tga` | Rank plaque and laurels |
| `2.png` | `addon/WarScore/Media/General/simple_divider_diamond_owner.tga` | Gold separator with diamond |
| `3.png` | `addon/WarScore/Media/General/simple_divider_thin_owner.tga` | Thin gold separator |

Every TGA is a transparent 1024×512 texture compatible with the existing Lua image references.
The conversion script retains aspect ratio and the painted alpha. Run
`python3 -m pip install Pillow && python3 scripts/build_simple_assets.py`
only if source PNGs change. Commit the generated TGAs along with any source changes.

The feature branch is now self-contained for the owner to download and test in WoW.
Visual positions must still be checked against the supplied reference screenshot.
No manual ZIP install or asset copying is required.
