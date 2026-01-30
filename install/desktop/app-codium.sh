#!/bin/bash

if [[ "$CODIUM_REMOVE_SNAP" == true ]]; then
  if snap list codium >/dev/null 2>&1; then
    sudo snap remove codium
  fi
fi

arch="$(dpkg --print-architecture)"
case "$arch" in
  amd64) codium_arch="x64" ;;
  arm64) codium_arch="arm64" ;;
  armhf) codium_arch="armhf" ;;
  *)
    echo "Unsupported architecture for VSCodium: $arch"
    exit 1
    ;;
esac

deb_name="VSCodium-linux-${codium_arch}.deb"
deb_url="https://github.com/VSCodium/vscodium/releases/latest/download/${deb_name}"

tmp_dir="$(mktemp -d)"
deb_path="$tmp_dir/$deb_name"

curl -fL "$deb_url" -o "$deb_path"
sudo apt update
sudo dpkg -i "$deb_path"
sudo apt-get install -f -y
rm -rf "$tmp_dir"

# Configure VSCodium settings (fonts for Nerd Font icons)
mkdir -p ~/.config/VSCodium/User

OMAKUB_PATH="${OMAKUB_PATH:-${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub}}"
if [ -f "$OMAKUB_PATH/configs/codium/settings.json" ]; then
  if [ -f "$HOME/.config/VSCodium/User/settings.json" ]; then
    # Merge settings - update font-related settings
    echo "Updating VSCodium font settings..."

    # Backup existing settings
    if [[ "$AUTO_BACKUP" == true ]]; then
      backup_config "$HOME/.config/VSCodium/User/settings.json"
    fi

    # Use jq to merge if available, otherwise use Python
    if command -v jq >/dev/null 2>&1; then
      jq -s '.[0] * .[1]' "$HOME/.config/VSCodium/User/settings.json" "$OMAKUB_PATH/configs/codium/settings.json" > /tmp/codium-settings-merged.json
      mv /tmp/codium-settings-merged.json "$HOME/.config/VSCodium/User/settings.json"
      echo "✓ VSCodium settings merged"
    else
      # Fallback: just copy font settings
      cp "$OMAKUB_PATH/configs/codium/settings.json" "$HOME/.config/VSCodium/User/settings.json"
      echo "✓ VSCodium settings updated"
    fi
  else
    # No existing settings, just copy
    cp "$OMAKUB_PATH/configs/codium/settings.json" "$HOME/.config/VSCodium/User/settings.json"
    echo "✓ VSCodium settings installed"
  fi
fi

if [ -f "$OMAKUB_PATH/themes/set-vscode-theme.sh" ] && [[ -n "${OMAKUB_THEME:-}" ]]; then
  source "$OMAKUB_PATH/themes/set-vscode-theme.sh" "$OMAKUB_THEME" || true
fi

echo "✓ VSCodium installed with Nerd Font support"
