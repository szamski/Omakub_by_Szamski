#!/bin/bash

set -euo pipefail

OMAKUB_THEME="${1:-${OMAKUB_THEME:-}}"
if [[ -z "$OMAKUB_THEME" ]]; then
  echo "Error: Theme name is required"
  return 1
fi

OMAKUB_PATH="${OMAKUB_SZAMSKI_PATH:-${OMAKUB_PATH:-$HOME/.local/share/omakub-szamski}}"
THEME_DIR="$OMAKUB_PATH/themes/$OMAKUB_THEME"
THEME_FILE="$THEME_DIR/neovim.lua"

if [[ ! -f "$THEME_FILE" ]]; then
  echo "Warning: Neovim theme not found for $OMAKUB_THEME"
  return 0
fi

if [[ -d "$HOME/.config/nvim" ]]; then
  mkdir -p "$HOME/.config/nvim/lua/plugins"
  cp "$THEME_FILE" "$HOME/.config/nvim/lua/plugins/theme.lua"
  echo "✓ Neovim theme applied: $OMAKUB_THEME"
fi
