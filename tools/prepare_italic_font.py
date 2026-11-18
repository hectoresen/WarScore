"""Fetch a pinned, licensed italic font to embed in the installable addon.

The font is Google's hosted Spectral-Italic.ttf, under SIL OFL 1.1.
Pin upstream Git blob SHA to reject accidental/corrupt upstream changes.
After CI first runs, the TTF is committed and local rebuilds need no network.
"""
from pathlib import Path
import hashlib
from urllib.request import urlopen

repo = Path(__file__).resolve().parents[1]
dest = repo / "addon/WarScore/Media/Fonts/Spectral-Italic.ttf"
sha = "99d6c2def129dea2daa47652c2168c271c7a59a7"
url = "https://raw.githubusercontent.com/google/fonts/main/ofl/spectral/Spectral-Italic.ttf"

def git_sha(data):
    return hashlib.sha1(b"blob " + str(len(data)).encode("ascii") + b"\\0" + data).hexdigest()

if dest.exists() and git_sha(dest.read_bytes()) == sha:
    print("Verified bundled italic font:", dest.stat().st_size, "bytes")
else:
    with urlopen(url, timeout=45) as response:
        data = response.read()
    if git_sha(data) != sha:
        raise ValueError("Upstream italic font checksum does not match pinned Git blob SHA")
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_bytes(data)
    print("Downloaded and verified licensed italic font:", len(data), "bytes")
