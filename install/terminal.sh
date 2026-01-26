#!/bin/bash

OMAKUB_SZAMSKI_PATH="${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub-szamski}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Installing Terminal Tools"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl git unzip

echo "→ Installing libraries..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/libraries.sh"

echo "→ Installing terminal apps..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/apps-terminal.sh"

echo "→ Configuring shell..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/a-shell.sh"

echo "→ Installing Nerd Fonts..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-nerd-fonts.sh"

echo "→ Installing fastfetch..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-fastfetch.sh"

echo "→ Installing btop..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-btop.sh"

echo "→ Installing neovim..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-neovim.sh"

echo "→ Installing Ghostty..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-ghostty.sh"

echo "→ Installing Starship..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-starship.sh"

echo "→ Installing zoxide..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-zoxide.sh"

echo "→ Installing lazygit..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-lazygit.sh"

echo "→ Installing lazydocker..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-lazydocker.sh"

echo "→ Installing Docker..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/docker.sh"

echo "→ Installing mise..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/mise.sh"

if [[ "$SETUP_TAILSCALE" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/terminal/optional/app-tailscale.sh"
fi

if [[ "$SETUP_NORDVPN" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/terminal/optional/app-nordvpn.sh"
fi

if [[ "$SETUP_TLP" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/laptop/tlp.sh"
fi
