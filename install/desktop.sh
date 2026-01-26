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

if ! declare -f run_interactive >/dev/null 2>&1; then
  run_interactive() {
    local title="$1"
    shift
    local cmd="$*"
    echo "→ $title"
    bash -c "$cmd"
  }
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Configuring Desktop Environment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

run_step "Apply GNOME settings" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/gnome-settings.sh'"

run_step "Set GNOME hotkeys" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/gnome-hotkeys.sh'"

run_interactive "Install GNOME extensions" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/set-gnome-extensions.sh'"

run_step "Set Ghostty as default terminal" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/set-ghostty-default.sh'"

run_step "Install Papirus icon theme" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/app-papirus.sh'"

if [[ -n "${OMAKUB_THEME:-}" ]]; then
  run_step "Apply theme: $OMAKUB_THEME" "source '$OMAKUB_SZAMSKI_PATH/themes/apply-theme.sh' '$OMAKUB_THEME'"
fi

if [[ "$SETUP_VSCODE" == true ]]; then
  run_step "Install VS Code" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/app-vscode.sh'"
fi

if [[ "$SETUP_CHROME" == true ]]; then
  run_step "Install Google Chrome" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/app-chrome.sh'"
fi

if [[ "$SETUP_CHROMIUM" == true ]]; then
  run_step "Install Chromium" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/app-chromium.sh'"
fi

if [[ "$SETUP_DISCORD" == true ]]; then
  run_step "Install Discord" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-discord.sh'"
fi

if [[ "$SETUP_SLACK" == true ]]; then
  run_step "Install Slack" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-slack.sh'"
fi

if [[ "$SETUP_SPOTIFY" == true ]]; then
  run_step "Install Spotify" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-spotify.sh'"
fi

if [[ "$SETUP_RIFF" == true ]]; then
  run_step "Install Riff (Spotify GTK)" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-riff.sh'"
fi

if [[ "$SETUP_1PASSWORD" == true ]]; then
  run_step "Install 1Password" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-1password.sh'"
fi

if [[ "$SETUP_DROPBOX" == true ]]; then
  run_step "Install Dropbox" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-dropbox.sh'"
fi

run_step "Set GNOME Dash favorites" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/set-dock.sh'"
