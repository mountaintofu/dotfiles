#!/bin/bash
# changed to only [ON] for simplicity.

MAIN_SCRIPT="xfconf-query -c xfce4-power-manager -n -p /xfce4-power-manager/presentation-mode -T"

# Handle toggle when called with argument
if [ "$1" = "toggle" ]; then
    /usr/bin/xfconf-query -c xfce4-power-manager -n -p /xfce4-power-manager/presentation-mode -T
    exit 0
fi

# Get current state
STATE=$(/usr/bin/xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/presentation-mode 2>/dev/null)

# Define colors
ACTIVE="#9ECE6A"
ACTIVE1="#F7768E"
INACTIVE="#808080"

# Set colors based on state
if [ "$STATE" = "true" ]; then
    ON_COLOR="$ACTIVE"
#    OFF_COLOR="$INACTIVE"
else
    ON_COLOR="$INACTIVE"
#    OFF_COLOR="$ACTIVE1"
fi

# Genmon output
echo "<txt>[<span foreground='$ON_COLOR' font_weight='bold'>IDLE</span>]</txt>"
echo "<txtclick>$MAIN_SCRIPT toggle</txtclick>"
echo "<tool>Presentation Mode: ${STATE:-false}</tool>"