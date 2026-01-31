#!/bin/bash

source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"

# Skip if btop is already installed
if command -v btop >/dev/null 2>&1; then
  echo "Skip: btop already installed"
else
  sudo apt install -y btop
fi

mkdir -p ~/.config/btop/themes
cp "$OMAKUB_SZAMSKI_PATH/themes/catppuccin/btop.theme" ~/.config/btop/themes/catppuccin.theme

install_config "$OMAKUB_SZAMSKI_PATH/configs/btop.conf" "$HOME/.config/btop/btop.conf" "btop"
