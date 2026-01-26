#!/bin/bash

if [[ "$VSCODE_REMOVE_SNAP" == true ]]; then
  if snap list code >/dev/null 2>&1; then
    sudo snap remove code
  fi
fi

if [ ! -f /etc/apt/keyrings/packages.microsoft.gpg ]; then
  cd /tmp
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  rm -f packages.microsoft.gpg
  cd - >/dev/null
fi

sudo apt update
sudo apt install -y code

# Configure VS Code settings (fonts for Nerd Font icons)
mkdir -p ~/.config/Code/User

if [ -f "$OMAKUB_SZAMSKI_PATH/configs/vscode/settings.json" ]; then
  if [ -f "$HOME/.config/Code/User/settings.json" ]; then
    # Merge settings - update font-related settings
    echo "Updating VS Code font settings..."
    
    # Backup existing settings
    if [[ "$AUTO_BACKUP" == true ]]; then
      backup_config "$HOME/.config/Code/User/settings.json"
    fi
    
    # Use jq to merge if available, otherwise use Python
    if command -v jq >/dev/null 2>&1; then
      jq -s '.[0] * .[1]' "$HOME/.config/Code/User/settings.json" "$OMAKUB_SZAMSKI_PATH/configs/vscode/settings.json" > /tmp/vscode-settings-merged.json
      mv /tmp/vscode-settings-merged.json "$HOME/.config/Code/User/settings.json"
      echo "✓ VS Code settings merged"
    else
      # Fallback: just copy font settings
      cp "$OMAKUB_SZAMSKI_PATH/configs/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
      echo "✓ VS Code settings updated"
    fi
  else
    # No existing settings, just copy
    cp "$OMAKUB_SZAMSKI_PATH/configs/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
    echo "✓ VS Code settings installed"
  fi
fi

echo "✓ VS Code installed with Nerd Font support"
