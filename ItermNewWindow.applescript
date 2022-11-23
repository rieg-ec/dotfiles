#!/usr/bin/osascript

if application "iTerm2-beta" is running then
	tell application "iTerm2-beta"
		create window with default profile
	end tell
else
	activate application "iTerm2-beta"
end if
