#!/bin/bash

OMAKUB_SZAMSKI_PATH="$HOME/.local/share/omakub-szamski"

source "$OMAKUB_SZAMSKI_PATH/install/desktop/gnome-settings.sh"
source "$OMAKUB_SZAMSKI_PATH/install/desktop/gnome-hotkeys.sh"

if command -v ghostty >/dev/null 2>&1; then
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/set-ghostty-default.sh"
fi

if [[ "$SETUP_ULAUNCHER" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/app-ulauncher.sh"
fi

if [[ "$SETUP_VSCODE" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/app-vscode.sh"
fi

if [[ "$SETUP_CHROME" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/app-chrome.sh"
fi

if [[ "$SETUP_CHROMIUM" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/app-chromium.sh"
fi

if [[ "$SETUP_DISCORD" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-discord.sh"
fi

if [[ "$SETUP_SLACK" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-slack.sh"
fi

if [[ "$SETUP_SPOTIFY" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-spotify.sh"
fi

if [[ "$SETUP_1PASSWORD" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-1password.sh"
fi

if [[ "$SETUP_DROPBOX" == true ]]; then
  source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/app-dropbox.sh"
fi

source "$OMAKUB_SZAMSKI_PATH/install/desktop/set-dock.sh"
