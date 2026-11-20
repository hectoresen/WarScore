"""Release-version and installable-archive regression tests."""
import importlib.util
import tempfile
import unittest
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("release_warscore", ROOT / "scripts/release_warscore.py")
release = importlib.util.module_from_spec(spec)
spec.loader.exec_module(release)


class VersionTests(unittest.TestCase):
    def test_first_release(self):
        for increment in ("patch", "minor", "major"):
            self.assertEqual(release.next_version([], increment), "0.1.0")

    def test_semver(self):
        tags = ["random", "v0.1.0", "v0.1.7", "v0.2.0", "v01.99.99", "v1.0.0-rc1"]
        self.assertEqual(release.next_version(tags, "patch"), "0.2.1")
        self.assertEqual(release.next_version(tags, "minor"), "0.3.0")
        self.assertEqual(release.next_version(tags, "major"), "1.0.0")

    def test_invalid_increment(self):
        with self.assertRaises(ValueError):
            release.next_version([], "breaking")


class ArchiveTests(unittest.TestCase):
    def test_exact_contents_and_manifest_version(self):
        files = release.runtime_files()
        self.assertIn("WarScore.toc", files)
        self.assertIn("UI/General.lua", files)
        self.assertIn("UI/Minimap.lua", files)
        self.assertIn("Media/Fonts/OFL.txt", files)
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "WarScore-v0.1.0.zip"
            release.package("0.1.0", target)
            original = target.read_bytes()
            release.package("0.1.0", target)
            self.assertEqual(original, target.read_bytes(), "Archive must be deterministic")
            with zipfile.ZipFile(target) as archive:
                self.assertEqual(set(archive.namelist()), {"WarScore/" + f for f in files})
                self.assertIn(b"## Version: 0.1.0", archive.read("WarScore/WarScore.toc"))
                self.assertEqual(archive.testzip(), None)
                self.assertFalse(any("docs/" in f.lower() or "tools/" in f.lower()
                                     or "openspec/" in f.lower() for f in archive.namelist()))
        # Never modify source .toc while preparing a release.
        self.assertIn("## Version: 0.1.0",
                      (release.ADDON / "WarScore.toc").read_text())

    def test_release_version_matches_runtime_metadata(self):
        # The release job stamps the TOC in the archive; /ws version reads it.
        with tempfile.TemporaryDirectory() as directory:
            version = "2.4.7"
            target = Path(directory) / f"WarScore-v{version}.zip"
            release.package(version, target)
            with zipfile.ZipFile(target) as archive:
                toc = archive.read("WarScore/WarScore.toc").decode("utf-8")
                ui = archive.read("WarScore/UI/General.lua").decode("utf-8")
            self.assertIn(f"## Version: {version}", toc)
            self.assertIn('GetAddOnMetadata(ns.addonName or "WarScore", "Version")', ui)
            self.assertNotIn("UI_ITERATION", ui)

    def test_bad_version(self):
        with tempfile.TemporaryDirectory() as directory:
            for version in ("0.1", "0.1.0-dev", "01.2.3", "a.b.c", "1.2.3.4"):
                with self.subTest(version=version), self.assertRaises(ValueError):
                    release.package(version, Path(directory) / "invalid.zip")


if __name__ == "__main__":
    unittest.main()
