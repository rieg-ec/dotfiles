#!/usr/bin/env python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title GitHub PR Media Layout
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🖼️
# @raycast.packageName GitHub
# @raycast.argument1 { "type": "dropdown", "placeholder": "Layout", "data": [{ "title": "2 columns (auto rows)", "value": "cols:2" }, { "title": "1 column", "value": "cols:1" }, { "title": "3 columns (auto rows)", "value": "cols:3" }, { "title": "2 + 1", "value": "rows:2,1" }, { "title": "1 + 2", "value": "rows:1,2" }, { "title": "2 + 2", "value": "rows:2,2" }, { "title": "2 + 2 + 1", "value": "rows:2,2,1" }, { "title": "3 + 2", "value": "rows:3,2" }, { "title": "Custom rows…", "value": "custom" }] }
# @raycast.argument2 { "type": "text", "placeholder": "Custom rows, e.g. 2,1 or 3,2,1", "optional": true }

# Documentation:
# @raycast.author rieg-ec
# @raycast.description Formats GitHub-uploaded image/video attachment markup from the clipboard into a PR-ready HTML media grid, then copies it back to the clipboard.

"""
Format GitHub PR attachment snippets from the clipboard into an HTML media grid.

Typical workflow:
1. Upload/drop screenshots/videos into a GitHub PR comment.
2. Select the generated GitHub attachment text and copy it.
3. Run this Raycast command and pick a layout.
4. Paste the formatted snippet back into the PR comment.

Supported clipboard inputs:
- GitHub's generated <img ... src="https://github.com/user-attachments/assets/..." /> tags
- Bare GitHub attachment URLs, which are commonly generated for videos
- Markdown images: ![alt](url)
- Regular image/video URLs with common extensions

The output uses HTML <table>, <img>, and <video> tags because that gives better
control over mixed layouts in GitHub PR comments than Markdown tables.
"""

from __future__ import annotations

import html
import os
import re
import socket
import subprocess
import sys
from dataclasses import dataclass
from typing import Iterable
from urllib.parse import urlparse
from urllib.request import Request, urlopen


DEFAULT_LAYOUT = "cols:2"
TYPE_DETECTION_TIMEOUT_SECONDS = 3

IMAGE_EXTENSIONS = {
    ".apng",
    ".avif",
    ".bmp",
    ".gif",
    ".jpeg",
    ".jpg",
    ".png",
    ".svg",
    ".webp",
}
VIDEO_EXTENSIONS = {
    ".m4v",
    ".mov",
    ".mp4",
    ".mpeg",
    ".mpg",
    ".ogv",
    ".qt",
    ".webm",
}

ATTR_RE = re.compile(
    r"([:\w-]+)\s*=\s*(?:\"([^\"]*)\"|'([^']*)'|([^\s\"'=<>`]+))",
    re.IGNORECASE,
)
IMG_TAG_RE = re.compile(r"<img\b[^>]*>", re.IGNORECASE | re.DOTALL)
VIDEO_BLOCK_RE = re.compile(r"<video\b[^>]*>.*?</video>|<video\b[^>]*>", re.IGNORECASE | re.DOTALL)
SOURCE_TAG_RE = re.compile(r"<source\b[^>]*>", re.IGNORECASE | re.DOTALL)
MD_IMAGE_RE = re.compile(r"!\[([^\]]*)\]\(([^)\s]+)(?:\s+\"[^\"]*\")?\)")
URL_RE = re.compile(r"https?://[^\s<>\"'\])]+")


@dataclass(frozen=True)
class MediaItem:
    position: int
    url: str
    kind: str
    alt: str = ""


def run(command: list[str], *, input_text: str | None = None) -> str:
    return subprocess.check_output(command, input=input_text, text=True, encoding="utf-8")


def get_clipboard_text() -> str:
    # Test hook so we can validate the command without mutating your clipboard.
    if "GITHUB_PR_MEDIA_CLIPBOARD" in os.environ:
        return os.environ["GITHUB_PR_MEDIA_CLIPBOARD"]

    return run(["pbpaste"])


def set_clipboard_text(value: str) -> None:
    # Test hook so we can validate the formatter without mutating your clipboard.
    if os.environ.get("GITHUB_PR_MEDIA_DRY_RUN") == "1":
        print(value)
        return

    subprocess.run(["pbcopy"], input=value, text=True, encoding="utf-8", check=True)


def attrs_from_tag(tag: str) -> dict[str, str]:
    attrs: dict[str, str] = {}
    for match in ATTR_RE.finditer(tag):
        key = match.group(1).lower()
        value = next(group for group in match.groups()[1:] if group is not None)
        attrs[key] = html.unescape(value)
    return attrs


def cleaned_url(raw_url: str) -> str:
    # Strip common punctuation that may be attached when copying from prose.
    return raw_url.strip().rstrip(".,;:")


def extension_for_url(url: str) -> str:
    path = urlparse(url).path.lower()
    filename = path.rsplit("/", 1)[-1]
    if "." not in filename:
        return ""
    return "." + filename.rsplit(".", 1)[-1]


def content_type_for_url(url: str) -> str:
    if os.environ.get("GITHUB_PR_MEDIA_SKIP_TYPE_DETECTION") == "1":
        return ""

    socket.setdefaulttimeout(TYPE_DETECTION_TIMEOUT_SECONDS)
    headers = {"User-Agent": "Raycast GitHub PR Media Layout"}

    for method in ("HEAD", "GET"):
        request_headers = dict(headers)
        if method == "GET":
            request_headers["Range"] = "bytes=0-0"

        request = Request(url, method=method, headers=request_headers)
        try:
            with urlopen(request, timeout=TYPE_DETECTION_TIMEOUT_SECONDS) as response:
                return response.headers.get("Content-Type", "").split(";", 1)[0].lower()
        except Exception:
            continue

    return ""


def infer_kind(url: str, preferred_kind: str = "unknown") -> str:
    if preferred_kind in {"image", "video"}:
        return preferred_kind

    extension = extension_for_url(url)
    if extension in IMAGE_EXTENSIONS:
        return "image"
    if extension in VIDEO_EXTENSIONS:
        return "video"

    content_type = content_type_for_url(url)
    if content_type.startswith("image/"):
        return "image"
    if content_type.startswith("video/"):
        return "video"

    # GitHub emits bare user-attachment URLs for uploaded videos, while images
    # are usually emitted as <img ...>. If type detection failed, this is the
    # most useful fallback for the PR-review workflow.
    if "github.com/user-attachments/assets/" in url:
        return "video"

    return "unknown"


def extract_media_items(text: str) -> list[MediaItem]:
    candidates: list[MediaItem] = []

    for match in IMG_TAG_RE.finditer(text):
        attrs = attrs_from_tag(match.group(0))
        src = attrs.get("src")
        if src:
            candidates.append(MediaItem(match.start(), cleaned_url(src), "image", attrs.get("alt", "")))

    for match in VIDEO_BLOCK_RE.finditer(text):
        block = match.group(0)
        attrs = attrs_from_tag(block)
        src = attrs.get("src")
        if not src:
            source = SOURCE_TAG_RE.search(block)
            if source:
                src = attrs_from_tag(source.group(0)).get("src")
        if src:
            candidates.append(MediaItem(match.start(), cleaned_url(src), "video", attrs.get("alt", "")))

    for match in MD_IMAGE_RE.finditer(text):
        alt, url = match.groups()
        candidates.append(MediaItem(match.start(), cleaned_url(url), "image", alt))

    for match in URL_RE.finditer(text):
        candidates.append(MediaItem(match.start(), cleaned_url(match.group(0)), "unknown", ""))

    candidates.sort(key=lambda item: item.position)

    seen_urls: set[str] = set()
    media_items: list[MediaItem] = []
    for candidate in candidates:
        if candidate.url in seen_urls:
            continue
        seen_urls.add(candidate.url)
        media_items.append(
            MediaItem(
                candidate.position,
                candidate.url,
                infer_kind(candidate.url, candidate.kind),
                candidate.alt,
            )
        )

    return media_items


def ask_for_custom_rows() -> str:
    script = (
        'text returned of (display dialog "Custom media rows, e.g. 2,1 or 3,2,1" '
        'default answer "2,1" buttons {"Cancel", "OK"} default button "OK")'
    )
    return run(["osascript", "-e", script]).strip()


def parse_row_counts(value: str) -> list[int]:
    parts = re.split(r"[^0-9]+", value.strip())
    counts = [int(part) for part in parts if part]
    if not counts or any(count < 1 for count in counts):
        raise ValueError(f"Invalid layout: {value!r}. Use values like 2,1 or 3,2,1.")
    return counts


def resolve_layout_counts(layout: str, custom_rows: str) -> tuple[str, list[int], bool]:
    layout = (layout or DEFAULT_LAYOUT).strip()
    custom_rows = (custom_rows or "").strip()

    if layout == "custom":
        rows = custom_rows or ask_for_custom_rows()
        return rows, parse_row_counts(rows), False

    if layout.startswith("cols:"):
        cols = int(layout.split(":", 1)[1])
        if cols < 1:
            raise ValueError("Column count must be at least 1.")
        return f"{cols} column{'s' if cols != 1 else ''}", [cols], True

    if layout.startswith("rows:"):
        rows = layout.split(":", 1)[1]
        return rows, parse_row_counts(rows), False

    # Allows directly passing a custom value from terminal/tests, e.g. `2,1`.
    return layout, parse_row_counts(layout), False


def chunk_items(items: list[MediaItem], counts: list[int], repeat: bool) -> list[list[MediaItem]]:
    rows: list[list[MediaItem]] = []
    index = 0
    count_index = 0

    while index < len(items):
        if repeat:
            count = counts[0]
        elif count_index < len(counts):
            count = counts[count_index]
            count_index += 1
        else:
            # If an explicit layout has fewer cells than media items, continue
            # with the last row width so nothing is silently dropped.
            count = counts[-1]

        rows.append(items[index : index + count])
        index += count

    return rows


def render_media(item: MediaItem) -> str:
    url = html.escape(item.url, quote=True)
    alt = html.escape(item.alt or "GitHub attachment", quote=True)

    if item.kind == "image":
        return f'<img src="{url}" alt="{alt}" width="100%" />'

    if item.kind == "video":
        return f'<video src="{url}" controls width="100%"></video>'

    return f'<a href="{url}">{url}</a>'


def indent(text: str, spaces: int) -> str:
    prefix = " " * spaces
    return "\n".join(prefix + line if line else line for line in text.splitlines())


def render_table(rows: Iterable[list[MediaItem]]) -> str:
    tables: list[str] = []

    for row in rows:
        if not row:
            continue

        width = 100 / len(row)
        width_attr = f"{width:.4g}%"
        lines = ["<table>", "  <tr>"]
        for item in row:
            lines.append(f'    <td width="{width_attr}" align="center">')
            lines.append(indent(render_media(item), 6))
            lines.append("    </td>")
        lines.extend(["  </tr>", "</table>"])
        tables.append("\n".join(lines))

    return "\n\n".join(tables)


def fail(message: str) -> None:
    print(f"❌ {message}", file=sys.stderr)
    sys.exit(1)


def main() -> None:
    layout = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_LAYOUT
    custom_rows = sys.argv[2] if len(sys.argv) > 2 else ""

    clipboard = get_clipboard_text()
    media_items = extract_media_items(clipboard)
    if not media_items:
        fail(
            "No image/video URLs found in the clipboard. Upload the files to a GitHub PR comment first, copy the generated attachment text, then run this command."
        )

    try:
        layout_label, counts, repeat = resolve_layout_counts(layout, custom_rows)
    except ValueError as error:
        fail(str(error))

    rows = chunk_items(media_items, counts, repeat)
    output = render_table(rows)
    set_clipboard_text(output)

    if os.environ.get("GITHUB_PR_MEDIA_DRY_RUN") != "1":
        print(f"Copied {len(media_items)} media item{'s' if len(media_items) != 1 else ''} as layout {layout_label}.")


if __name__ == "__main__":
    main()
