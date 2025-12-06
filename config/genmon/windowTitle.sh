#!/usr/bin/env zsh

# Cache xdotool path to avoid lookup
XDOTOOL=/usr/bin/xdotool

WINDOW_TITLE=$($XDOTOOL getwindowfocus getwindowname 2>/dev/null) || WINDOW_TITLE=""

if [[ -z "$WINDOW_TITLE" || "$WINDOW_TITLE" == "Xfwm4" ]]; then
    echo "<txt>Welcome</txt>"
    echo '<css>.genmon_value{color:#ffffff;padding:0 10px;}</css>'
else
    # Truncate in zsh directly (no external commands)
    (( ${#WINDOW_TITLE} > 40 )) && WINDOW_TITLE="${WINDOW_TITLE:0:40}..."
    echo "<txt>${WINDOW_TITLE}</txt>"
    echo '<css>.genmon_value{color:#ffffff;padding:0 10px;}</css>'
fi
