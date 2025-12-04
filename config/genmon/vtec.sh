#!/bin/bash

# V-TEC Genmon Script
# File: ~/.local/bin/vtec-genmon.sh

STATE_FILE="/tmp/vtec_state"

# Function to check current frequency state
check_freq_state() {
    # Check if 636 is present in cpupower-gui freq output
    if cpupower-gui freq 2>/dev/null | grep -qi "636"; then
        echo "off"  # 636 detected = V-TEC OFF (low freq/powersave)
    else
        echo "on"   # 636 not detected = V-TEC ON (high freq/performance)
    fi
}

# Function to toggle profile
toggle_vtec() {
    current_state=$(check_freq_state)
    
    if [ "$current_state" = "off" ]; then
        # Currently OFF (636 detected), switch to Performance
        cpupower-gui pr Performance
        echo "on" > "$STATE_FILE"
    else
        # Currently ON, switch to Bottle (OFF)
        cpupower-gui pr Bottle
        echo "off" > "$STATE_FILE"
    fi
}

# Function to get display output
get_display() {
    current_state=$(check_freq_state)
    
    if [ "$current_state" = "off" ]; then
        # 636 detected - Display gray (V-TEC OFF)
        COLOR="#808080"
        TOOLTIP="V-TEC: OFF (Bottle Mode). Click to enable Performance"
    else
        # 636 not detected - Display green (V-TEC ON)
        COLOR="#F7768E"
        TOOLTIP="V-TEC: ENGAGED! (Performance Mode). Click to disable"
    fi
    
    # Get current script path for click command
    SCRIPT_PATH="$(readlink -f "$0")"
    
    # Output genmon format
    echo "<txt>[<span foreground='${COLOR}' font_weight='bold'>V-TEC</span>]</txt>"
    echo "<tool>${TOOLTIP}</tool>"
    echo "<txtclick>${SCRIPT_PATH} toggle</txtclick>"
}

# Main logic
case "${1}" in
    toggle)
        toggle_vtec
        ;;
    *)
        get_display
        ;;
esac