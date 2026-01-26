#!/bin/bash

OMAKUB_SZAMSKI_PATH="${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub-szamski}"

THEME_NAMES=(
  "Tokyo Night"
  "Catppuccin"
  "Nord"
  "Everforest"
  "Gruvbox"
  "Kanagawa"
  "Ristretto"
  "Rose Pine"
  "Matte Black"
  "Osaka Jade"
)

THEME=$(gum choose "${THEME_NAMES[@]}" "<< Back" --header "Choose your theme" --height 12 | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

if [[ -n "$THEME" && "$THEME" != "<<-back" ]]; then
  export OMAKUB_SZAMSKI_PATH
  export OMAKUB_THEME="$THEME"
  source "$OMAKUB_SZAMSKI_PATH/themes/apply-theme.sh" "$THEME"
fi
