# WarScore — development and releases

`addon/WarScore/` is the copy-ready addon. Work directly in this directory; do not create or commit a ZIP on every iteration. Tools, docs and OpenSpec are repository-only.

## Development workflow

1. Start a feature branch from `main`; continue subsequent iterations of the same task on that branch.
2. Follow `AGENTS.md`, applicable specs and the approved UI/art assets.
3. Edit the addon and relevant docs, run PR checks, then open/update a pull request.
4. The owner tests in WoW Forever and **manually merges** approved PRs. Agents must never merge, enable auto-merge or publish a release.
5. Verify Lua compatibility, texture paths, stats and UI behavior; treat CI results separately from in-game acceptance.

## Publishing a release (owner only)

Once all intended features are merged and tested:

1. Go to [Actions — Publish WarScore Release](https://github.com/hectoresen/WarScore/actions/workflows/publish-release.yml).
2. Select **Run workflow**, branch `main`, and choose **patch**, **minor** or **major**.
3. The workflow validates repository structure, OpenSpec artifacts, Lua 5.1 syntax, statistics and packaging regressions.
4. It checks that the tested commit is still the head of `main`, computes the next `vMAJOR.MINOR.PATCH` tag, and produces one `WarScore-vMAJOR.MINOR.PATCH.zip` installable archive.
5. It publishes a GitHub Release with auto-generated notes and that ZIP attached. Before `v1.0.0`, releases are marked **pre-release**.

With no valid semantic-version tags, the first release is `v0.1.0` regardless of the selected increment. Thereafter:

| Increment | Example |
| --- | --- |
| patch | `v0.1.0 → v0.1.1` |
| minor | `v0.1.0 → v0.2.0` |
| major | `v0.2.0 → v1.0.0` |

The archive includes only runtime files referenced by `WarScore.toc` and the Lua media resolver, including dynamically selected rank fills and required font attribution. It excludes repository docs, tooling, OpenSpec and unused art. The `## Version` field inside the ZIP is set to the release version; source `.toc` stays unchanged.

The workflow requires dispatch from `main` by GitHub user `hectoresen`, prevents overlapping release runs, rejects existing tags/releases, and obtains `contents: write` **only** in its publishing job. It neither commits nor pushes to `main`. GitHub automatically offers **Source code** archive downloads alongside our single uploaded ZIP; those source archives are not meant for installation.

## Local release-build checks

```bash
python3 -m unittest discover -s tests -p 'test_release_package.py' -v
python3 scripts/release_warscore.py --version 0.1.0 --output /tmp/WarScore-v0.1.0.zip
unzip -t /tmp/WarScore-v0.1.0.zip
```

These local commands do **not** publish or create a tag. Use `tools/package_addon.py` only for optional local dev packaging; never commit its output to `main`.

## Asset generation and licensing

Existing asset-conversion tools under `tools/prepare_*.py` are separate from publication. They produce assets under `addon/WarScore/Media/`; the release reads verified files already committed in the addon folder. The bundled Spectral Italic font is subject to SIL OFL 1.1 and its `Media/Fonts/OFL.txt` attribution.
