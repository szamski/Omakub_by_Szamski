#!/bin/bash

if ! command -v starship >/dev/null 2>&1; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

mkdir -p ~/.config

if [ -f "$HOME/.config/starship.toml" ]; then
  if [[ "$AUTO_BACKUP" == true ]]; then
    backup_config "$HOME/.config/starship.toml"
    cp "$OMAKUB_SZAMSKI_PATH/configs/starship.toml" ~/.config/starship.toml
  fi
else
  cp "$OMAKUB_SZAMSKI_PATH/configs/starship.toml" ~/.config/starship.toml
fi
