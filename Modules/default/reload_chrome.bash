#!/bin/bash
var=$1
osascript <<EOD
  set u to "$var"
  tell application "Google Chrome"
    repeat with w in windows
      set i to 0
      repeat with t in tabs of w
        set i to i + 1
        if URL of t starts with u then
          set active tab index of w to i
          set index of w to 1
          tell t to reload
          --activate
          return
        end if
      end repeat
    end repeat
    open location u
    --activate
  end tell
EOD