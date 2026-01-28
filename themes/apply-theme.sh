#!/bin/bash

set -euo pipefail

OMAKUB_THEME="${1:-${OMAKUB_THEME:-}}"
if [[ -z "$OMAKUB_THEME" ]]; then
  echo "Error: Theme name is required"
  return 1
fi

OMAKUB_PATH="${OMAKUB_PATH:-${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub}}"
export OMAKUB_PATH
export OMAKUB_THEME

THEME_DIR="$OMAKUB_PATH/themes/$OMAKUB_THEME"
if [[ ! -d "$THEME_DIR" ]]; then
  echo "Error: Theme not found: $OMAKUB_THEME"
  return 1
fi

source "$OMAKUB_PATH/themes/$OMAKUB_THEME/gnome.sh"
source "$OMAKUB_PATH/themes/set-ghostty-theme.sh" "$OMAKUB_THEME"
source "$OMAKUB_PATH/themes/set-neovim-theme.sh" "$OMAKUB_THEME"
source "$OMAKUB_PATH/themes/set-btop-theme.sh" "$OMAKUB_THEME"
source "$OMAKUB_PATH/themes/set-starship-theme.sh" "$OMAKUB_THEME"
source "$OMAKUB_PATH/themes/set-vscode-theme.sh" "$OMAKUB_THEME"
source "$OMAKUB_PATH/themes/set-browser-theme.sh"

echo "✓ Theme applied: $OMAKUB_THEME"
