#!/bin/bash

OMAKUB_SZAMSKI_PATH="${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub-szamski}"

if ! declare -f run_step >/dev/null 2>&1; then
  run_step() {
    local title="$1"
    shift
    local cmd="$*"
    echo "→ $title"
    bash -c "$cmd"
  }
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Installing Terminal Tools"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

run_step "Update apt" "sudo apt update -y"
run_step "Upgrade apt packages" "sudo apt upgrade -y"
run_step "Install base packages" "sudo apt install -y curl git unzip"

run_step "Install libraries" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/libraries.sh'"

run_step "Install terminal apps" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/apps-terminal.sh'"

run_step "Configure shell" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/a-shell.sh'"

run_step "Install Nerd Fonts" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-nerd-fonts.sh'"

run_step "Install fastfetch" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-fastfetch.sh'"

run_step "Install btop" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-btop.sh'"

run_step "Install Neovim" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-neovim.sh'"

run_step "Install Ghostty" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-ghostty.sh'"

run_step "Install Starship" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-starship.sh'"

run_step "Install zoxide" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-zoxide.sh'"

run_step "Install lazygit" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-lazygit.sh'"

run_step "Install lazydocker" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-lazydocker.sh'"

run_step "Install Docker" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/docker.sh'"

run_step "Install mise" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/mise.sh'"

if [[ "$SETUP_TAILSCALE" == true ]]; then
  run_step "Install Tailscale" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/optional/app-tailscale.sh'"
fi

if [[ "$SETUP_NORDVPN" == true ]]; then
  run_step "Install NordVPN" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/optional/app-nordvpn.sh'"
fi

if [[ "$SETUP_TLP" == true ]]; then
  run_step "Configure TLP" "source '$OMAKUB_SZAMSKI_PATH/install/laptop/tlp.sh'"
fi
