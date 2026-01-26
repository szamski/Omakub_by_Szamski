#!/bin/bash

# Skip if Ghostty is already installed
if command -v ghostty >/dev/null 2>&1; then
  echo "⏭️  Ghostty already installed, skipping..."
  # Still configure if config doesn't exist
  if [ -f "$HOME/.config/ghostty/config" ]; then
    return 0
  fi
fi

# Install Ghostty using official Snap package
if ! command -v ghostty >/dev/null 2>&1; then
  echo "Installing Ghostty via Snap..."
  
  # Try to install, but don't let errors stop the whole installation
  if sudo snap install ghostty --classic 2>/dev/null; then
    echo "✓ Ghostty installed"
  else
    # Installation failed - could be sudo password, network, or snap not available
    echo "❌ Ghostty installation failed"
    echo "   This could be due to:"
    echo "   - sudo password not provided"
    echo "   - snap not installed or not available"
    echo "   - network connection issues"
    echo ""
    echo "   Please install manually:"
    echo "   sudo snap install ghostty --classic"
    echo "   Or visit: https://ghostty.org/docs/install/binary"
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
