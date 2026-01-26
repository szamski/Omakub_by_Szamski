#!/bin/bash

# Skip if btop is already installed
if command -v btop >/dev/null 2>&1; then
  echo "⏭️  btop already installed, skipping..."
  return 0
fi

sudo apt install -y btop

mkdir -p ~/.config/btop/themes
cp "$OMAKUB_SZAMSKI_PATH/themes/catppuccin/btop.theme" ~/.config/btop/themes/catppuccin.theme

if [ -f "$HOME/.config/btop/btop.conf" ]; then
  if [[ "$AUTO_BACKUP" == true ]]; then
    backup_config "$HOME/.config/btop/btop.conf"
    cp "$OMAKUB_SZAMSKI_PATH/configs/btop.conf" ~/.config/btop/btop.conf
  fi
else
  cp "$OMAKUB_SZAMSKI_PATH/configs/btop.conf" ~/.config/btop/btop.conf
fi
