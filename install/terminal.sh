#!/bin/bash

OMAKUB_SZAMSKI_PATH="$HOME/.local/share/omakub-szamski"

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl git unzip

source "$OMAKUB_SZAMSKI_PATH/install/terminal/libraries.sh"
source "$OMAKUB_SZAMSKI_PATH/install/terminal/apps-terminal.sh"
source "$OMAKUB_SZAMSKI_PATH/install/terminal/a-shell.sh"
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-fastfetch.sh"
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-btop.sh"
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-neovim.sh"
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-ghostty.sh"
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-starship.sh"
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-zoxide.sh"
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-lazygit.sh"
source "$OMAKUB_SZAMSKI_PATH/install/terminal/app-lazydocker.sh"
source "$OMAKUB_SZAMSKI_PATH/install/terminal/docker.sh"
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
