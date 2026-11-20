#!/usr/bin/env python3
"""Build a minimal, deterministic WarScore GitHub Release archive.

The installable payload comes from the current .toc and Lua-referenced media,
using the same runtime-file resolver as the existing development tooling.
No source files or committed distribution files are changed.
"""
import argparse
import importlib.util
import re
import sys
import zipfile
from pathlib import Path, PurePosixPath

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "addon" / "WarScore"
MANIFEST = "WarScore.toc"
SEMVER = re.compile(r"^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$")
VERSION_LINE = re.compile(r"^## Version:[^\r\n]*$", re.MULTILINE)


def next_version(tags, increment):
    if increment not in ("patch", "minor", "major"):
        raise ValueError("Expected patch, minor or major")
    versions = [tuple(map(int, match.groups())) for tag in tags
                if (match := SEMVER.fullmatch(tag.strip()))]
    if not versions:
        return "0.1.0"
    major, minor, patch = max(versions)
    if increment == "major":
        return f"{major + 1}.0.0"
    if increment == "minor":
        return f"{major}.{minor + 1}.0"
    return f"{major}.{minor}.{patch + 1}"


def runtime_files(addon=ADDON):
    """Resolve real installable content; reject missing and unsafe entries."""
    if not (addon / MANIFEST).is_file():
        raise ValueError("Missing WarScore.toc")
    resolver = ROOT / "tools" / "package_addon.py"
    spec = importlib.util.spec_from_file_location("warscore_runtime_resolver", resolver)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    # Existing resolver is the canonical list for Lua, dynamic rank-bar art
    # and the Spectral font attribution. It uses the actual repo addon.
    if addon != ADDON:
        raise ValueError("Packaging a different addon directory is not supported")
    paths = [path.as_posix() for path in module.source_files()]
    if not paths or paths[0] != MANIFEST or len(paths) != len(set(paths)):
        raise ValueError("Invalid or duplicate runtime paths")
    for name in paths:
        path = PurePosixPath(name)
        if (path.is_absolute() or ".." in path.parts or "." in path.parts
                or "\\" in name or not re.fullmatch(r"[A-Za-z0-9_./-]+", name)):
            raise ValueError(f"Unsafe runtime path: {name}")
        if not (addon / name).is_file():
            raise ValueError(f"Missing runtime dependency: {name}")
    return paths


def package(version, output):
    if not SEMVER.fullmatch("v" + version):
        raise ValueError("Expected MAJOR.MINOR.PATCH numeric version")
    paths = runtime_files()
    source = (ADDON / MANIFEST).read_text(encoding="utf-8-sig")
    if len(VERSION_LINE.findall(source)) != 1:
        raise ValueError("Expected exactly one .toc Version header")
    manifest = VERSION_LINE.sub("## Version: " + version, source)
    if "## Interface: 16001" not in manifest:
        raise ValueError("Unexpected WoW Forever interface")
    output = Path(output)
    output.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(output, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for name in paths:
            data = manifest.encode("utf-8") if name == MANIFEST else (ADDON / name).read_bytes()
            info = zipfile.ZipInfo("WarScore/" + name, (2020, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o644 << 16
            archive.writestr(info, data, compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
    with zipfile.ZipFile(output) as archive:
        if set(archive.namelist()) != {"WarScore/" + name for name in paths}:
            raise ValueError("Archive content mismatch")
        if archive.testzip() is not None:
            raise ValueError("Corrupt ZIP archive")
        if archive.read("WarScore/WarScore.toc") != manifest.encode("utf-8"):
            raise ValueError("Packaged version mismatch")
    return output


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--bump", choices=("patch", "minor", "major"))
    parser.add_argument("--tags-file", type=Path)
    parser.add_argument("--version")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if args.bump is not None and args.tags_file and args.version is None and args.output is None:
        print(next_version(args.tags_file.read_text(encoding="utf-8").splitlines(), args.bump))
    elif args.version and args.output and not args.bump and not args.tags_file:
        print(package(args.version, args.output))
    else:
        parser.error("Use --bump and --tags-file OR --version and --output")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, zipfile.BadZipFile) as error:
        sys.exit(str(error))
