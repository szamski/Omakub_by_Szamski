#!/bin/bash

# Install NordVPN GUI
# Official installer from NordVPN repository

if command -v nordvpn >/dev/null 2>&1; then
  echo "Skip: NordVPN already installed"
  exit 0
fi

echo "Installing NordVPN..."
sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh) -p nordvpn-gui

echo "Done: NordVPN installed"
