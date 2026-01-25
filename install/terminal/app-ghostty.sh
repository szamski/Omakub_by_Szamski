#!/bin/bash

if ! command -v ghostty >/dev/null 2>&1; then
  echo "Ghostty is not installed. Install it manually from https://ghostty.org and re-run."
  return 0
fi

mkdir -p ~/.config/ghostty

if [ -f "$HOME/.config/ghostty/config" ]; then
  if [[ "$AUTO_BACKUP" == true ]]; then
    backup_config "$HOME/.config/ghostty/config"
    cp "$OMAKUB_SZAMSKI_PATH/configs/ghostty/config" ~/.config/ghostty/config
  fi
else
  cp "$OMAKUB_SZAMSKI_PATH/configs/ghostty/config" ~/.config/ghostty/config
fi
