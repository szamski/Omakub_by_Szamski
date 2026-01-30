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

run_step "Install GNOME Software (Flatpak/Snap)" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/app-gnome-store.sh'"

run_step "Install Papirus icon theme" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/app-papirus.sh'"

run_step "Install theme switcher PolicyKit" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/install-theme-polkit.sh'"

run_step "Set Ghostty icon" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/set-ghostty-icon.sh'"

run_step "Set webapp icons (WhatsApp)" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/set-webapp-icons.sh'"

run_step "Install GTK4 development libraries" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/app-gtk4-dev.sh'"

run_step "Build theme switcher GUI" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/build-theme-switcher.sh'"

if [[ -n "${OMAKUB_THEME:-}" ]]; then
  run_step "Apply theme: $OMAKUB_THEME" "source '$OMAKUB_SZAMSKI_PATH/themes/apply-theme.sh' '$OMAKUB_THEME'"
fi

if [[ "$SETUP_VSCODE" == true ]]; then
  run_step "Install VS Code" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/app-vscode.sh'"
fi

if [[ "$SETUP_CHROME" == true ]]; then
  run_step "Install Google Chrome" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/app-chrome.sh'"
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

if [[ "$SETUP_LIBREOFFICE" == true ]]; then
  run_step "Install LibreOffice" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-libreoffice.sh'"
fi

if [[ "$SETUP_1PASSWORD" == true ]]; then
  run_step "Install 1Password" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-1password.sh'"
fi

if [[ "$SETUP_DROPBOX" == true ]]; then
  run_step "Install Dropbox" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-dropbox.sh'"
fi

if [[ "$SETUP_STEAM" == true ]]; then
  run_step "Install Steam (Gaming)" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-steam.sh'"
fi

if [[ "$SETUP_BAMBUSTUDIO" == true ]]; then
  run_step "Install Bambu Studio (3D Printing)" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-bambustudio.sh'"
fi

run_step "Install GNOME Calendar" "sudo apt install -y gnome-calendar"

# run_step "Install Geary email client" "sudo apt install -y geary"

run_step "Configure App Drawer folders" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/set-app-folders.sh'"

run_step "Set GNOME Dash favorites" "source '$OMAKUB_SZAMSKI_PATH/install/desktop/set-dock.sh'"
