#!/bin/bash

# Skip if Ghostty is already installed
if command -v ghostty >/dev/null 2>&1; then
  echo "⏭️  Ghostty already installed, skipping..."
  # Still configure if config doesn't exist
  if [ -f "$HOME/.config/ghostty/config" ]; then
    return 0
  fi
fi

# Install Ghostty using the Ubuntu community package (no snap/flatpak)
if ! command -v ghostty >/dev/null 2>&1; then
  echo "Installing Ghostty (community Ubuntu package)..."

  if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"; then
    echo "✓ Ghostty installed"
  else
    echo "❌ Ghostty installation failed"
    echo "   Please install manually:"
    echo "   https://github.com/mkasberg/ghostty-ubuntu"
    echo ""
    return 0
  fi
fi

# Create config directory
mkdir -p ~/.config/ghostty

# Backup and copy config
if [ -f "$HOME/.config/ghostty/config" ]; then
  if [[ "$AUTO_BACKUP" == true ]]; then
    backup_config "$HOME/.config/ghostty/config"
    cp "$OMAKUB_SZAMSKI_PATH/configs/ghostty/config" ~/.config/ghostty/config
    echo "✓ Ghostty config updated (backup created)"
  else
    echo "✓ Ghostty config already exists (skipping)"
  fi
else
  cp "$OMAKUB_SZAMSKI_PATH/configs/ghostty/config" ~/.config/ghostty/config
  echo "✓ Ghostty config installed"
fi

echo "✓ Ghostty configured with:"
echo "  - Font: CaskaydiaCove Nerd Font Mono"
echo "  - Theme: Catppuccin Mocha"
echo "  - Background opacity: 0.95"
