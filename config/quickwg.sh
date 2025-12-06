#!/bin/bash

# Function to connect
connect_to() {
    sudo resolvconf -u
    sudo wg-quick up "$1"
}

# Function to disconnect
disconnect() {
    sudo wg-quick down "$1"
    sudo systemctl restart NetworkManager
}

# Function to switch servers
switch_to() {
    echo "Switching from $SERVER_NAME to $1..."
    sudo wg-quick down "$SERVER_NAME"
    sudo resolvconf -u
    sudo wg-quick up "$1"
}

# Detect current VPN server
SERVER_NAME=$(sudo wg show interfaces 2>/dev/null)

if [ -z "$SERVER_NAME" ]; then
    SERVER_NAME="none"
fi

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
    "1") 
        target="wg-JP-FREE-34"
        ;;
    "2") 
        target="wg-US-FREE-112"
        ;;
    "3") 
        target="wg-NL-FREE-255"
        ;;
    "4") 
        if [ "$SERVER_NAME" != "none" ]; then
            disconnect "$SERVER_NAME"
            echo "Disconnected."
        else
            echo "No VPN currently active."
        fi
        exit
        ;;
    *) 
        exit
        ;;
esac

# Handle connection/switching logic
if [ "$SERVER_NAME" = "none" ]; then
    echo "Connecting to $target..."
    connect_to "$target"
elif [ "$SERVER_NAME" = "$target" ]; then
    echo "Already connected to $target."
else
    switch_to "$target"
fi

# Show final status
echo ""
echo "Status:"
sudo wg show