#!/bin/sh

# Paranoid profile, outgoing whitelist

ufw --force reset
ufw default deny incoming
ufw default deny outgoing
ufw logging high

# Essential outgoing
ufw allow out 53      # DNS
ufw allow out 80/tcp  # HTTP
ufw allow out 443/tcp # HTTPS
ufw allow out 123/udp # NTP
ufw allow out 67/udp  # DHCP
ufw allow out 68/udp  # DHCP

# Email (uncomment if needed)
# ufw allow out 587/tcp # SMTP submission
# ufw allow out 993/tcp # IMAPS
# ufw allow out 995/tcp # POP3S

# Git (uncomment if needed)
# ufw allow out 22/tcp  # SSH/Git
# ufw allow out 9418/tcp # Git protocol

ufw --force enable