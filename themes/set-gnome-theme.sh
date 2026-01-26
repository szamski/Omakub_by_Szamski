#!/bin/bash

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
gsettings set org.gnome.desktop.interface gtk-theme "Yaru-$OMAKUB_THEME_COLOR-dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface accent-color "$OMAKUB_THEME_COLOR" 2>/dev/null || true

OMAKUB_PATH="${OMAKUB_SZAMSKI_PATH:-${OMAKUB_PATH:-$HOME/.local/share/omakub-szamski}}"
BACKGROUND_ORG_PATH="$OMAKUB_PATH/themes/$OMAKUB_THEME_BACKGROUND"
BACKGROUND_DEST_DIR="$HOME/.local/share/backgrounds"
BACKGROUND_DEST_PATH="$BACKGROUND_DEST_DIR/$(echo $OMAKUB_THEME_BACKGROUND | tr '/' '-')"

if [ ! -d "$BACKGROUND_DEST_DIR" ]; then mkdir -p "$BACKGROUND_DEST_DIR"; fi

[ ! -f $BACKGROUND_DEST_PATH ] && cp $BACKGROUND_ORG_PATH $BACKGROUND_DEST_PATH
gsettings set org.gnome.desktop.background picture-uri $BACKGROUND_DEST_PATH
gsettings set org.gnome.desktop.background picture-uri-dark $BACKGROUND_DEST_PATH
gsettings set org.gnome.desktop.background picture-options 'zoom'

PAPIRUS_COLOR="blue"
case "$OMAKUB_THEME" in
  catppuccin) PAPIRUS_COLOR="magenta" ;;
  tokyo-night) PAPIRUS_COLOR="blue" ;;
  nord) PAPIRUS_COLOR="nordic" ;;
  everforest) PAPIRUS_COLOR="green" ;;
  gruvbox) PAPIRUS_COLOR="orange" ;;
  kanagawa) PAPIRUS_COLOR="red" ;;
  ristretto) PAPIRUS_COLOR="red" ;;
  rose-pine) PAPIRUS_COLOR="pink" ;;
  matte-black) PAPIRUS_COLOR="grey" ;;
  osaka-jade) PAPIRUS_COLOR="teal" ;;
esac

if command -v papirus-folders >/dev/null 2>&1; then
  papirus-folders -C "$PAPIRUS_COLOR" --theme Papirus-Dark >/dev/null 2>&1 || true
fi

ICON_BASE="/usr/share/icons/Papirus-Dark/48x48/places"
set_folder_icon() {
  local folder_path="$1"
  local icon_name="$2"
  if [[ -d "$folder_path" ]]; then
    if [[ -f "$ICON_BASE/${icon_name}.svg" ]]; then
      cat > "$folder_path/.directory" << EOF
[Desktop Entry]
Icon=$icon_name
Type=Directory
EOF
    fi
  fi
}

set_folder_icon "$HOME/snap" "folder-snap"
set_folder_icon "$HOME/Dropbox" "folder-dropbox"

WORK_ICON="folder-${PAPIRUS_COLOR}-projects"
if [[ -f "$ICON_BASE/${WORK_ICON}.svg" ]]; then
  set_folder_icon "$HOME/Work" "$WORK_ICON"
fi
