#!/bin/bash

# Check if Starship is already installed AND configured - skip if both are done
if command -v starship >/dev/null 2>&1 && [ -f "$HOME/.config/starship.toml" ]; then
  echo "⏭️  Starship already installed and configured, skipping..."
  return 0
fi

# Install Starship prompt via official installer (not apt/pacman)
if ! command -v starship >/dev/null 2>&1; then
  echo "Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  echo "✓ Starship installed"
else
  echo "✓ Starship already installed"
fi

mkdir -p ~/.config

# Copy configuration
if [ -f "$HOME/.config/starship.toml" ]; then
  if [[ "$AUTO_BACKUP" == true ]]; then
    backup_config "$HOME/.config/starship.toml"
    cp "$OMAKUB_SZAMSKI_PATH/configs/starship.toml" ~/.config/starship.toml
    echo "✓ Starship config updated (backup created)"
  else
    echo "⏭️  Starship config already exists (skipping update)"
  fi
else
  cp "$OMAKUB_SZAMSKI_PATH/configs/starship.toml" ~/.config/starship.toml
  echo "✓ Starship config installed"
fi

echo "✓ Starship configured with Catppuccin theme"
