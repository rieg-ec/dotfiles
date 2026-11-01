#!/bin/bash
set -euo pipefail

file=$1

# We build the metadata JSON with JavaScript so that file names with quotes or
# backslashes stay valid JSON.
metadata=$(osascript -l JavaScript -e '
  function run(argv) {
    return JSON.stringify({name: argv[0], mimeType: "application/vnd.google-apps.spreadsheet"})
  }' "$(basename "$file" .xlsx)")

# Apps that start from Finder do not get the PATH of your shell, so we call gws
# by its full Homebrew path.
response=$(/opt/homebrew/bin/gws drive files create \
  --params '{"fields":"webViewLink"}' \
  --json "$metadata" \
  --upload "$file" \
  --upload-content-type application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)

open "$(/usr/bin/plutil -extract webViewLink raw -o - - <<<"$response")"
