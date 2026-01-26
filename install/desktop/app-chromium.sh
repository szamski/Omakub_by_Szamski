#!/bin/bash

# Check if Chromium is already installed (skip if found)
if command -v chromium-browser >/dev/null 2>&1 || command -v chromium >/dev/null 2>&1; then
  echo "⏭️  Chromium already installed, skipping..."
  return 0
fi

# Remove snap version if exists
if snap list chromium >/dev/null 2>&1; then
  echo "Removing snap version of Chromium..."
  sudo snap remove chromium
fi

# Add PPA and install from apt (better performance than snap)
echo "Installing Chromium..."
sudo add-apt-repository -y ppa:chromium-team/stable
sudo apt update
sudo apt install -y chromium-browser || {
  echo "Failed to install chromium-browser, trying chromium..."
  sudo apt install -y chromium
}

# Set as default browser
xdg-settings set default-web-browser chromium-browser.desktop 2>/dev/null || \
  xdg-settings set default-web-browser chromium.desktop 2>/dev/null || true

echo "✓ Chromium installed"
