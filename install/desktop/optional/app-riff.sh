#!/bin/bash

# Install Riff (Spotify GTK client) via Flatpak and override icon to Spotify

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

# Install Riff
if ! flatpak info dev.diegovsky.Riff >/dev/null 2>&1; then
  echo "Installing Riff (Flatpak)..."
  flatpak install -y flathub dev.diegovsky.Riff
else
  echo "⏭️  Riff already installed, configuring icon..."
fi

# Override icon to Spotify
RIFF_DESKTOP="dev.diegovsky.Riff.desktop"
SYSTEM_DESKTOP="/var/lib/flatpak/exports/share/applications/$RIFF_DESKTOP"
USER_DESKTOP="$HOME/.local/share/flatpak/exports/share/applications/$RIFF_DESKTOP"
LOCAL_DESKTOP="$HOME/.local/share/applications/$RIFF_DESKTOP"

if [[ -f "$SYSTEM_DESKTOP" ]]; then
  mkdir -p "$HOME/.local/share/applications"
  cp "$SYSTEM_DESKTOP" "$LOCAL_DESKTOP"
elif [[ -f "$USER_DESKTOP" ]]; then
  mkdir -p "$HOME/.local/share/applications"
  cp "$USER_DESKTOP" "$LOCAL_DESKTOP"
fi

if [[ -f "$LOCAL_DESKTOP" ]]; then
  if grep -q '^Icon=' "$LOCAL_DESKTOP"; then
    sed -i 's/^Icon=.*/Icon=spotify/' "$LOCAL_DESKTOP"
  else
    echo "Icon=spotify" >> "$LOCAL_DESKTOP"
  fi
  echo "✓ Riff icon set to Spotify"
fi

echo "✓ Riff installed"
