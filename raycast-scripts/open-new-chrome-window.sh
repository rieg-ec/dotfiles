#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open new chrome window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🕵🏻
# @raycast.packageName Raimundo.Scripts

# Documentation:
# @raycast.description Open new window in chrome
# @raycast.author Raimundo

tell application "Google Chrome"
	make new window
	activate
end tell