#!/bin/bash

# Install gum - interactive UI tool for shell scripts
if command -v gum >/dev/null 2>&1; then
  echo "Skip: gum already installed"
else
  echo "Installing gum..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
  sudo apt update
  sudo apt install -y gum
  echo "Done: gum installed"
fi
