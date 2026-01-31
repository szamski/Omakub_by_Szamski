#!/bin/bash

OMAKUB_SZAMSKI_PATH="${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub-szamski}"

# Core dependencies (keep mandatory)
if [[ "$APT_UPDATED" != "true" ]]; then
  run_step "Update package lists" "sudo apt update -y && export APT_UPDATED=true"
else
  echo "Skip: Package lists already updated"
fi
run_step "Upgrade apt packages" "sudo apt upgrade -y"
run_step "Install base packages" "sudo apt install -y curl git unzip"
run_step "Install libraries" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/libraries.sh'"
run_step "Install core terminal apps" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/apps-terminal.sh'"
run_step "Configure shell" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/a-shell.sh'"
run_step_with_estimate "Install Nerd Fonts" "1-2 minutes" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-nerd-fonts.sh'"

# Optional tools
if [[ "$SETUP_FASTFETCH" == true ]]; then
  run_step "Install fastfetch" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-fastfetch.sh'"
fi

if [[ "$SETUP_BTOP" == true ]]; then
  run_step "Install btop" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-btop.sh'"
fi

if [[ "$SETUP_NEOVIM" == true ]]; then
  run_step "Install Neovim" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-neovim.sh'"
fi

if [[ "$SETUP_GHOSTTY" == true ]]; then
  run_step "Install Ghostty" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-ghostty.sh'"
fi

if [[ "$SETUP_STARSHIP" == true ]]; then
  run_step "Install Starship" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-starship.sh'"
fi

if [[ "$SETUP_ZOXIDE" == true ]]; then
  run_step "Install zoxide" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-zoxide.sh'"
fi

if [[ "$SETUP_LAZYGIT" == true ]]; then
  run_step "Install lazygit" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-lazygit.sh'"
fi

if [[ "$SETUP_GH_CLI" == true ]]; then
  run_step "Install GitHub CLI" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-github-cli.sh'"
fi

if [[ "$SETUP_LAZYDOCKER" == true ]]; then
  run_step "Install lazydocker" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-lazydocker.sh'"
fi

if [[ "$SETUP_DOCKER" == true ]]; then
  run_step_with_estimate "Install Docker" "5-8 minutes" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/docker.sh'"
fi

if [[ "$SETUP_MISE" == true ]]; then
  run_step_with_estimate "Install mise" "2-3 minutes" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/mise.sh'"
fi

if [[ "$SETUP_RUST" == true ]]; then
  run_step "Install Rust toolchain" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-rust.sh'"
fi

if [[ "$SETUP_TAILSCALE" == true ]]; then
  run_step "Install Tailscale" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/optional/app-tailscale.sh'"
fi

if [[ "$SETUP_WL_CLIPBOARD" == true ]]; then
  run_step "Install wl-clipboard" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/app-wl-clipboard.sh'"
fi

# Developer Stack
if [[ -n "$SELECTED_LANGUAGES" ]]; then
  run_step_with_estimate "Install Programming Languages" "3-10 minutes" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/select-dev-language.sh'"
fi

if [[ -n "$SELECTED_DBS" ]]; then
  run_step "Install Databases" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/select-dev-databases.sh'"
fi


if [[ "$SETUP_NORDVPN" == true ]]; then
  run_step "Install NordVPN" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/optional/app-nordvpn.sh'"
fi

if [[ "$SETUP_TLP" == true ]]; then
  run_step "Configure TLP" "source '$OMAKUB_SZAMSKI_PATH/install/laptop/tlp.sh'"
fi

if [[ "$SETUP_CLAUDE_CODE" == true ]]; then
  run_step "Install Claude Code" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/optional/app-claude-code.sh'"
fi

if [[ "$SETUP_OPENCODE" == true ]]; then
  run_step "Install OpenCode" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/optional/app-opencode.sh'"
fi
