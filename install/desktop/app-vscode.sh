#!/bin/bash

source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"

# Consistency check
ensure_no_snap "code"
ensure_no_flatpak "com.visualstudio.code"

# Check if VS Code (.deb) is already installed
if command -v code >/dev/null 2>&1; then
  echo "Skip: VS Code already installed"
else
  # Download and install VS Code .deb
  echo "Installing VS Code..."
  cd /tmp
  wget -qO vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
  sudo dpkg -i vscode.deb
  sudo apt-get install -f -y
  rm vscode.deb
  cd - >/dev/null
fi

# Configure settings (fonts etc)
# Note: We are using the config from codium for now as they are compatible
OMAKUB_PATH="${OMAKUB_PATH:-${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub}}"
SETTINGS_SOURCE="$OMAKUB_PATH/configs/codium/settings.json"
TARGET_FILE="$HOME/.config/Code/User/settings.json"

if [ -f "$SETTINGS_SOURCE" ]; then
  # Use smart config install
  install_config "$SETTINGS_SOURCE" "$TARGET_FILE" "VS Code Settings"
fi

if [ -f "$OMAKUB_PATH/themes/set-vscode-theme.sh" ] && [[ -n "${OMAKUB_THEME:-}" ]]; then
  source "$OMAKUB_PATH/themes/set-vscode-theme.sh" "$OMAKUB_THEME" || true
fi

echo "Done: VS Code configured"
