#!/usr/bin/env zsh
# Dependencies: zsh>=5.0, coreutils, gawk, xfce4-power-manager

readonly DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"

# Find battery and AC paths
BAT_PATH=$(find /sys/class/power_supply/ -name "BAT*" 2>/dev/null | head -n 1)
AC_PATH=$(find /sys/class/power_supply/ -name "AC*" -o -name "ADP*" 2>/dev/null | head -n 1)

if [ -z "$BAT_PATH" ]; then
    echo "<txt>No Battery</txt>"
    exit 0
fi

# Function to safely read sysfs files
safe_read() {
    local file=$1
    local default=${2:-"Unknown"}
    if [ -f "$file" ] && [ -r "$file" ]; then
        cat "$file" 2>/dev/null || echo "$default"
    else
        echo "$default"
    fi
}

# Read basic info
readonly MANUFACTURER=$(safe_read "$BAT_PATH/manufacturer" "Unknown")
readonly MODEL=$(safe_read "$BAT_PATH/model_name" "Unknown")
readonly TECHNOLOGY=$(safe_read "$BAT_PATH/technology" "Unknown")
readonly BATTERY=$(safe_read "$BAT_PATH/capacity" "0")

# Read battery status: "Charging", "Discharging", "Not charging", "Full", "Unknown"
readonly BAT_STATUS=$(safe_read "$BAT_PATH/status" "Unknown")

# Serial number detection
get_serial_number() {
    if [ -f "$BAT_PATH/serial_number" ] && [ -r "$BAT_PATH/serial_number" ]; then
        local serial=$(cat "$BAT_PATH/serial_number" 2>/dev/null)
        if [ -n "$serial" ] && [ "$serial" != " " ] && [ "$serial" != "0" ]; then
            echo "$serial"
            return
        fi
    fi
    
    if command -v upower &> /dev/null; then
        local bat_name=$(basename "$BAT_PATH")
        local serial=$(upower -i /org/freedesktop/UPower/devices/battery_${bat_name} 2>/dev/null | grep "serial:" | awk '{print $2}')
        if [ -n "$serial" ] && [ "$serial" != "0" ]; then
            echo "$serial"
            return
        fi
    fi
    
    echo "N/A"
}

readonly SERIAL_NUMBER=$(get_serial_number)

# Function to convert microunits to regular units
convert_micro() {
    local value=$1
    if [ -n "$value" ] && [ "$value" != "0" ]; then
        awk -v val="$value" 'BEGIN {printf "%.2f", val / 1000000}'
    else
        echo "0"
    fi
}

# Read energy/charge values
if [ -f "$BAT_PATH/energy_now" ]; then
    ENERGY=$(convert_micro "$(safe_read "$BAT_PATH/energy_now" "0")")
    ENERGY_FULL=$(convert_micro "$(safe_read "$BAT_PATH/energy_full" "0")")
    ENERGY_DESIGN=$(convert_micro "$(safe_read "$BAT_PATH/energy_full_design" "0")")
elif [ -f "$BAT_PATH/charge_now" ]; then
    VOLTAGE_NOW=$(safe_read "$BAT_PATH/voltage_now" "0")
    CHARGE_NOW=$(safe_read "$BAT_PATH/charge_now" "0")
    CHARGE_FULL=$(safe_read "$BAT_PATH/charge_full" "0")
    CHARGE_DESIGN=$(safe_read "$BAT_PATH/charge_full_design" "0")
    
    if [ "$VOLTAGE_NOW" != "0" ]; then
        ENERGY=$(awk -v c="$CHARGE_NOW" -v v="$VOLTAGE_NOW" 'BEGIN {printf "%.2f", (c * v) / 1000000000000}')
        ENERGY_FULL=$(awk -v c="$CHARGE_FULL" -v v="$VOLTAGE_NOW" 'BEGIN {printf "%.2f", (c * v) / 1000000000000}')
        ENERGY_DESIGN=$(awk -v c="$CHARGE_DESIGN" -v v="$VOLTAGE_NOW" 'BEGIN {printf "%.2f", (c * v) / 1000000000000}')
    else
        ENERGY="0"
        ENERGY_FULL="0"
        ENERGY_DESIGN="0"
    fi
else
    ENERGY="N/A"
    ENERGY_FULL="N/A"
    ENERGY_DESIGN="N/A"
fi

readonly VOLTAGE=$(convert_micro "$(safe_read "$BAT_PATH/voltage_now" "0")")

if [ -f "$BAT_PATH/power_now" ]; then
    RATE=$(convert_micro "$(safe_read "$BAT_PATH/power_now" "0")")
elif [ -f "$BAT_PATH/current_now" ]; then
    CURRENT_NOW=$(safe_read "$BAT_PATH/current_now" "0")
    VOLTAGE_NOW=$(safe_read "$BAT_PATH/voltage_now" "0")
    if [ "$VOLTAGE_NOW" != "0" ]; then
        RATE=$(awk -v c="$CURRENT_NOW" -v v="$VOLTAGE_NOW" 'BEGIN {printf "%.2f", (c * v) / 1000000000000}')
    else
        RATE="0"
    fi
else
    RATE="N/A"
fi

if [ -f "$BAT_PATH/temp" ]; then
    TEMP_RAW=$(safe_read "$BAT_PATH/temp" "0")
    TEMPERATURE=$(awk -v t="$TEMP_RAW" 'BEGIN {printf "%.1f", t / 10}')
else
    TEMPERATURE="N/A"
fi

# Calculate time remaining using upower if available
get_time_remaining() {
    if command -v upower &> /dev/null; then
        local bat_name=$(basename "$BAT_PATH")
        local time_info=$(upower -i /org/freedesktop/UPower/devices/battery_${bat_name} 2>/dev/null | grep "time to" | head -1 | awk -F': ' '{print $2}' | xargs)
        if [ -n "$time_info" ]; then
            echo "$time_info"
            return
        fi
    fi
    echo "N/A"
}

readonly TIME_UNTIL=$(get_time_remaining)

# Function to generate battery bar
generate_battery_bar() {
    local percent=$1
    #local CHAR_FILLED="█"  # Block (recommended)
    #local CHAR_FILLED="#"  # Hash
    #local CHAR_FILLED="●"  # Filled dot
    #local CHAR_FILLED="|"  # Pipe
    local CHAR_FILLED="▮"  # Narrow block
    local CHAR_EMPTY=" "
    local BAR_LENGTH=4
    
    local segments=$(( (percent + 24) / 25 ))
    [ $segments -gt $BAR_LENGTH ] && segments=$BAR_LENGTH
    [ $segments -lt 0 ] && segments=0
    
    local filled=""
    local empty=""
    
    for ((i=0; i<segments; i++)); do
        filled+="${CHAR_FILLED}"
    done
    for ((i=segments; i<BAR_LENGTH; i++)); do
        empty+="${CHAR_EMPTY}"
    done
    
    echo "${filled}${empty}"
}

BATTERY_BAR=$(generate_battery_bar "${BATTERY}")

# Panel
INFO=""
if command -v xfce4-power-manager-settings &> /dev/null; then
    INFO+="<txtclick>xfce4-power-manager-settings</txtclick>"
    INFO+="<click>xfce4-power-manager-settings</click>"
fi

INFO+="<txt>"

case "${BAT_STATUS}" in
    Charging)
        # Charging - everything Cyan
        INFO+="<span weight='Bold' fgcolor='Cyan'>[${BATTERY_BAR}]</span>"
        ;;
    Full|"Not charging")
        # Full or Not charging - Green
        INFO+="<span weight='Bold' fgcolor='Light Green'>[${BATTERY_BAR}]</span>"
        ;;
    Discharging)
        # Discharging - gray brackets, colored content
        GRAY="#808080"
        
        if [ "${BATTERY}" -lt 10 ]; then
            INFO+="<span fgcolor='${GRAY}'>[</span>"
            INFO+="<span weight='Bold' fgcolor='White' bgcolor='Red'>${BATTERY_BAR}</span>"
            INFO+="<span fgcolor='${GRAY}'>]</span>"
        elif [ "${BATTERY}" -lt 25 ]; then
            INFO+="<span fgcolor='${GRAY}'>[</span>"
            INFO+="<span weight='Bold' fgcolor='Red'>${BATTERY_BAR}</span>"
            INFO+="<span fgcolor='${GRAY}'>]</span>"
        elif [ "${BATTERY}" -lt 50 ]; then
            INFO+="<span fgcolor='${GRAY}'>[</span>"
            INFO+="<span fgcolor='Yellow'>${BATTERY_BAR}</span>"
            INFO+="<span fgcolor='${GRAY}'>]</span>"
        else
            INFO+="<span fgcolor='${GRAY}'>[</span>"
            INFO+="<span fgcolor='White'>${BATTERY_BAR}</span>"
            INFO+="<span fgcolor='${GRAY}'>]</span>"
        fi
        ;;
    *)
        # Unknown state - Yellow
        INFO+="<span weight='Bold' fgcolor='Yellow'>[${BATTERY_BAR}]</span>"
        ;;
esac

INFO+="</txt>"

# Tooltip
MORE_INFO="<tool>"
MORE_INFO+="┌ ${MANUFACTURER} ${MODEL}\n"
[ "$SERIAL_NUMBER" != "N/A" ] && MORE_INFO+="├─ Serial number: ${SERIAL_NUMBER}\n"
MORE_INFO+="├─ Technology: ${TECHNOLOGY}\n"
[ "$TEMPERATURE" != "N/A" ] && MORE_INFO+="├─ Temperature: +${TEMPERATURE}℃\n"
MORE_INFO+="├─ Status: ${BAT_STATUS}\n"
MORE_INFO+="├─ Capacity: ${BATTERY}%\n"
MORE_INFO+="├─ Energy: ${ENERGY} Wh\n"
MORE_INFO+="├─ Energy when full: ${ENERGY_FULL} Wh\n"
MORE_INFO+="├─ Energy (design): ${ENERGY_DESIGN} Wh\n"
MORE_INFO+="├─ Rate: ${RATE} W\n"

case "${BAT_STATUS}" in
    Discharging)
        MORE_INFO+="└─ Remaining: ${TIME_UNTIL}"
        ;;
    Charging)
        MORE_INFO+="└─ Time to full: ${TIME_UNTIL}"
        ;;
    *)
        MORE_INFO+="└─ Voltage: ${VOLTAGE} V"
        ;;
esac

MORE_INFO+="</tool>"

echo -e "${INFO}"
echo -e "${MORE_INFO}"