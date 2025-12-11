#!/bin/sh

# Paranoid profile, outgoing whitelist

ufw --force reset
ufw default deny incoming
ufw default deny outgoing
ufw logging high

# Essential outgoing
ufw allow out 53/tcp  # DNS (large queries/DNSSEC)
ufw allow out 53/udp  # DNS
ufw allow out 80/tcp  # HTTP
ufw allow out 443/tcp # HTTPS
ufw allow out 123/udp # NTP

# DHCP
ufw allow out 67/udp
ufw allow out 68/udp

# OpenVPN
# ufw allow out 1194/udp  # OpenVPN default
# ufw allow out 1194/tcp  # OpenVPN TCP fallback
# (TCP/443 already allowed above - common for OpenVPN)

# WireGuard
ufw allow out 51820/udp

# IKEv2 / IPSec
# ufw allow out 500/udp   # IKE
# ufw allow out 4500/udp  # NAT-Traversal (ESP over UDP)

# L2TP/IPSec (uncomment if needed)
# ufw allow out 1701/udp

# VPN Tunnel Interfaces (traffic after connection)
# ufw allow out on tun0  # OpenVPN tunnel
# ufw allow out on tun+  # Any tun interface
ufw allow out on wg0   # WireGuard tunnel
ufw allow out on wg+   # Any wg interface

ufw --force enable
