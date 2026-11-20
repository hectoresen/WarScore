#!/usr/bin/env python3
"""Offline checks for release-critical files, internal links, and TOC sources."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
required = (
    "README.md", "AGENTS.md", "LICENSE", "CONTRIBUTING.md",
    "ASSET_LICENSES.md", "SECURITY.md", "CODE_OF_CONDUCT.md",
    "docs/INDEX.md", "addon/WarScore/WarScore.toc",
    ".github/PULL_REQUEST_TEMPLATE.md",
)
for rel in required:
    assert (root / rel).is_file(), f"Required file missing: {rel}"

toc = root / "addon/WarScore/WarScore.toc"
paths = [line.strip().replace("\\", "/") for line in toc.read_text(encoding="utf-8-sig").splitlines()
         if line.strip() and not line.lstrip().startswith("#")]
assert paths, "TOC has no Lua entries"
for path in paths:
    assert (toc.parent / path).is_file(), f"TOC references missing source: {path}"
assert len(paths) == len(set(paths)), "Duplicate Lua entry in TOC"

# Check the public documentation's *local* Markdown links.
for rel in ("README.md", "CONTRIBUTING.md", "AGENTS.md", "docs/INDEX.md"):
    source = root / rel
    body = source.read_text(encoding="utf-8")
    for dest in re.findall(r"(?<!!)\[[^\]]+\]\(([^)]+)\)", body):
        dest = dest.split("#", 1)[0].split("?", 1)[0]
        if not dest or "://" in dest or dest.startswith(("mailto:", "#")):
            continue
        assert (source.parent / dest).exists(), f"Broken link in {rel}: {dest}"

print(f"Repository validation passed; {len(paths)} TOC sources and documentation links checked.")
