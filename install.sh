#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "$OMAKUB_SZAMSKI_PATH" ]]; then
  if [[ -d "$SCRIPT_DIR/install" ]]; then
    OMAKUB_SZAMSKI_PATH="$SCRIPT_DIR"
  else
    OMAKUB_SZAMSKI_PATH="$HOME/.local/share/omakub-szamski"
  fi
fi
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
export BACKUP_DIR="$HOME/.config-backup-$BACKUP_DATE"
export DRY_RUN=false

for arg in "$@"; do
  if [[ "$arg" == "--dry-run" ]]; then
    export DRY_RUN=true
  fi
done

source "$OMAKUB_SZAMSKI_PATH/install/backup-configs.sh"

trap 'echo "Omakub_by_Szamski installation failed! You can retry by running: source $OMAKUB_SZAMSKI_PATH/install.sh"' ERR

source "$OMAKUB_SZAMSKI_PATH/install/check-version.sh"

echo "Installing interactive menu system..."
source "$OMAKUB_SZAMSKI_PATH/install/terminal/required/app-gum.sh" >/dev/null

echo "Get ready to make a few choices..."
source "$OMAKUB_SZAMSKI_PATH/install/first-run-choices.sh"

if [[ "${OMAKUB_SZAMSKI_DRY_RUN}" == "1" || "${OMAKUB_SZAMSKI_DRY_RUN}" == "true" ]]; then
  export DRY_RUN=true
fi

if [[ "$DRY_RUN" == true ]]; then
  echo ""
  echo "Dry-run enabled. Planned actions:"
  echo "  Terminal tools: fastfetch, btop, neovim, docker, mise, fzf, ripgrep, bat, eza, zoxide"
  echo "  Terminal UI: lazygit, lazydocker"
  if [[ "$SETUP_TAILSCALE" == true ]]; then
    echo "  VPN: tailscale"
  fi
  if [[ "$SETUP_NORDVPN" == true ]]; then
    echo "  VPN: nordvpn"
  fi
  if [[ "$SETUP_TLP" == true ]]; then
    echo "  Laptop: TLP optimization"
  fi
  if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
    echo "  Desktop: GNOME settings and hotkeys"
    if [[ "$SETUP_ULAUNCHER" == true ]]; then
      echo "  Desktop app: ulauncher"
    fi
    if [[ "$SETUP_VSCODE" == true ]]; then
      echo "  Desktop app: VS Code"
    fi
    if [[ "$SETUP_DISCORD" == true ]]; then
      echo "  Desktop app: Discord"
    fi
    if [[ "$SETUP_SLACK" == true ]]; then
      echo "  Desktop app: Slack"
    fi
    if [[ "$SETUP_SPOTIFY" == true ]]; then
      echo "  Desktop app: Spotify"
    fi
    if [[ "$SETUP_1PASSWORD" == true ]]; then
      echo "  Desktop app: 1Password"
    fi
    if [[ "$SETUP_DROPBOX" == true ]]; then
      echo "  Desktop app: Dropbox"
    fi
    if [[ "$SETUP_CHROME" == true ]]; then
      echo "  Browser: Google Chrome"
    fi
    if [[ "$SETUP_CHROMIUM" == true ]]; then
      echo "  Browser: Chromium"
    fi
  fi
  echo ""
  echo "Dry-run complete. No changes were made."
  return 0
fi

source "$OMAKUB_SZAMSKI_PATH/install/setup-git.sh"

if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  gsettings set org.gnome.desktop.screensaver lock-enabled false
  gsettings set org.gnome.desktop.session idle-delay 0

  echo "Installing terminal and desktop tools..."
  source "$OMAKUB_SZAMSKI_PATH/install/terminal.sh"
  source "$OMAKUB_SZAMSKI_PATH/install/desktop.sh"

  gsettings set org.gnome.desktop.screensaver lock-enabled true
  gsettings set org.gnome.desktop.session idle-delay 300
else
  echo "Only installing terminal tools..."
  source "$OMAKUB_SZAMSKI_PATH/install/terminal.sh"
fi

echo ""
echo "Installation complete!"
echo "Backups saved to: $BACKUP_DIR"
echo "Restart your terminal or run: source ~/.bashrc"
