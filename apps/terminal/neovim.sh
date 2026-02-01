#!/bin/bash

# Install Neovim with LazyVim configuration
# Modern, extensible text editor with IDE features

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

install_nvim_binary() {
  echo "Installing Neovim binary..."
  cd /tmp
  wget -O nvim.tar.gz "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
  tar -xf nvim.tar.gz
  sudo install nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  sudo cp -R nvim-linux-x86_64/lib /usr/local/
  sudo cp -R nvim-linux-x86_64/share /usr/local/
  rm -rf nvim-linux-x86_64 nvim.tar.gz
  cd - >/dev/null
}

# Skip if Neovim is already installed (check for version 0.9.0 or higher)
if command -v nvim >/dev/null 2>&1; then
  NVIM_VERSION=$(nvim --version | head -n1 | grep -oP 'v\K[0-9]+\.[0-9]+' || echo "0.0")
  MAJOR=$(echo "$NVIM_VERSION" | cut -d. -f1)
  MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)
  if [ "$MAJOR" -gt 0 ] || ([ "$MAJOR" -eq 0 ] && [ "$MINOR" -ge 9 ]); then
    echo "Skip: Neovim $NVIM_VERSION already installed"
  else
    # Reinstall if version is old
    install_nvim_binary
  fi
else
  install_nvim_binary
fi

# Install dependencies
echo "Installing Neovim dependencies..."
sudo apt install -y luarocks tree-sitter-cli

# Clipboard providers for Neovim (Wayland + X11)
sudo apt install -y wl-clipboard xclip

# Polish + English spell dictionaries for Neovim spell checking
sudo apt install -y vim-runtime
SPELL_DIR="$HOME/.config/nvim/spell"
mkdir -p "$SPELL_DIR"

PL_DIC="$SPELL_DIR/pl.dic"
EN_DIC="$SPELL_DIR/en.dic"

if ! [[ -f "$SPELL_DIR/pl.utf-8.spl" ]]; then
  echo "Downloading Polish spell dictionary..."
  curl -fsSL https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/pl/index.dic -o "$PL_DIC"
fi

if ! [[ -f "$SPELL_DIR/en.utf-8.spl" ]]; then
  echo "Downloading English spell dictionary..."
  curl -fsSL https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/en/index.dic -o "$EN_DIC"
fi

# Build spell files if dictionaries were downloaded
if [[ -f "$PL_DIC" || -f "$EN_DIC" ]]; then
  echo "Building spell dictionaries..."
  SPELL_DIR="$SPELL_DIR" nvim --headless -u NONE -U NONE -N \
    +"lua local d=os.getenv('SPELL_DIR') local function build(src,out) local lines=vim.fn.readfile(src) if #lines==0 then return end local start=1 if tonumber(lines[1]) then start=2 end local out_lines={} for i=start,#lines do local line=lines[i] local word=line:gsub('/.*',''):gsub('%s.*','') if word~='' then table.insert(out_lines, word) end end vim.fn.writefile(out_lines,out) end if vim.fn.filereadable(d..'/pl.dic')==1 then build(d..'/pl.dic', d..'/pl.utf-8.add') end if vim.fn.filereadable(d..'/en.dic')==1 then build(d..'/en.dic', d..'/en.utf-8.add') end" \
    +"qa"

  if [[ -f "$SPELL_DIR/pl.utf-8.add" ]]; then
    nvim --headless -u NONE -U NONE -N \
      +"mkspell! $SPELL_DIR/pl.utf-8 $SPELL_DIR/pl.utf-8.add" \
      +"qa"
  fi

  if [[ -f "$SPELL_DIR/en.utf-8.add" ]]; then
    nvim --headless -u NONE -U NONE -N \
      +"mkspell! $SPELL_DIR/en.utf-8 $SPELL_DIR/en.utf-8.add" \
      +"qa"
  fi
fi

# Ensure Node.js/npm are available (should be installed via mise)
if ! command -v npm >/dev/null 2>&1; then
  echo "Warning: npm not found. Some Neovim plugins may not work correctly."
  echo "Make sure to install Node.js via mise or manually."
fi

# Install markdownlint-cli2 for markdown linting
if command -v npm >/dev/null 2>&1 && ! command -v markdownlint-cli2 >/dev/null 2>&1; then
  echo "Installing markdownlint-cli2..."
  npm install -g markdownlint-cli2
fi

# Config Management
if [ -d "$HOME/.config/nvim" ]; then
  # If it's a git repo, assume it's custom or LazyVim
  if [ -d "$HOME/.config/nvim/.git" ]; then
    echo "Skip: existing Neovim config (git repo) detected"
  else
    echo "Warning: Neovim config exists but is not a git repo"
    echo "Backing up existing config to ~/.config/nvim.backup"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
    # Install LazyVim
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git

    # Install Omakub configs
    echo "Installing Neovim configurations..."
    mkdir -p ~/.config/nvim/plugin/after
    cp "$REPO_ROOT/configs/neovim/transparency.lua" ~/.config/nvim/plugin/after/
    cp "$REPO_ROOT/configs/neovim/theme.lua" ~/.config/nvim/lua/plugins/theme.lua
    cp "$REPO_ROOT/configs/neovim/snacks-animated-scrolling-off.lua" ~/.config/nvim/lua/plugins/
    cp "$REPO_ROOT/configs/neovim/lazyvim.json" ~/.config/nvim/

    echo "vim.opt.relativenumber = false" >>~/.config/nvim/lua/config/options.lua
    if ! grep -q "spelllang" ~/.config/nvim/lua/config/options.lua; then
      echo "vim.opt.spelllang = { 'pl', 'en' }" >>~/.config/nvim/lua/config/options.lua
    fi
  fi
else
  # Fresh install
  echo "Installing LazyVim starter configuration..."
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git

  # Install Omakub configs
  echo "Installing Neovim configurations..."
  mkdir -p ~/.config/nvim/plugin/after
  cp "$REPO_ROOT/configs/neovim/transparency.lua" ~/.config/nvim/plugin/after/
  cp "$REPO_ROOT/configs/neovim/theme.lua" ~/.config/nvim/lua/plugins/theme.lua
  cp "$REPO_ROOT/configs/neovim/snacks-animated-scrolling-off.lua" ~/.config/nvim/lua/plugins/
  cp "$REPO_ROOT/configs/neovim/lazyvim.json" ~/.config/nvim/

  echo "vim.opt.relativenumber = false" >>~/.config/nvim/lua/config/options.lua
  if ! grep -q "spelllang" ~/.config/nvim/lua/config/options.lua; then
    echo "vim.opt.spelllang = { 'pl', 'en' }" >>~/.config/nvim/lua/config/options.lua
  fi
fi

# Create Neovim desktop entry (using Ptyxis terminal)
echo "Creating Neovim desktop entry..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/nvim.desktop << 'EOF'
[Desktop Entry]
Name=Neovim
GenericName=Text Editor
Comment=Edit text files in fullscreen terminal
Exec=ptyxis --new-window -e nvim %F
Icon=nvim
Terminal=false
Type=Application
Categories=Utility;TextEditor;Development;IDE;
Keywords=text;editor;vim;neovim;nvim;
MimeType=text/plain;text/x-c;text/x-c++;text/x-python;text/x-java;text/x-makefile;text/x-shellscript;application/x-shellscript;text/x-markdown;
StartupWMClass=ptyxis
EOF

echo "Done: Neovim installed with LazyVim configuration"
echo "Run 'nvim' to start Neovim (plugins will be installed on first run)"
