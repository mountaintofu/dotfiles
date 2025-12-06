!/usr/bin/env zsh

# detect_timezone() {
#     # Try multiple methods in order of preference
#     local tz
    
#     # Method 1: timedatectl (systemd)
#     tz=$(timedatectl show -p Timezone --value 2>/dev/null)
#     [[ -n "$tz" ]] && echo "$tz" && return
    
#     # Method 2: /etc/timezone file
#     tz=$(cat /etc/timezone 2>/dev/null)
#     [[ -n "$tz" ]] && echo "$tz" && return
    
#     # Method 3: /etc/localtime symlink
#     tz=$(readlink -f /etc/localtime 2>/dev/null | sed 's|.*/zoneinfo/||')
#     [[ -n "$tz" ]] && echo "$tz" && return
    
#     # Method 4: Check TZ environment variable
#     [[ -n "$TZ" ]] && echo "$TZ" && return
    
#     # Fallback
#     echo "UTC"
# }

# # Set and export timezone
# export TZ=$(detect_timezone)

# # Get time with explicit timezone
# TIME_NOW=$(TZ="$TZ" date '+%H:%M')

TIME_NOW=$(date '+%H:%M')

echo "<txt>${TIME_NOW}</txt>"
echo '<css>.genmon_value{color:#ffffff;padding:0 10px;}</css>'

# Output
echo "<txt>\ue383 ${TIME_NOW}</txt>"
echo '<css>.genmon_value{color:#ffffff;padding:0 10px;}</css>'
