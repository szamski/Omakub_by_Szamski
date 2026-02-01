#!/bin/bash

# Skip if gh is already installed
if command -v gh >/dev/null 2>&1; then
  echo "Skip: GitHub CLI already installed"
  return 0
fi

echo "Installing GitHub CLI..."
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
# Force apt update after adding GitHub CLI repository
sudo apt update -y
export APT_UPDATED=true
sudo apt install gh -y
