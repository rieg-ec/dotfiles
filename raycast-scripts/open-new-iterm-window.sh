#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open new iterm window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💻
# @raycast.packageName Raimundo.Scripts

# Documentation:
# @raycast.description Open new iterm window
# @raycast.author Raimundo

 on run
     tell application "iTerm"
         create window with default profile
     end tell
     return input
 end run