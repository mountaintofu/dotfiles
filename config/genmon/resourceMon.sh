#!/usr/bin/env bash

# Interface to monitor (change to your main interface)
IFACE="eth0"

# State files for delta calculations
CPU_STATE="/tmp/genmon_cpu_state"
NET_STATE="/tmp/genmon_net_state_${IFACE}"

# Max network speed in Mbps for percentage calculation
MAX_MBPS=100

# -----------------------------------------------------------
# Helper: map a 0–100 value to green→yellow→red
# -----------------------------------------------------------
color_for_percent() {
    local p=$1
    if   [ "$p" -le 50 ]; then
        echo "#FFFFFF"
    elif [ "$p" -le 80 ]; then
        echo "#FFBA00"
    else
        echo "#F7768E"
    fi
}

# -----------------------------------------------------------
# CPU usage (using state file for delta, no sleep)
# -----------------------------------------------------------
cpu_line=$(grep '^cpu ' /proc/stat)
cpu_user2=$(echo "$cpu_line" | awk '{print $2}')
cpu_nice2=$(echo "$cpu_line" | awk '{print $3}')
cpu_sys2=$(echo "$cpu_line" | awk '{print $4}')
cpu_idle2=$(echo "$cpu_line" | awk '{print $5}')

cpu_total2=$((cpu_user2 + cpu_nice2 + cpu_sys2 + cpu_idle2))

if [ -f "$CPU_STATE" ]; then
    read -r cpu_total1 cpu_idle1 < "$CPU_STATE"
else
    cpu_total1=$cpu_total2
    cpu_idle1=$cpu_idle2
fi

echo "$cpu_total2 $cpu_idle2" > "$CPU_STATE"

cpu_delta_total=$((cpu_total2 - cpu_total1))
cpu_delta_idle=$((cpu_idle2 - cpu_idle1))

if [ "$cpu_delta_total" -gt 0 ]; then
    cpu_used=$((100 * (cpu_delta_total - cpu_delta_idle) / cpu_delta_total))
else
    cpu_used=0
fi

# Clamp values
[ "$cpu_used" -lt 0 ] && cpu_used=0
[ "$cpu_used" -gt 100 ] && cpu_used=100

cpu_color=$(color_for_percent "$cpu_used")

# -----------------------------------------------------------
# RAM percentage
# -----------------------------------------------------------
mem_total_kb=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
mem_avail_kb=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)

if [ -n "$mem_total_kb" ] && [ "$mem_total_kb" -gt 0 ]; then
    mem_used_percent=$(( (100 * (mem_total_kb - mem_avail_kb)) / mem_total_kb ))
else
    mem_used_percent=0
fi

[ "$mem_used_percent" -lt 0 ] && mem_used_percent=0
[ "$mem_used_percent" -gt 100 ] && mem_used_percent=100

mem_color=$(color_for_percent "$mem_used_percent")

# -----------------------------------------------------------
# Swap percentage
# -----------------------------------------------------------
swap_total_kb=$(awk '/^SwapTotal:/ {print $2}' /proc/meminfo)
swap_free_kb=$(awk '/^SwapFree:/ {print $2}' /proc/meminfo)

if [ -n "$swap_total_kb" ] && [ "$swap_total_kb" -gt 0 ]; then
    swap_used_percent=$(( (100 * (swap_total_kb - swap_free_kb)) / swap_total_kb ))
else
    swap_used_percent=0
fi

[ "$swap_used_percent" -lt 0 ] && swap_used_percent=0
[ "$swap_used_percent" -gt 100 ] && swap_used_percent=100

swap_color=$(color_for_percent "$swap_used_percent")

# -----------------------------------------------------------
# Network load (using state file, no sleep)
# -----------------------------------------------------------
net_used_percent=0

if [ -d "/sys/class/net/$IFACE" ]; then
    rx_bytes2=$(cat "/sys/class/net/$IFACE/statistics/rx_bytes" 2>/dev/null || echo 0)
    tx_bytes2=$(cat "/sys/class/net/$IFACE/statistics/tx_bytes" 2>/dev/null || echo 0)
    timestamp2=$(date +%s%N)

    if [ -f "$NET_STATE" ]; then
        read -r rx_bytes1 tx_bytes1 timestamp1 < "$NET_STATE"
        
        time_delta=$(( (timestamp2 - timestamp1) / 1000000 ))  # ms
        
        if [ "$time_delta" -gt 0 ]; then
            rx_bps=$(( (rx_bytes2 - rx_bytes1) * 1000 / time_delta ))
            tx_bps=$(( (tx_bytes2 - tx_bytes1) * 1000 / time_delta ))
            
            rx_mbps=$(( rx_bps * 8 / 1000000 ))
            tx_mbps=$(( tx_bps * 8 / 1000000 ))
            
            if [ "$rx_mbps" -gt "$tx_mbps" ]; then
                net_mbps=$rx_mbps
            else
                net_mbps=$tx_mbps
            fi
            
            if [ "$net_mbps" -gt 0 ]; then
                net_used_percent=$(( 100 * net_mbps / MAX_MBPS ))
            fi
        fi
    fi
    
    echo "$rx_bytes2 $tx_bytes2 $timestamp2" > "$NET_STATE"
fi

[ "$net_used_percent" -lt 0 ] && net_used_percent=0
[ "$net_used_percent" -gt 100 ] && net_used_percent=100

net_color=$(color_for_percent "$net_used_percent")

# -----------------------------------------------------------
# Output for GenMon
# -----------------------------------------------------------
echo "<txt> | <span foreground=\"${cpu_color}\">CPU ${cpu_used}%</span> | <span foreground=\"${mem_color}\">RAM ${mem_used_percent}%</span> | <span foreground=\"${swap_color}\">SWP ${swap_used_percent}%</span> | <span foreground=\"${net_color}\">NET ${net_used_percent}%</span> | </txt>"
