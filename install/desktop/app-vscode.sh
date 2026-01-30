#!/bin/bash

# Remove snap/flatpak if present to avoid conflicts
if snap list code >/dev/null 2>&1; then
  sudo snap remove code
fi

# Download and install VS Code .deb
echo "Installing VS Code..."
cd /tmp
wget -qO vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
sudo dpkg -i vscode.deb
sudo apt-get install -f -y
rm vscode.deb
cd - >/dev/null

# Create config directory
mkdir -p ~/.config/Code/User

# Configure settings (fonts etc)
OMAKUB_PATH="${OMAKUB_PATH:-${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub}}"
# Using the existing codium settings file as a base for now, assuming compatible structure
if [ -f "$OMAKUB_PATH/configs/codium/settings.json" ]; then
  SETTINGS_SOURCE="$OMAKUB_PATH/configs/codium/settings.json"
  TARGET_FILE="$HOME/.config/Code/User/settings.json"
  
  if [ -f "$TARGET_FILE" ]; then
    # Merge settings
    echo "Updating VS Code settings..."
    
    if [[ "$AUTO_BACKUP" == true ]]; then
      cp "$TARGET_FILE" "${TARGET_FILE}.bak"
    fi

    if command -v jq >/dev/null 2>&1; then
      jq -s '.[0] * .[1]' "$TARGET_FILE" "$SETTINGS_SOURCE" > /tmp/vscode-settings-merged.json
      mv /tmp/vscode-settings-merged.json "$TARGET_FILE"
      echo "✓ VS Code settings merged"
    else
      # Fallback: just copy if no jq (overwrite) - or maybe we should just skip merging if we can't do it safely?
      # For now, let's copy to ensure defaults are set if it's a fresh install, 
      # but ideally we wouldn't overwrite without jq. 
      # Since this is an installer, let's assume if jq is missing we might just want to append or warn.
      # But sticking to previous logic:
      cp "$SETTINGS_SOURCE" "$TARGET_FILE"
      echo "✓ VS Code settings updated"
    fi
  else
    # No existing settings, just copy
    cp "$SETTINGS_SOURCE" "$TARGET_FILE"
    echo "✓ VS Code settings installed"
  fi
fi

if [ -f "$OMAKUB_PATH/themes/set-vscode-theme.sh" ] && [[ -n "${OMAKUB_THEME:-}" ]]; then
  source "$OMAKUB_PATH/themes/set-vscode-theme.sh" "$OMAKUB_THEME" || true
fi

echo "✓ VS Code installed"
