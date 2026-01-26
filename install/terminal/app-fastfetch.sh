#!/bin/bash

# Skip if fastfetch is already installed
if command -v fastfetch >/dev/null 2>&1; then
  echo "⏭️  fastfetch already installed, skipping..."
  return 0
fi

sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
sudo apt update -y
sudo apt install -y fastfetch

if [ -f "$HOME/.config/fastfetch/config.jsonc" ]; then
  if [[ "$AUTO_BACKUP" == true ]]; then
    backup_config "$HOME/.config/fastfetch/config.jsonc"
    mkdir -p ~/.config/fastfetch
    cp "$OMAKUB_SZAMSKI_PATH/configs/fastfetch.jsonc" ~/.config/fastfetch/config.jsonc
  fi
else
  mkdir -p ~/.config/fastfetch
  cp "$OMAKUB_SZAMSKI_PATH/configs/fastfetch.jsonc" ~/.config/fastfetch/config.jsonc
fi
