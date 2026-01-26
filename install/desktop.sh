#!/bin/bash

OMAKUB_SZAMSKI_PATH="${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub-szamski}"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Configuring Desktop Environment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "→ Applying GNOME settings..."
source "$OMAKUB_SZAMSKI_PATH/install/desktop/gnome-settings.sh"

echo "→ Setting GNOME hotkeys..."
source "$OMAKUB_SZAMSKI_PATH/install/desktop/gnome-hotkeys.sh"

if command -v ghostty >/dev/null 2>&1; then
  echo "→ Setting Ghostty as default terminal..."
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/set-ghostty-default.sh"
fi

if [[ -n "${OMAKUB_THEME:-}" ]]; then
  echo "→ Applying theme: $OMAKUB_THEME"
  source "$OMAKUB_SZAMSKI_PATH/themes/apply-theme.sh" "$OMAKUB_THEME"
fi

if [[ "$SETUP_VSCODE" == true ]]; then
  echo "→ Installing VS Code..."
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/app-vscode.sh"
fi

if [[ "$SETUP_CHROME" == true ]]; then
  echo "→ Installing Google Chrome..."
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/app-chrome.sh"
fi

if [[ "$SETUP_CHROMIUM" == true ]]; then
  echo "→ Installing Chromium..."
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/app-chromium.sh"
fi

if [[ "$SETUP_DISCORD" == true ]]; then
  echo "→ Installing Discord..."
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-discord.sh"
fi

if [[ "$SETUP_SLACK" == true ]]; then
  echo "→ Installing Slack..."
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-slack.sh"
fi

if [[ "$SETUP_SPOTIFY" == true ]]; then
  echo "→ Installing Spotify..."
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-spotify.sh"
fi

if [[ "$SETUP_1PASSWORD" == true ]]; then
  echo "→ Installing 1Password..."
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-1password.sh"
fi

if [[ "$SETUP_DROPBOX" == true ]]; then
  echo "→ Installing Dropbox..."
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-dropbox.sh"
fi

echo "→ Setting GNOME Dash favorites..."
source "$OMAKUB_SZAMSKI_PATH/install/desktop/set-dock.sh"
