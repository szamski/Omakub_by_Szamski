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
  local display_title="$title"

  if [[ -n "${PROGRESS_TOTAL:-}" ]]; then
    local next_step=$((PROGRESS_CURRENT+1))
    if [[ "$next_step" -gt "$PROGRESS_TOTAL" ]]; then
      next_step="$PROGRESS_TOTAL"
    fi
    display_title="[$next_step/$PROGRESS_TOTAL] $title"
  fi

  if command -v gum >/dev/null 2>&1; then
    local out_fd="${OMAKUB_STDOUT_FD:-1}"
    if ! gum spin --spinner dot --show-output --show-error --title "$display_title" -- \
      bash -c "$cmd" > >(tee -a "$LOG_FILE") 2> >(tee -a "$LOG_FILE" >&2); then
      gum style --border normal --foreground 196 "ERROR: $title failed!" >&$out_fd
      gum style --foreground 196 "Check log for details: $LOG_FILE" >&$out_fd
      # Optional: Ask to continue or exit? For now, we log and continue (or let set -e handle it if critical)
      # But since we are in a subshell or wrapped, set -e might not kill the parent.
      # Let's rely on set -e at top level, but gum spin captures exit code.
      return 1
    fi
    progress_advance
  else
    log_info "→ $display_title"
    if ! bash -c "$cmd" > >(tee -a "$LOG_FILE") 2> >(tee -a "$LOG_FILE" >&2); then
      echo "ERROR: $title failed!"
      return 1
    fi
    progress_advance
  fi
}

run_interactive() {
  local title="$1"
  shift
  local cmd="$*"
  local out_fd="${OMAKUB_STDOUT_FD:-1}"

  log_info "→ $title"
  bash -c "$cmd" < /dev/tty \
    > >(tee -a "$LOG_FILE" >&$out_fd) \
    2> >(tee -a "$LOG_FILE" >&$out_fd)
  progress_advance
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
    if [[ "$SETUP_CODIUM" == true ]]; then
      log_info "  Desktop app: VSCodium"
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
  TERMINAL_STEPS=18
  if [[ "$SETUP_TAILSCALE" == true ]]; then
    TERMINAL_STEPS=$((TERMINAL_STEPS+1))
  fi
  if [[ "$SETUP_NORDVPN" == true ]]; then
    TERMINAL_STEPS=$((TERMINAL_STEPS+1))
  fi
  if [[ "$SETUP_TLP" == true ]]; then
    TERMINAL_STEPS=$((TERMINAL_STEPS+1))
  fi

  DESKTOP_STEPS=8
  if [[ -n "${OMAKUB_THEME:-}" ]]; then
    DESKTOP_STEPS=$((DESKTOP_STEPS+1))
  fi
  if [[ "$SETUP_CODIUM" == true ]]; then
    DESKTOP_STEPS=$((DESKTOP_STEPS+1))
  fi
  if [[ "$SETUP_CHROME" == true ]]; then
    DESKTOP_STEPS=$((DESKTOP_STEPS+1))
  fi
  if [[ "$SETUP_DISCORD" == true ]]; then
    DESKTOP_STEPS=$((DESKTOP_STEPS+1))
  fi
  if [[ "$SETUP_SLACK" == true ]]; then
    DESKTOP_STEPS=$((DESKTOP_STEPS+1))
  fi
  if [[ "$SETUP_SPOTIFY" == true ]]; then
    DESKTOP_STEPS=$((DESKTOP_STEPS+1))
  fi
  if [[ "$SETUP_LIBREOFFICE" == true ]]; then
    DESKTOP_STEPS=$((DESKTOP_STEPS+1))
  fi
  if [[ "$SETUP_1PASSWORD" == true ]]; then
    DESKTOP_STEPS=$((DESKTOP_STEPS+1))
  fi
  if [[ "$SETUP_DROPBOX" == true ]]; then
    DESKTOP_STEPS=$((DESKTOP_STEPS+1))
  fi

  TOTAL_STEPS=$((1 + 5 + TERMINAL_STEPS + DESKTOP_STEPS))
fi
start_progress "$TOTAL_STEPS"

run_step "Fix script permissions" "chmod +x '$OMAKUB_SZAMSKI_PATH/bin/omakub-szamski' '$OMAKUB_SZAMSKI_PATH/bin/omakub-sub/theme.sh' '$OMAKUB_SZAMSKI_PATH/bin/omakub-sub/theme-gui.sh' '$OMAKUB_SZAMSKI_PATH/install.sh' '$OMAKUB_SZAMSKI_PATH/install/desktop/set-dock.sh' '$OMAKUB_SZAMSKI_PATH/install/desktop/set-ghostty-default.sh' '$OMAKUB_SZAMSKI_PATH/install/desktop/app-gnome-store.sh' '$OMAKUB_SZAMSKI_PATH/themes/apply-theme.sh' '$OMAKUB_SZAMSKI_PATH/themes/set-ghostty-theme.sh' '$OMAKUB_SZAMSKI_PATH/themes/set-btop-theme.sh' '$OMAKUB_SZAMSKI_PATH/themes/set-neovim-theme.sh' '$OMAKUB_SZAMSKI_PATH/themes/set-starship-theme.sh' '$OMAKUB_SZAMSKI_PATH/themes/gen-ghostty-from-alacritty.sh' 2>/dev/null || true"

log_info "Configuring git..."
source "$OMAKUB_SZAMSKI_PATH/install/setup-git.sh"
progress_advance

if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  run_step "Disable screen lock" "gsettings set org.gnome.desktop.screensaver lock-enabled false"
  run_step "Disable idle timeout" "gsettings set org.gnome.desktop.session idle-delay 0"

  gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Installing Terminal Tools"
  source "$OMAKUB_SZAMSKI_PATH/install/terminal.sh"

  gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Configuring Desktop"
  source "$OMAKUB_SZAMSKI_PATH/install/desktop.sh"

  run_step "Restore screen lock" "gsettings set org.gnome.desktop.screensaver lock-enabled true"
  run_step "Restore idle timeout" "gsettings set org.gnome.desktop.session idle-delay 300"
else
  gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Installing Terminal Tools"
  source "$OMAKUB_SZAMSKI_PATH/install/terminal.sh"
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
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  log_info "  2. Log out and back in to apply GNOME extensions"
fi
if ! command -v ghostty >/dev/null 2>&1; then
  log_info "  3. Install Ghostty manually: sudo snap install ghostty --classic"
fi
log_info ""
log_info "Enjoy your new development environment! 🚀"
