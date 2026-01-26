#!/bin/bash

set -euo pipefail

# Install GNOME Software with Flatpak and Snap integration
sudo apt install -y gnome-software gnome-software-plugin-flatpak gnome-software-plugin-snap flatpak

if ! flatpak remote-list | awk '{print $1}' | grep -qx "flathub"; then
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Remove Snap Store (GNOME Software will handle snaps)
sudo snap remove snap-store >/dev/null 2>&1 || true
sudo apt remove -y snap-store >/dev/null 2>&1 || true
