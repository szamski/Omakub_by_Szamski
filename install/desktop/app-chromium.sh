#!/bin/bash

if snap list chromium >/dev/null 2>&1; then
  sudo snap remove chromium
fi

sudo add-apt-repository -y ppa:chromium-team/stable
sudo apt update
sudo apt install -y chromium-browser
xdg-settings set default-web-browser chromium-browser.desktop
