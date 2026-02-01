#!/bin/bash

source "$SIMPLE_PATH/lib/utils.sh"

# Install Starship prompt via official installer
if ! command -v starship >/dev/null 2>&1; then
  echo "Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  echo "Done: Starship installed"
fi

# Configure using smart install
install_config "$SIMPLE_PATH/configs/starship.toml" "$HOME/.config/starship.toml" "Starship"
