#!/usr/bin/env python3
"""Build a clean WoW addon ZIP from WarScore.toc and referenced media.

Usage: python3 tools/package_addon.py
The archive contains exactly one top-level WarScore/ folder. All documentation,
OpenSpec files, tooling and unused artwork remain in the source repository only.
"""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import re

REPO = Path(__file__).resolve().parents[1]
ROOT = REPO / "addon" / "WarScore"
TOC = ROOT / "WarScore.toc"
OUTPUT = REPO / "dist" / "WarScore.zip"
PREFIX = "Interface/AddOns/WarScore/Media/"


def source_files():
    scripts = [
        line.strip().replace("\\", "/")
        for line in TOC.read_text(encoding="utf-8-sig").splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    ]
    files = [Path("WarScore.toc")] + [Path(p) for p in scripts]
    media = set()
    for script in scripts:
        content = (ROOT / script).read_text(encoding="utf-8")
        # Lua literals write paths with doubled backslashes.
        normalized = content.replace("\\\\", "/")
        for name in re.findall(r"Interface/AddOns/WarScore/Media/(?!Fonts/)([A-Za-z0-9_/-]+)", normalized):
            media.add(Path("Media") / (name + ".tga"))
    # Custom italic TTF is a runtime resource too, not just source artwork.
    for script in scripts:
        content = (ROOT / script).read_text(encoding="utf-8").replace("\\\\", "/")
        for font in re.findall(r"Interface/AddOns/WarScore/Media/Fonts/([A-Za-z0-9_-]+[.]ttf)", content):
            media.add(Path("Media/Fonts") / font)
            media.add(Path("Media/Fonts/OFL.txt"))
    # Rank bar fill textures are selected dynamically in Lua by percentage.
    # Static source-path extraction cannot resolve their concatenated suffixes.
    if any("rank_fill_" in (ROOT / script).read_text(encoding="utf-8") for script in scripts):
        for percent in range(0, 101, 5):
            media.add(Path("Media/General") / f"rank_fill_{percent:03d}.tga")
    # Remove the incomplete path from the partial dynamic Lua literal.
    media.discard(Path("Media/General/rank_fill_.tga"))
    files.extend(sorted(media))
    for path in files:
        if path.is_absolute() or ".." in path.parts:
            raise ValueError(f"Invalid addon path: {path}")
        if not (ROOT / path).is_file():
            raise FileNotFoundError(f"Missing addon resource: {path}")
    return files


def main():
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    files = source_files()
    with ZipFile(OUTPUT, "w", ZIP_DEFLATED, compresslevel=9) as archive:
        for path in files:
            archive.write(ROOT / path, f"WarScore/{path.as_posix()}")
    with ZipFile(OUTPUT) as archive:
        assert archive.testzip() is None, "Corrupted addon ZIP"
        assert all(name.startswith("WarScore/") for name in archive.namelist())
        assert not any("openspec" in name.lower() or name.startswith("WarScore/docs/") for name in archive.namelist())
    print(f"Created {OUTPUT.relative_to(REPO)} with {len(files)} files")


if __name__ == "__main__":
    main()
