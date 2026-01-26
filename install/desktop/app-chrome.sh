#!/bin/bash

# Skip if Chrome is already installed
if command -v google-chrome >/dev/null 2>&1; then
  echo "⏭️  Google Chrome already installed, skipping..."
  return 0
fi

cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
xdg-settings set default-web-browser google-chrome.desktop
cd - >/dev/null
