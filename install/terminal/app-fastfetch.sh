#!/bin/bash

source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"

# Skip if fastfetch is already installed
if command -v fastfetch >/dev/null 2>&1; then
  echo "Skip: fastfetch already installed"
else
  sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
  sudo apt update -y
  sudo apt install -y fastfetch
fi

mkdir -p ~/.config/fastfetch
install_config "$OMAKUB_SZAMSKI_PATH/configs/fastfetch.jsonc" "$HOME/.config/fastfetch/config.jsonc" "Fastfetch"
