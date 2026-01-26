#!/bin/bash

# Skip if mise is already installed
if command -v mise >/dev/null 2>&1; then
  echo "⏭️  mise already installed, skipping installation..."
else
  sudo apt update -y && sudo apt install -y gpg wget curl
  sudo install -dm 755 /etc/apt/keyrings
  wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1>/dev/null
  echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
  sudo apt update
  sudo apt install -y mise
fi

# Configure mise - copy config and trust it
mkdir -p ~/.config/mise

# Check if config exists in Work directory
if [ -f "$HOME/Work/.config/mise/config.toml" ]; then
  if [ -f "$HOME/.config/mise/config.toml" ]; then
    if [[ "$AUTO_BACKUP" == true ]]; then
      backup_config "$HOME/.config/mise/config.toml"
      cp "$HOME/Work/.config/mise/config.toml" ~/.config/mise/config.toml
      echo "✓ mise config updated (backup created)"
    else
      echo "✓ mise config already exists (skipping copy)"
    fi
  else
    cp "$HOME/Work/.config/mise/config.toml" ~/.config/mise/config.toml
    echo "✓ mise config copied"
  fi
  
  # Trust the config
  mise trust ~/.config/mise/config.toml 2>/dev/null || true
  echo "✓ mise config trusted"
fi

# Also check project config if exists
if [ -f "$OMAKUB_SZAMSKI_PATH/configs/mise/config.toml" ]; then
  if [ ! -f "$HOME/.config/mise/config.toml" ]; then
    cp "$OMAKUB_SZAMSKI_PATH/configs/mise/config.toml" ~/.config/mise/config.toml
    mise trust ~/.config/mise/config.toml 2>/dev/null || true
    echo "✓ mise config installed from project"
  fi
fi

echo "✓ mise configured"
