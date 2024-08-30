#!/usr/bin/osascript

if application "iTerm2-beta" is running then
    tell application "iTerm2-beta"
        create window with default profile
        tell current session of current window
            write text "arch -arm64 /bin/bash --login"
        end tell
    end tell
else
    activate application "iTerm2-beta"
    tell application "iTerm2-beta" to delay 1
    tell application "iTerm2-beta"
        tell current session of current window
            write text "arch -arm64 /bin/bash --login"
        end tell
    end tell
end if

