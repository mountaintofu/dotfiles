#!/bin/sh

# ─────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────

SERVERS="
jp:wg-JP-FREE-34:Japan
us:wg-US-FREE-112:United States
nl:wg-NL-FREE-255:Netherlands
"

# ─────────────────────────────────────────────
# Functions
# ─────────────────────────────────────────────

get_current() {
    sudo wg show interfaces 2>/dev/null
}

connect_to() {
    sudo resolvconf -u
    sudo wg-quick up "$1"
}

disconnect() {
    sudo wg-quick down "$1"
    sudo systemctl restart NetworkManager
}

switch_to() {
    current=$(get_current)
    echo "Switching from $current to $1..."
    sudo wg-quick down "$current"
    sudo resolvconf -u
    sudo wg-quick up "$1"
}

# Resolve short code to full config name
resolve_server() {
    code=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    echo "$SERVERS" | while IFS=: read -r short full name; do
        [ "$short" = "$code" ] && echo "$full" && return
    done
}

# Handle connection logic
handle_connect() {
    target="$1"
    current=$(get_current)
    
    if [ -z "$current" ]; then
        echo "Connecting to $target..."
        connect_to "$target"
    elif [ "$current" = "$target" ]; then
        echo "Already connected to $target."
        return
    else
        switch_to "$target"
    fi
    
    echo ""
    echo "✓ Connected"
    sudo wg show "$target" | head -6
}

show_status() {
    current=$(get_current)
    if [ -z "$current" ]; then
        echo "VPN: Disconnected"
    else
        echo "VPN: $current"
        echo ""
        sudo wg show
    fi
}

show_help() {
    echo "Usage: $(basename "$0") [command]"
    echo ""
    echo "Commands:"
    echo "  jp, us, nl    Connect to server"
    echo "  stop, down    Disconnect VPN"
    echo "  status, s     Show connection status"
    echo "  list, ls      List available servers"
    echo "  help, -h      Show this help"
    echo ""
    echo "No arguments starts interactive mode."
}

list_servers() {
    echo "Available servers:"
    echo "$SERVERS" | while IFS=: read -r short full name; do
        [ -n "$short" ] && printf "  %-6s %s\n" "$short" "$name"
    done
}

# ─────────────────────────────────────────────
# CLI Argument Handling
# ─────────────────────────────────────────────

if [ -n "$1" ]; then
    case "$1" in
        stop|down|d)
            current=$(get_current)
            if [ -n "$current" ]; then
                disconnect "$current"
                echo "✓ Disconnected from $current"
            else
                echo "No VPN currently active."
            fi
            ;;
        status|s)
            show_status
            ;;
        list|ls)
            list_servers
            ;;
        help|-h|--help)
            show_help
            ;;
        *)
            target=$(resolve_server "$1")
            if [ -n "$target" ]; then
                handle_connect "$target"
            else
                echo "Unknown server: $1"
                echo "Run '$(basename "$0") list' to see available servers."
                exit 1
            fi
            ;;
    esac
    exit
fi

# ─────────────────────────────────────────────
# Interactive Mode (no arguments)
# ─────────────────────────────────────────────

SERVER_NAME=$(get_current)
[ -z "$SERVER_NAME" ] && SERVER_NAME="none"

echo "==============================
  ProtonVPN WireGuard Manager
==============================
Current connection: $SERVER_NAME

1. JP  (Japan)
2. US  (United States)
3. NL  (Netherlands)
4. Stop VPN
5. Exit
==============================
"

read -rp "Choose an option: " server_of_choice

case $server_of_choice in
    1) target="wg-JP-FREE-34" ;;
    2) target="wg-US-FREE-112" ;;
    3) target="wg-NL-FREE-255" ;;
    4)
        if [ "$SERVER_NAME" != "none" ]; then
            disconnect "$SERVER_NAME"
            echo "Disconnected."
        else
            echo "No VPN currently active."
        fi
        exit
        ;;
    *) exit ;;
esac

handle_connect "$target"
