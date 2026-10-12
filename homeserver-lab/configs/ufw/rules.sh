#!/usr/bin/env bash
# UFW rules for homeserver. Run with sudo.
# Keep an SSH session open while applying, and test from a new terminal.
set -euo pipefail

ufw default deny incoming
ufw default allow outgoing

# SSH: home LAN, host-only link, VirtualBox NAT (when away from home)
ufw allow from 10.0.0.0/24     to any port 22  proto tcp
ufw allow from 192.168.56.0/24 to any port 22  proto tcp
ufw allow from 10.0.2.0/24     to any port 22  proto tcp

# Samba: home LAN and host-only link
ufw allow from 10.0.0.0/24     to any port 445 proto tcp
ufw allow from 192.168.56.0/24 to any port 445 proto tcp

# WireGuard
ufw allow 51820/udp

# SSH and Samba over the VPN: my phone only (other peers get Jellyfin only)
ufw allow from 10.8.0.2 to any port 22  proto tcp
ufw allow from 10.8.0.2 to any port 445 proto tcp

ufw enable
ufw status numbered

# NOTE: Docker-published ports (Jellyfin, Pi-hole) bypass these rules.
# Control their exposure by binding them to specific addresses in compose.yaml.
