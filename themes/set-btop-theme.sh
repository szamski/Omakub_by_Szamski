#!/bin/bash

set -euo pipefail

OMAKUB_THEME="${1:-${OMAKUB_THEME:-}}"
if [[ -z "$OMAKUB_THEME" ]]; then
  echo "Error: Theme name is required"
  return 1
fi

OMAKUB_PATH="${OMAKUB_SZAMSKI_PATH:-${OMAKUB_PATH:-$HOME/.local/share/omakub-szamski}}"
THEME_DIR="$OMAKUB_PATH/themes/$OMAKUB_THEME"
THEME_FILE="$THEME_DIR/btop.theme"

if [[ ! -f "$THEME_FILE" ]]; then
  echo "Warning: btop theme not found for $OMAKUB_THEME"
  return 0
fi

mkdir -p "$HOME/.config/btop/themes"
cp "$THEME_FILE" "$HOME/.config/btop/themes/$OMAKUB_THEME.theme"

if [[ -f "$HOME/.config/btop/btop.conf" ]]; then
  sed -i "s/color_theme = \".*\"/color_theme = \"$OMAKUB_THEME\"/g" "$HOME/.config/btop/btop.conf"
fi

echo "✓ btop theme applied: $OMAKUB_THEME"
