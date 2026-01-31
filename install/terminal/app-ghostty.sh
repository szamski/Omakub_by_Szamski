#!/bin/bash

source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"

# Enforce no snap for Ghostty if possible (currently using community script which is deb-based essentially)
ensure_no_snap "ghostty"

# Install Ghostty using the Ubuntu community package (no snap/flatpak)
if ! command -v ghostty >/dev/null 2>&1; then
  echo "Installing Ghostty (community Ubuntu package)..."

  if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"; then
    echo "Done: Ghostty installed"
  else
    echo "Error: Ghostty installation failed"
    echo "   Please install manually:"
    echo "   https://github.com/mkasberg/ghostty-ubuntu"
    echo ""
    return 0
  fi
fi

# Create config directory
mkdir -p ~/.config/ghostty

# Smart Config Install
install_config "$OMAKUB_SZAMSKI_PATH/configs/ghostty/config" "$HOME/.config/ghostty/config" "Ghostty"

echo "Done: Ghostty configured"
