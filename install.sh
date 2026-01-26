#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$EUID" -eq 0 ]]; then
  echo "Error: Do not run install.sh with sudo."
  echo "Run: ./install.sh"
  exit 1
fi
if [[ -d "$SCRIPT_DIR/install" ]]; then
  OMAKUB_SZAMSKI_PATH="$SCRIPT_DIR"
else
  OMAKUB_SZAMSKI_PATH="${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub-szamski}"
fi
export OMAKUB_SZAMSKI_PATH
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
export BACKUP_DIR="$HOME/.config-backup-$BACKUP_DATE"
export DRY_RUN=false

for arg in "$@"; do
  if [[ "$arg" == "--dry-run" ]]; then
    export DRY_RUN=true
  fi
done

source "$OMAKUB_SZAMSKI_PATH/install/backup-configs.sh"

LOG_DIR="$HOME/.local/share/omakub-szamski/logs"
LOG_FILE="$LOG_DIR/install-$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$LOG_DIR"

log_info() {
  if [[ -n "${OMAKUB_STDOUT_FD:-}" ]]; then
    echo "$@" >&$OMAKUB_STDOUT_FD
  else
    echo "$@"
  fi
}

run_step() {
  local title="$1"
  shift
  local cmd="$*"

  if command -v gum >/dev/null 2>&1; then
    local out_fd="${OMAKUB_STDOUT_FD:-1}"
    gum spin --title "$title" -- bash -c "$cmd >>\"$LOG_FILE\" 2>&1" >&$out_fd
    progress_advance
  else
    log_info "→ $title"
    bash -c "$cmd" >>"$LOG_FILE" 2>&1
    progress_advance
  fi
}

start_progress() {
  PROGRESS_TOTAL="$1"
  PROGRESS_CURRENT=0
  progress_tick
}

progress_tick() {
  if [[ -z "${PROGRESS_TOTAL:-}" ]]; then
    return 0
  fi
  if [[ -z "${PROGRESS_CURRENT:-}" ]]; then
    PROGRESS_CURRENT=0
  fi
  if [[ "$PROGRESS_CURRENT" -gt "$PROGRESS_TOTAL" ]]; then
    PROGRESS_CURRENT="$PROGRESS_TOTAL"
  fi

  local width=20
  local filled=$(( PROGRESS_CURRENT * width / PROGRESS_TOTAL ))
  local empty=$(( width - filled ))
  local percent=$(( PROGRESS_CURRENT * 100 / PROGRESS_TOTAL ))
  local bar
  bar="$(printf '%*s' "$filled" '' | tr ' ' '#')"
  bar+="$(printf '%*s' "$empty" '' | tr ' ' '-')"

  log_info "Progress [${bar}] ${PROGRESS_CURRENT}/${PROGRESS_TOTAL} (${percent}%)"
}

progress_advance() {
  if [[ -n "${PROGRESS_TOTAL:-}" ]]; then
    PROGRESS_CURRENT=$((PROGRESS_CURRENT+1))
    if [[ "$PROGRESS_CURRENT" -gt "$PROGRESS_TOTAL" ]]; then
      PROGRESS_CURRENT="$PROGRESS_TOTAL"
    fi
    progress_tick
  fi
}

finish_progress() {
  progress_tick
}

trap 'log_info "Omakub_by_Szamski installation failed! You can retry by running: source $OMAKUB_SZAMSKI_PATH/install.sh"' ERR

source "$OMAKUB_SZAMSKI_PATH/install/check-version.sh"

log_info "Sudo authentication required..."
sudo -v

log_info "Installing interactive menu system..."
run_step "Install gum" "source '$OMAKUB_SZAMSKI_PATH/install/terminal/required/app-gum.sh'"

log_info "Get ready to make a few choices..."
source "$OMAKUB_SZAMSKI_PATH/install/first-run-choices.sh"

if [[ "${OMAKUB_SZAMSKI_DRY_RUN}" == "1" || "${OMAKUB_SZAMSKI_DRY_RUN}" == "true" ]]; then
  export DRY_RUN=true
fi

if [[ "$DRY_RUN" == true ]]; then
  log_info ""
  log_info "Dry-run enabled. Planned actions:"
  log_info "  Terminal tools: fastfetch, btop, neovim, docker, mise, fzf, ripgrep, bat, eza, zoxide"
  log_info "  Terminal UI: lazygit, lazydocker"
  if [[ "$SETUP_TAILSCALE" == true ]]; then
    log_info "  VPN: tailscale"
  fi
  if [[ "$SETUP_NORDVPN" == true ]]; then
    log_info "  VPN: nordvpn"
  fi
  if [[ "$SETUP_TLP" == true ]]; then
    log_info "  Laptop: TLP optimization"
  fi
  if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
    log_info "  Desktop: GNOME settings and hotkeys"
    if [[ -n "${OMAKUB_THEME:-}" ]]; then
      log_info "  Theme: $OMAKUB_THEME"
    fi
    if [[ "$SETUP_VSCODE" == true ]]; then
      log_info "  Desktop app: VS Code"
    fi
    if [[ "$SETUP_DISCORD" == true ]]; then
      log_info "  Desktop app: Discord"
    fi
    if [[ "$SETUP_SLACK" == true ]]; then
      log_info "  Desktop app: Slack"
    fi
    if [[ "$SETUP_SPOTIFY" == true ]]; then
      log_info "  Desktop app: Spotify"
    fi
    if [[ "$SETUP_1PASSWORD" == true ]]; then
      log_info "  Desktop app: 1Password"
    fi
    if [[ "$SETUP_DROPBOX" == true ]]; then
      log_info "  Desktop app: Dropbox"
    fi
    if [[ "$SETUP_CHROME" == true ]]; then
      log_info "  Browser: Google Chrome"
    fi
    if [[ "$SETUP_CHROMIUM" == true ]]; then
      log_info "  Browser: Chromium"
    fi
  fi
  log_info ""
  log_info "Dry-run complete. No changes were made."
  return 0
fi

exec 3>&1 4>&2
export OMAKUB_STDOUT_FD=3
log_info ""
log_info "Logging install output to: $LOG_FILE"

TOTAL_STEPS=2
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  TOTAL_STEPS=7
fi
start_progress "$TOTAL_STEPS"

log_info "Configuring git..."
source "$OMAKUB_SZAMSKI_PATH/install/setup-git.sh"
progress_advance

if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  run_step "Disable screen lock" "gsettings set org.gnome.desktop.screensaver lock-enabled false"
  run_step "Disable idle timeout" "gsettings set org.gnome.desktop.session idle-delay 0"

  log_info "Installing terminal and desktop tools..."
  run_step "Install terminal tools" "source '$OMAKUB_SZAMSKI_PATH/install/terminal.sh'"
  run_step "Configure desktop" "source '$OMAKUB_SZAMSKI_PATH/install/desktop.sh'"

  run_step "Restore screen lock" "gsettings set org.gnome.desktop.screensaver lock-enabled true"
  run_step "Restore idle timeout" "gsettings set org.gnome.desktop.session idle-delay 300"
else
  log_info "Only installing terminal tools..."
  run_step "Install terminal tools" "source '$OMAKUB_SZAMSKI_PATH/install/terminal.sh'"
fi

finish_progress

log_info ""
log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_info "✓ Installation Complete!"
log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_info ""
log_info "Backups saved to: $BACKUP_DIR"
log_info ""
log_info "Next steps:"
log_info "  1. Restart your terminal or run: source ~/.bashrc"
if ! command -v ghostty >/dev/null 2>&1; then
  log_info "  2. Install Ghostty manually: sudo snap install ghostty --classic"
fi
log_info ""
log_info "Enjoy your new development environment! 🚀"
