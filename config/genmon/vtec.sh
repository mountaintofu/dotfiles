#!/bin/bash

# Cache file for hardware detection
HW_CACHE="/tmp/vtec-hw-cache"

get_cached_fan_type() {
    if [[ -f "$HW_CACHE" ]] && (( $(date +%s) - $(stat -c %Y "$HW_CACHE") < 300 )); then
        cat "$HW_CACHE"
    else
        get_fan_control_type | tee "$HW_CACHE"
    fi
}

# Find dell_smm hwmon path (number can change)
find_dell_hwmon() {
    for hw in /sys/class/hwmon/hwmon*; do
        if [ "$(cat $hw/name 2>/dev/null)" = "dell_smm" ]; then
            echo "$hw"
            return
        fi
    done
}

DELL_HWMON=$(find_dell_hwmon)

# Check CPU frequency state
check_cpu_state() {
    if cpupower-gui freq 2>/dev/null | grep -qi "636"; then
        echo "off"
    else
        echo "on"
    fi
}

# Check fan control availability
get_fan_control_type() {
    # Check Dell i8k
    if command -v i8kfan &>/dev/null; then
        echo "i8k"
        return
    fi
    
    # Check dell_smm PWM
    if [ -n "$DELL_HWMON" ] && [ -f "$DELL_HWMON/pwm1" ]; then
        echo "dell_pwm"
        return
    fi
    
    # Check generic PWM
    for pwm in /sys/class/hwmon/hwmon*/pwm[0-9]; do
        if [ -f "$pwm" ] && [ -f "${pwm}_enable" ]; then
            echo "generic_pwm"
            return
        fi
    done
    
    echo "none"
}

# Set fans to performance
fans_performance() {
    local type=$(get_fan_control_type)
    
    case "$type" in
        i8k)
            sudo i8kfan 2 2 >/dev/null 2>&1
            ;;
        dell_pwm)
            echo 1 | sudo tee "$DELL_HWMON/pwm1_enable" >/dev/null 2>&1
            echo 255 | sudo tee "$DELL_HWMON/pwm1" >/dev/null 2>&1
            ;;
        generic_pwm)
            for pwm in /sys/class/hwmon/hwmon*/pwm[0-9]; do
                [ -f "$pwm" ] || continue
                echo 1 | sudo tee "${pwm}_enable" >/dev/null 2>&1
                echo 255 | sudo tee "$pwm" >/dev/null 2>&1
            done
            ;;
    esac
}

# Set fans to auto
fans_auto() {
    local type=$(get_fan_control_type)
    
    case "$type" in
        i8k)
            sudo i8kfan - - >/dev/null 2>&1
            ;;
        dell_pwm)
            echo 2 | sudo tee "$DELL_HWMON/pwm1_enable" >/dev/null 2>&1
            ;;
        generic_pwm)
            for pwm in /sys/class/hwmon/hwmon*/pwm[0-9]; do
                [ -f "$pwm" ] || continue
                echo 2 | sudo tee "${pwm}_enable" >/dev/null 2>&1
            done
            ;;
    esac
}

# Get current fan RPM
get_fan_rpm() {
    if [ -n "$DELL_HWMON" ]; then
        cat "$DELL_HWMON/fan1_input" 2>/dev/null
    else
        cat /sys/class/hwmon/hwmon*/fan*_input 2>/dev/null | head -1
    fi
}

# Get CPU temperature
get_cpu_temp() {
    local temp=$(cat /sys/class/hwmon/hwmon*/temp1_input 2>/dev/null | head -1)
    if [ -n "$temp" ]; then
        echo "$((temp / 1000))°C"
    else
        echo "N/A"
    fi
}

# Toggle V-TEC
toggle_vtec() {
    local cpu_state=$(check_cpu_state)
    
    if [ "$cpu_state" = "off" ]; then
        cpupower-gui pr Performance
        fans_performance
    else
        cpupower-gui pr Bottle
        fans_auto
    fi
}

# Get display
get_display() {
    local cpu_state=$(check_cpu_state)
    local fan_rpm=$(get_fan_rpm)
    local cpu_temp=$(get_cpu_temp)
    local fan_type=$(get_cached_fan_type)
    local SCRIPT_PATH="$(readlink -f "$0")"
    
    local fan_status
    case "$fan_type" in
        i8k)         fan_status="Dell i8k" ;;
        dell_pwm)    fan_status="Dell SMM" ;;
        generic_pwm) fan_status="PWM" ;;
        none)        fan_status="Read-only" ;;
    esac
    
    local NL=$'\n'
    
    if [ "$cpu_state" = "on" ]; then
        COLOR="#F7768E"
        TOOLTIP="V-TEC: ENGAGED!${NL}├─ CPU: Performance${NL}├─ Temp: ${cpu_temp}${NL}├─ Fan: ${fan_rpm} RPM${NL}└─ Control: ${fan_status}${NL}Click to disable."
    else
        COLOR="#808080"
        TOOLTIP="V-TEC: OFF${NL}├─ CPU: Powersave${NL}├─ Temp: ${cpu_temp}${NL}├─ Fan: ${fan_rpm} RPM${NL}└─ Control: ${fan_status}${NL}Click to engage."
    fi
    
    echo "<txt>[<span foreground='${COLOR}' font_weight='bold'>V-TEC</span>]</txt>"
    echo "<tool>${TOOLTIP}</tool>"
    echo "<txtclick>${SCRIPT_PATH} toggle</txtclick>"
}

# Main
case "${1}" in
    toggle)
        toggle_vtec
        ;;
    status)
        echo "CPU State: $(check_cpu_state)"
        echo "Fan RPM: $(get_fan_rpm)"
        echo "CPU Temp: $(get_cpu_temp)"
        echo "Fan Control: $(get_fan_control_type)"
        ;;
    *)
        get_display
        ;;
esac
