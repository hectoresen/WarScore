#!/usr/bin/env python3
"""Rebuild runtime TGA art from the owner's PNGs in docs/assets/simple/.

No source artwork is redrawn. The output is committed in the feature branch so
players can download addon/WarScore directly without any extra installation.
"""
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "docs/assets/simple"
DEST = ROOT / "addon/WarScore/Media/General"
ASSETS = {
    "1.png": "simple_rank_plaque_owner.tga",
    "2.png": "simple_divider_diamond_owner.tga",
    "3.png": "simple_divider_thin_owner.tga",
}


def main():
    DEST.mkdir(parents=True, exist_ok=True)
    for source_name, output_name in ASSETS.items():
        with Image.open(SOURCE / source_name) as original:
            image = original.convert("RGBA")
        bounds = image.getchannel("A").getbbox()
        if bounds is None:
            raise ValueError(f"Missing visible artwork: {source_name}")
        image = image.crop(bounds)
        factor = min(1024 / image.width, 512 / image.height)
        width, height = round(image.width * factor), round(image.height * factor)
        image = image.resize((width, height), Image.Resampling.LANCZOS)
        canvas = Image.new("RGBA", (1024, 512), (0, 0, 0, 0))
        canvas.paste(image, ((1024 - width) // 2, (512 - height) // 2))
        path = DEST / output_name
        canvas.save(path, format="TGA", rle=True)
        with Image.open(path) as check:
            assert check.size == (1024, 512) and check.mode == "RGBA"
            assert check.getchannel("A").getbbox()
        print(f"Generated {path.relative_to(ROOT)} from {source_name}")


if __name__ == "__main__":
    main()
