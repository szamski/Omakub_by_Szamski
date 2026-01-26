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
cp "$OMAKUB_SZAMSKI_PATH/themes/catppuccin-mocha/neovim.lua" ~/.config/nvim/lua/plugins/theme.lua
cp "$OMAKUB_SZAMSKI_PATH/configs/neovim/snacks-animated-scrolling-off.lua" ~/.config/nvim/lua/plugins/
cp "$OMAKUB_SZAMSKI_PATH/configs/neovim/lazyvim.json" ~/.config/nvim/

echo "vim.opt.relativenumber = false" >>~/.config/nvim/lua/config/options.lua
