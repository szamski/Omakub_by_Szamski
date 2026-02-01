#!/bin/bash

# Install Steam with Wayland fix

if command -v steam >/dev/null 2>&1; then
  echo "Skip: Steam already installed"
else
  echo "Installing Steam..."
  sudo apt install -y steam
fi

# Create Wayland wrapper script
echo "Setting up Steam Wayland fix..."

mkdir -p ~/.local/bin

cat > ~/.local/bin/steam-wayland << 'EOF'
#!/bin/bash
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
exec /usr/bin/steam -cef-force-wayland "$@"
EOF

chmod +x ~/.local/bin/steam-wayland

# Create desktop entry for Steam (Wayland)
mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/steam-wayland.desktop << EOF
[Desktop Entry]
Name=Steam (Wayland)
Comment=Steam with Wayland support
Exec=$HOME/.local/bin/steam-wayland %U
Icon=steam
Terminal=false
Type=Application
Categories=Game;
StartupNotify=false
StartupWMClass=steam
EOF

# Hide original Steam entry
cat > ~/.local/share/applications/steam.desktop << 'EOF'
[Desktop Entry]
Hidden=true
EOF

# Update desktop database
update-desktop-database ~/.local/share/applications/ 2>/dev/null || true

# Clear Steam's web cache (optional but recommended)
rm -rf ~/.local/share/Steam/config/htmlcache 2>/dev/null || true
rm -rf ~/.local/share/Steam/config/cef_cache 2>/dev/null || true

echo "Done: Steam installed with Wayland support"
echo "  Use 'Steam (Wayland)' from application menu"
