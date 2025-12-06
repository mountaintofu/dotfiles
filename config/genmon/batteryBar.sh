#!/usr/bin/env zsh
# Dependencies: zsh>=5.0, gawk, xfce4-power-manager

readonly CACHE_FILE="/tmp/battery-static-cache"
readonly CACHE_MAX_AGE=3600  # seconds

# Safely read sysfs file (use zsh's < redirection - faster than cat)
safe_read() {
    [[ -r $1 ]] && <"$1" 2>/dev/null || print "${2:-Unknown}"
}

# Use glob instead of find (faster, no fork)
find_battery() {
    local matches=(/sys/class/power_supply/BAT*(N-/))
    (( ${#matches} )) && { print "${matches[1]}"; return 0; }
    return 1
}

get_serial_number() {
    local serial=$(safe_read "$BAT_PATH/serial_number" "")
    [[ -n $serial && $serial != [[:space:]]# && $serial != 0 ]] && { print "$serial"; return; }
    
    if (( $+commands[upower] )); then
        serial=$(upower -i "/org/freedesktop/UPower/devices/battery_${BAT_PATH:t}" 2>/dev/null | 
                 awk '/serial:/{print $2; exit}')
        [[ -n $serial && $serial != 0 ]] && { print "$serial"; return; }
    fi
    print "N/A"
}

load_static_info() {
    # Check cache validity
    if [[ -f $CACHE_FILE ]]; then
        zmodload -F zsh/stat b:zstat 2>/dev/null
        local -i mtime=$(zstat +mtime "$CACHE_FILE" 2>/dev/null || print 0)
        if (( EPOCHSECONDS - mtime < CACHE_MAX_AGE )); then
            source "$CACHE_FILE" 2>/dev/null
            [[ -d $BAT_PATH ]] && return 0
        fi
    fi
    
    BAT_PATH=$(find_battery) || return 1
    MANUFACTURER=$(safe_read "$BAT_PATH/manufacturer")
    MODEL=$(safe_read "$BAT_PATH/model_name")
    TECHNOLOGY=$(safe_read "$BAT_PATH/technology")
    SERIAL_NUMBER=$(get_serial_number)
    
    # Use printf %q for proper escaping
    printf '%s=%q\n' BAT_PATH "$BAT_PATH" MANUFACTURER "$MANUFACTURER" \
        MODEL "$MODEL" TECHNOLOGY "$TECHNOLOGY" SERIAL_NUMBER "$SERIAL_NUMBER" > "$CACHE_FILE"
}

get_time_remaining() {
    (( $+commands[upower] )) || { print "N/A"; return; }
    upower -i "/org/freedesktop/UPower/devices/battery_${BAT_PATH:t}" 2>/dev/null |
        awk '/time to/{sub(/.*: */, ""); print; exit}' || print "N/A"
}

generate_battery_bar() {
    local -i segs=$(( ($1 + 24) / 25 ))
    (( segs = segs > 4 ? 4 : segs < 0 ? 0 : segs ))
    print -n "${(l:segs::▮:)}${(l:4-segs:: :)}"
}

# === Main ===
zmodload -F zsh/datetime p:EPOCHSECONDS 2>/dev/null

load_static_info || { print "<txt>No Battery</txt>"; exit 0; }

# Read dynamic values once
typeset -i BATTERY=$(safe_read "$BAT_PATH/capacity" 0)
typeset BAT_STATUS=$(safe_read "$BAT_PATH/status" "Unknown")
typeset -i VOLTAGE_RAW=$(safe_read "$BAT_PATH/voltage_now" 0)

# Batch all numeric conversions in single awk call
if [[ -f $BAT_PATH/energy_now ]]; then
    read -r ENERGY ENERGY_FULL ENERGY_DESIGN VOLTAGE RATE < <(
        awk -v e="$(safe_read "$BAT_PATH/energy_now" 0)" \
            -v ef="$(safe_read "$BAT_PATH/energy_full" 0)" \
            -v ed="$(safe_read "$BAT_PATH/energy_full_design" 0)" \
            -v v="$VOLTAGE_RAW" \
            -v p="$(safe_read "$BAT_PATH/power_now" 0)" \
            'BEGIN {printf "%.2f %.2f %.2f %.2f %.2f", e/1e6, ef/1e6, ed/1e6, v/1e6, p/1e6}'
    )
elif [[ -f $BAT_PATH/charge_now ]]; then
    read -r ENERGY ENERGY_FULL ENERGY_DESIGN VOLTAGE RATE < <(
        awk -v cn="$(safe_read "$BAT_PATH/charge_now" 0)" \
            -v cf="$(safe_read "$BAT_PATH/charge_full" 0)" \
            -v cd="$(safe_read "$BAT_PATH/charge_full_design" 0)" \
            -v v="$VOLTAGE_RAW" \
            -v c="$(safe_read "$BAT_PATH/current_now" 0)" \
            'BEGIN {
                if(v==0){print "0 0 0 0 0"; exit}
                printf "%.2f %.2f %.2f %.2f %.2f", cn*v/1e12, cf*v/1e12, cd*v/1e12, v/1e6, c*v/1e12
            }'
    )
else
    ENERGY="N/A" ENERGY_FULL="N/A" ENERGY_DESIGN="N/A" RATE="N/A"
    VOLTAGE=$(awk "BEGIN{printf \"%.2f\", $VOLTAGE_RAW/1e6}")
fi

# Temperature (single read + awk)
[[ -f $BAT_PATH/temp ]] && TEMPERATURE=$(awk "BEGIN{printf \"%.1f\", $(< "$BAT_PATH/temp")/10}") || TEMPERATURE="N/A"

TIME_UNTIL=$(get_time_remaining)
BATTERY_BAR=$(generate_battery_bar $BATTERY)

# Build output - single string construction
typeset INFO="" MORE_INFO=""
(( $+commands[xfce4-power-manager-settings] )) && \
    INFO="<txtclick>xfce4-power-manager-settings</txtclick><click>xfce4-power-manager-settings</click>"

INFO+="<txt>"
typeset GRAY="#808080"
case $BAT_STATUS in
    Charging)
        INFO+="<span weight='Bold' fgcolor='Cyan'>[${BATTERY_BAR}]</span>" ;;
    Full|"Not charging")
        INFO+="<span weight='Bold' fgcolor='Light Green'>[${BATTERY_BAR}]</span>" ;;
    Discharging)
        typeset c="White" w="" bg=""
        (( BATTERY < 10 ))  && { c="White"; w=" weight='Bold'"; bg=" bgcolor='Red'"; }  ||
        (( BATTERY < 25 ))  && c="Red" ||
        (( BATTERY < 50 ))  && c="Yellow"
        INFO+="<span fgcolor='$GRAY'>[</span><span${w} fgcolor='$c'${bg}>${BATTERY_BAR}</span><span fgcolor='$GRAY'>]</span>" ;;
    *)
        INFO+="<span weight='Bold' fgcolor='Yellow'>[${BATTERY_BAR}]</span>" ;;
esac
INFO+="</txt>"

# Tooltip - use single heredoc-style construction
MORE_INFO="<tool>┌ ${MANUFACTURER} ${MODEL}"
[[ $SERIAL_NUMBER != N/A ]] && MORE_INFO+="\n├─ Serial number: $SERIAL_NUMBER"
MORE_INFO+="\n├─ Technology: $TECHNOLOGY"
[[ $TEMPERATURE != N/A ]] && MORE_INFO+="\n├─ Temperature: +${TEMPERATURE}℃"
MORE_INFO+="\n├─ Status: $BAT_STATUS\n├─ Capacity: ${BATTERY}%"
MORE_INFO+="\n├─ Energy: $ENERGY Wh\n├─ Energy when full: $ENERGY_FULL Wh"
MORE_INFO+="\n├─ Energy (design): $ENERGY_DESIGN Wh\n├─ Rate: $RATE W"

case $BAT_STATUS in
    Discharging) MORE_INFO+="\n└─ Remaining: $TIME_UNTIL" ;;
    Charging)    MORE_INFO+="\n└─ Time to full: $TIME_UNTIL" ;;
    *)           MORE_INFO+="\n└─ Voltage: $VOLTAGE V" ;;
esac
MORE_INFO+="</tool>"

print -l -- "$INFO" "$MORE_INFO"
