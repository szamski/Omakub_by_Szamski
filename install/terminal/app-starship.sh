#!/bin/bash

source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"

# Install Starship prompt via official installer
if ! command -v starship >/dev/null 2>&1; then
  echo "Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  echo "Done: Starship installed"
fi

# Configure using smart install
install_config "$OMAKUB_SZAMSKI_PATH/configs/starship.toml" "$HOME/.config/starship.toml" "Starship"

# Theme setup
if [[ -n "${OMAKUB_THEME:-}" ]]; then
  source "$OMAKUB_SZAMSKI_PATH/themes/set-starship-theme.sh" "$OMAKUB_THEME"
fi
