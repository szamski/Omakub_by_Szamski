#!/bin/bash

# Install 1Password GUI
cd /tmp
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb -O 1password.deb
sudo apt install -y ./1password.deb
rm 1password.deb

# Install 1Password CLI
if ! command -v op >/dev/null 2>&1; then
  echo "Installing 1Password CLI..."
  wget https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-amd64-latest.deb -O 1password-cli.deb
  sudo apt install -y ./1password-cli.deb
  rm 1password-cli.deb
fi

cd - >/dev/null

echo "✓ 1Password and 1Password CLI installed"
