#!/bin/bash

if command -v ulauncher >/dev/null 2>&1; then
  mkdir -p ~/.config/autostart
  if [ ! -f ~/.config/autostart/ulauncher.desktop ]; then
    cp /usr/share/applications/ulauncher.desktop ~/.config/autostart/ulauncher.desktop 2>/dev/null || true
  fi
echo "Done: Ulauncher already installed"
  return 0
fi

sudo add-apt-repository universe -y
sudo add-apt-repository ppa:agornostal/ulauncher -y
sudo apt update
sudo apt install -y ulauncher

mkdir -p ~/.config/autostart
cp /usr/share/applications/ulauncher.desktop ~/.config/autostart/ulauncher.desktop 2>/dev/null || true
