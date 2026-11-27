#!/bin/bash
set -euo pipefail

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Weekly report
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📝
# @raycast.packageName Grupalia

# Documentation:
# @raycast.author rieg-ec
# @raycast.authorURL https://raycast.com/rieg-ec
# @raycast.description Opens a form to fill out the Product and Growth weekly reports and copy them as rich text for Mute.

# We always open the form in Chrome, because the draft and the KPI history live
# in that browser's localStorage for file:// pages.
open -a "Google Chrome" "$(dirname "$(realpath "$0")")/templates/reporte-semanal.html"
