#!/bin/bash

source "$SIMPLE_PATH/lib/utils.sh"

# Skip if mise is already installed
if command -v mise >/dev/null 2>&1; then
  echo "Skip: mise already installed"
else
  apt_update_once
  sudo apt install -y gpg wget curl
  sudo install -dm 755 /etc/apt/keyrings
  wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1>/dev/null
  echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
  # Force apt update after adding mise repository
  sudo apt update -y
  export APT_UPDATED=true
  sudo apt install -y mise
fi

mkdir -p ~/.config/mise

echo "Done: mise configured"
