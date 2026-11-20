# Classic Forever Simple — owner asset integration

The three source PNGs were supplied by the owner on 2026-11-20 and converted to transparent, power-of-two, RLE-compressed TGA textures without redrawing their content.

| Runtime TGA | Role | Size | SHA-256 |
| --- | --- | --- | --- |
| `Media/General/simple_rank_plaque_owner.tga` | Rank plate + gold laurels | 1024×512 | `3edef37aa28cebfe360ae703b22063701e7f0216e87014aa3faab1777fec576e` |
| `Media/General/simple_divider_diamond_owner.tga` | Section separator and central diamond | 1024×512 | `e5b6b6f323fd7ff6db4c00826de9ad618ba7c22083657d9cfe84173f7ff094c8` |
| `Media/General/simple_divider_thin_owner.tga` | Thin horizontal stat-row separator | 1024×512 | `76d9e55a6f4ed76274e3f1754e50054f8fb939c73f0492953c0cc78ed6b50f4a` |

These files need to be committed to **the existing feature branch** under `addon/WarScore/Media/General/`. GitHub connector access cannot write local binary bytes. The release packager intentionally fails while these runtime resources are missing; do not open a PR or publish the addon before they are present.

The conversion embeds source transparency and the renderer uses `SetTexCoord` to skip transparent padding while preserving the painted content.

**Visual authority:** the owner's "WarScore Forever SIMPLE.png" screenshot. Final placement must be tuned using in-game screenshots. Static geometry and source asset conversion are not acceptance evidence.
