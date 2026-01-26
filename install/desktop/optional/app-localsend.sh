#!/bin/bash

# Install LocalSend via Flatpak

# Ensure flatpak is installed
if ! command -v flatpak >/dev/null 2>&1; then
  echo "Installing Flatpak..."
  sudo apt update
  sudo apt install -y flatpak
fi

# Ensure Flathub is configured
if ! flatpak remote-list | awk '{print $1}' | grep -qx "flathub"; then
  echo "Adding Flathub remote..."
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

if flatpak info org.localsend.localsend_app >/dev/null 2>&1; then
  echo "⏭️  LocalSend already installed, skipping..."
  return 0
fi

echo "Installing LocalSend (Flatpak)..."
flatpak install -y flathub org.localsend.localsend_app

echo "✓ LocalSend installed"
