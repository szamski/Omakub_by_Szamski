#!/bin/bash

# Skip if Neovim is already installed (check for version 0.9.0 or higher)
if command -v nvim >/dev/null 2>&1; then
  NVIM_VERSION=$(nvim --version | head -n1 | grep -oP 'v\K[0-9]+\.[0-9]+' || echo "0.0")
  MAJOR=$(echo "$NVIM_VERSION" | cut -d. -f1)
  MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)
  if [ "$MAJOR" -gt 0 ] || ([ "$MAJOR" -eq 0 ] && [ "$MINOR" -ge 9 ]); then
    echo "⏭️  Neovim $NVIM_VERSION already installed, skipping..."
    return 0
  fi
fi

cd /tmp
wget -O nvim.tar.gz "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
tar -xf nvim.tar.gz
sudo install nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
sudo cp -R nvim-linux-x86_64/lib /usr/local/
sudo cp -R nvim-linux-x86_64/share /usr/local/
rm -rf nvim-linux-x86_64 nvim.tar.gz
cd - >/dev/null

sudo apt install -y luarocks tree-sitter-cli

# Clipboard providers for Neovim (Wayland + X11)
sudo apt install -y wl-clipboard xclip

# Ensure Node.js/npm are available for Mason LSP installs and markdownlint-cli2
if ! command -v node >/dev/null 2>&1 && ! command -v nodejs >/dev/null 2>&1; then
  sudo apt install -y nodejs npm
fi

if ! command -v npm >/dev/null 2>&1; then
  sudo apt install -y npm
fi

if command -v npm >/dev/null 2>&1 && ! command -v markdownlint-cli2 >/dev/null 2>&1; then
  sudo npm install -g markdownlint-cli2
fi

if [ -d "$HOME/.config/nvim" ]; then
  if [[ "$AUTO_BACKUP" == true ]]; then
    backup_config "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim"
  else
    return 0
  fi
fi

git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

mkdir -p ~/.config/nvim/plugin/after
cp "$OMAKUB_SZAMSKI_PATH/configs/neovim/transparency.lua" ~/.config/nvim/plugin/after/
cp "$OMAKUB_SZAMSKI_PATH/themes/catppuccin/neovim.lua" ~/.config/nvim/lua/plugins/theme.lua
cp "$OMAKUB_SZAMSKI_PATH/configs/neovim/snacks-animated-scrolling-off.lua" ~/.config/nvim/lua/plugins/
cp "$OMAKUB_SZAMSKI_PATH/configs/neovim/lazyvim.json" ~/.config/nvim/

echo "vim.opt.relativenumber = false" >>~/.config/nvim/lua/config/options.lua

# Prefer Polish + English spell dictionaries to avoid underlining Polish text
if ! grep -q "spelllang" ~/.config/nvim/lua/config/options.lua; then
  echo "vim.opt.spelllang = { 'pl', 'en' }" >>~/.config/nvim/lua/config/options.lua
fi

# Create Neovim desktop entry that launches in fullscreen Ghostty
# Note: --gtk-single-instance=false ensures new window opens (required for Snap Ghostty)
# Using --fullscreen instead of --maximize for better Wayland compatibility
GHOSTTY_BIN="ghostty"
GHOSTTY_WMCLASS="com.mitchellh.ghostty"
if [[ -x "/snap/bin/ghostty" ]]; then
  GHOSTTY_BIN="/snap/bin/ghostty"
  GHOSTTY_WMCLASS="ghostty"
fi

mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/nvim.desktop << 'EOF'
[Desktop Entry]
Name=Neovim
GenericName=Text Editor
Comment=Edit text files in fullscreen terminal
Exec=GHOSTTY_BIN_PLACEHOLDER --gtk-single-instance=false --fullscreen -e nvim %F
Icon=nvim
Terminal=false
Type=Application
Categories=Utility;TextEditor;Development;IDE;
Keywords=text;editor;vim;neovim;nvim;
MimeType=text/plain;text/x-c;text/x-c++;text/x-python;text/x-java;text/x-makefile;text/x-shellscript;application/x-shellscript;text/x-markdown;
StartupWMClass=GHOSTTY_WMCLASS_PLACEHOLDER
EOF

sed -i "s|GHOSTTY_BIN_PLACEHOLDER|$GHOSTTY_BIN|" ~/.local/share/applications/nvim.desktop
sed -i "s|GHOSTTY_WMCLASS_PLACEHOLDER|$GHOSTTY_WMCLASS|" ~/.local/share/applications/nvim.desktop

echo "✓ Neovim desktop entry created (launches in fullscreen Ghostty)"
