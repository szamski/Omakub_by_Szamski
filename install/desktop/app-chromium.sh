#!/bin/bash

# Install Chromium via Flatpak with Google account support

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

# Install Chromium Flatpak if not present
if ! flatpak info org.chromium.Chromium >/dev/null 2>&1; then
  echo "Installing Chromium (Flatpak)..."
  flatpak install -y flathub org.chromium.Chromium
else
  echo "⏭️  Chromium Flatpak already installed, configuring..."
fi

# Reset overrides to avoid stale config
flatpak override --user --reset org.chromium.Chromium >/dev/null 2>&1 || true

# Set Google OAuth env for sync/login support
flatpak override --user \
  --env=GOOGLE_DEFAULT_CLIENT_ID=77185425430.apps.googleusercontent.com \
  --env=GOOGLE_DEFAULT_CLIENT_SECRET=OTJgUOQcT7lO7GsGZq2G4IlT \
  org.chromium.Chromium

# Optional Google API key (usually not required)
# flatpak override --user --env=GOOGLE_API_KEY=77185425430.apps.googleusercontent.com org.chromium.Chromium

# Set as default browser
xdg-settings set default-web-browser org.chromium.Chromium.desktop 2>/dev/null || true

echo "✓ Chromium installed and configured (Flatpak)"
