#!/bin/bash

sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)

autostart_dir="$HOME/.config/autostart"
autostart_file="$autostart_dir/nordvpn.desktop"

if command -v nordvpn-app >/dev/null 2>&1 || command -v nordvpn >/dev/null 2>&1; then
  mkdir -p "$autostart_dir"
  cat >"$autostart_file" <<'EOF'
[Desktop Entry]
Type=Application
Name=NordVPN
Exec=sh -c 'if command -v nordvpn-app >/dev/null 2>&1; then exec nordvpn-app --background; elif nordvpn --help 2>&1 | grep -q -- "--background"; then exec nordvpn --background; elif nordvpn --help 2>&1 | grep -q -- "--tray"; then exec nordvpn --tray; else exec nordvpn; fi'
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=5
NoDisplay=true
EOF
fi
