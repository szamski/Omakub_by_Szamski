#!/bin/bash

source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"

# Skip if Neovim is already installed (check for version 0.9.0 or higher)
if command -v nvim >/dev/null 2>&1; then
  NVIM_VERSION=$(nvim --version | head -n1 | grep -oP 'v\K[0-9]+\.[0-9]+' || echo "0.0")
  MAJOR=$(echo "$NVIM_VERSION" | cut -d. -f1)
  MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)
  if [ "$MAJOR" -gt 0 ] || ([ "$MAJOR" -eq 0 ] && [ "$MINOR" -ge 9 ]); then
    echo "Skip: Neovim $NVIM_VERSION already installed"
  else
    # Only reinstall if version is old
    install_nvim_binary
  fi
else
  install_nvim_binary
fi

function install_nvim_binary() {
  cd /tmp
  wget -O nvim.tar.gz "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
  tar -xf nvim.tar.gz
  sudo install nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  sudo cp -R nvim-linux-x86_64/lib /usr/local/
  sudo cp -R nvim-linux-x86_64/share /usr/local/
  rm -rf nvim-linux-x86_64 nvim.tar.gz
  cd - >/dev/null
}

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
  curl -fsSL https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/pl/index.dic -o "$PL_DIC"
fi

if ! [[ -f "$SPELL_DIR/en.utf-8.spl" ]]; then
  curl -fsSL https://raw.githubusercontent.com/wooorm/dictionaries/main/dictionaries/en/index.dic -o "$EN_DIC"
fi

if [[ -f "$PL_DIC" || -f "$EN_DIC" ]]; then
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

# Config Management
if [ -d "$HOME/.config/nvim" ]; then
  # If it's a git repo, assume it's custom or LazyVim
  if [ -d "$HOME/.config/nvim/.git" ]; then
    echo "Skip: existing Neovim config (git repo) detected"
  else
    # Using gum to ask if we should overwrite the whole folder is tricky.
    # For now, we'll assume if it's NOT a git repo, we might want to backup and replace
    if command -v gum >/dev/null 2>&1; then
       CHOICE=$(gum choose "Keep existing Neovim config" "Backup & Reinstall Omakub Neovim" --header "Neovim Configuration" || true)
       if [[ -z "$CHOICE" ]]; then
         CHOICE="Keep existing Neovim config"
       fi
       if [[ "$CHOICE" == "Backup & Reinstall Omakub Neovim" ]]; then
         backup_config "$HOME/.config/nvim"
         rm -rf "$HOME/.config/nvim"
         install_lazyvim_config
       fi
    else
       echo "Skip: Neovim config exists"
    fi
  fi
else
  install_lazyvim_config
fi

function install_lazyvim_config() {
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git

  mkdir -p ~/.config/nvim/plugin/after
  cp "$OMAKUB_SZAMSKI_PATH/configs/neovim/transparency.lua" ~/.config/nvim/plugin/after/
  cp "$OMAKUB_SZAMSKI_PATH/themes/catppuccin/neovim.lua" ~/.config/nvim/lua/plugins/theme.lua
  cp "$OMAKUB_SZAMSKI_PATH/configs/neovim/snacks-animated-scrolling-off.lua" ~/.config/nvim/lua/plugins/
  cp "$OMAKUB_SZAMSKI_PATH/configs/neovim/lazyvim.json" ~/.config/nvim/
  
  echo "vim.opt.relativenumber = false" >>~/.config/nvim/lua/config/options.lua
  if ! grep -q "spelllang" ~/.config/nvim/lua/config/options.lua; then
    echo "vim.opt.spelllang = { 'pl', 'en' }" >>~/.config/nvim/lua/config/options.lua
  fi
}

# Create Neovim desktop entry
GHOSTTY_BIN="ghostty"
GHOSTTY_WMCLASS="com.mitchellh.ghostty"

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

echo "Done: Neovim desktop entry created"
