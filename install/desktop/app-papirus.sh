#!/bin/bash

# Skip if papirus-folders is already installed
if command -v papirus-folders >/dev/null 2>&1; then
  echo "Skip: papirus-folders already installed"
  return 0
fi

echo "Installing Papirus icon theme and folders..."
sudo add-apt-repository -y ppa:papirus/papirus
sudo apt update
sudo apt install -y papirus-icon-theme papirus-folders

echo "Done: Papirus icon theme installed"
