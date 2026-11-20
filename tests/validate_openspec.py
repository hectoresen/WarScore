#!/usr/bin/env python3
"""Validate existing OpenSpec change artifacts without inventing CLI/QA evidence.

This is a structural/traceability check, not a replacement for the official
OpenSpec CLI's validation and archival commands.
"""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
changes = root / "openspec" / "changes"
assert (root / "openspec" / "config.yaml").is_file(), "OpenSpec config missing"
assert (root / "openspec" / "README.md").is_file(), "OpenSpec instructions missing"

active = sorted(p for p in changes.iterdir() if p.is_dir() and p.name != "archive")
for change in active:
    for required in ("proposal.md", "design.md", "tasks.md"):
        path = change / required
        assert path.is_file() and path.stat().st_size > 0, f"{change.name}: missing {required}"
    specs = list((change / "specs").glob("*/spec.md"))
    assert specs, f"{change.name}: missing capability spec"
    for spec in specs:
        body = spec.read_text(encoding="utf-8")
        assert re.search(r"(?im)^## Requirement:", body), f"{spec}: no requirement"
        assert re.search(r"(?im)^### Scenario:", body), f"{spec}: no acceptance scenario"
        assert re.search(r"(?i)\b(SHALL|MUST)\b", body), f"{spec}: no normative requirement"
    tasks = (change / "tasks.md").read_text(encoding="utf-8")
    assert re.search(r"- \[[ xX]\]", tasks), f"{change.name}: no task checklist"

assert active, "No OpenSpec change artifacts found"
print(f"Traceability passed for {len(active)} active change(s); formal CLI validation/acceptance is separate.")
