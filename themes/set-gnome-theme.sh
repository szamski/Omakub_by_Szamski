#!/bin/bash

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru' 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" 2>/dev/null || true

# Map theme to GNOME accent color and Yaru GTK theme variant
ACCENT_COLOR="blue"
YARU_VARIANT="blue"
case "$OMAKUB_THEME" in
  catppuccin) ACCENT_COLOR="pink"; YARU_VARIANT="magenta" ;;
  tokyo-night) ACCENT_COLOR="blue"; YARU_VARIANT="blue" ;;
  nord) ACCENT_COLOR="blue"; YARU_VARIANT="blue" ;;
  everforest) ACCENT_COLOR="green"; YARU_VARIANT="sage" ;;
  gruvbox) ACCENT_COLOR="orange"; YARU_VARIANT="" ;;  # Default Yaru is orange
  kanagawa) ACCENT_COLOR="red"; YARU_VARIANT="red" ;;
  ristretto) ACCENT_COLOR="red"; YARU_VARIANT="red" ;;
  rose-pine) ACCENT_COLOR="purple"; YARU_VARIANT="purple" ;;
  matte-black) ACCENT_COLOR="slate"; YARU_VARIANT="prussiangreen" ;;
  osaka-jade) ACCENT_COLOR="teal"; YARU_VARIANT="prussiangreen" ;;
esac

gsettings set org.gnome.desktop.interface accent-color "$ACCENT_COLOR" 2>/dev/null || true

# Set Yaru GTK theme with color variant for consistent accent colors
if [[ -n "$YARU_VARIANT" ]]; then
  gsettings set org.gnome.desktop.interface gtk-theme "Yaru-${YARU_VARIANT}-dark" 2>/dev/null || true
else
  gsettings set org.gnome.desktop.interface gtk-theme "Yaru-dark" 2>/dev/null || true
fi

OMAKUB_PATH="${OMAKUB_SZAMSKI_PATH:-${OMAKUB_PATH:-$HOME/.local/share/omakub-szamski}}"
BACKGROUND_ORG_PATH="$OMAKUB_PATH/themes/$OMAKUB_THEME_BACKGROUND"
BACKGROUND_DEST_DIR="$HOME/.local/share/backgrounds"
BACKGROUND_DEST_PATH="$BACKGROUND_DEST_DIR/$(echo $OMAKUB_THEME_BACKGROUND | tr '/' '-')"

if [ ! -d "$BACKGROUND_DEST_DIR" ]; then mkdir -p "$BACKGROUND_DEST_DIR"; fi

[ ! -f "$BACKGROUND_DEST_PATH" ] && cp "$BACKGROUND_ORG_PATH" "$BACKGROUND_DEST_PATH" 2>/dev/null || true
gsettings set org.gnome.desktop.background picture-uri "$BACKGROUND_DEST_PATH" 2>/dev/null || true
gsettings set org.gnome.desktop.background picture-uri-dark "$BACKGROUND_DEST_PATH" 2>/dev/null || true
gsettings set org.gnome.desktop.background picture-options 'zoom' 2>/dev/null || true

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

# Use OMAKUB_BROWSER_COLOR from theme or fallback
BROWSER_COLOR="${OMAKUB_BROWSER_COLOR:-#1a1b26}"

# Root operations (Papirus + apt/deb browser policies) - single pkexec popup
# Uses custom PolicyKit action for clear authentication message
if command -v papirus-folders >/dev/null 2>&1; then
  if [[ -x /usr/local/bin/omakub-theme-root ]]; then
    # Use installed helper with PolicyKit policy (shows clear message)
    echo "DEBUG: Calling pkexec /usr/local/bin/omakub-theme-root $PAPIRUS_COLOR $BROWSER_COLOR"
    pkexec /usr/local/bin/omakub-theme-root "$PAPIRUS_COLOR" "$BROWSER_COLOR" || echo "DEBUG: pkexec failed with code $?"
  else
    # Fallback to inline bash (generic message)
    pkexec bash -c "
      papirus-folders -C '$PAPIRUS_COLOR' --theme Papirus-Dark 2>/dev/null || true
      POLICY='{\"BrowserThemeColor\": \"$BROWSER_COLOR\"}'
      for dir in /etc/chromium/policies/managed /etc/chromium-browser/policies/managed /etc/brave/policies/managed /etc/opt/chrome/policies/managed; do
        mkdir -p \"\$dir\" 2>/dev/null && echo \"\$POLICY\" > \"\$dir/color.json\" 2>/dev/null || true
      done
    " 2>/dev/null || true
  fi
fi

ICON_BASE="/usr/share/icons/Papirus-Dark/48x48/places"
set_folder_icon() {
  local folder_path="$1"
  local icon_name="$2"
  if [[ -d "$folder_path" ]]; then
    if [[ -f "$ICON_BASE/${icon_name}.svg" ]]; then
      if command -v gio >/dev/null 2>&1; then
        local icon_path="/usr/share/icons/Papirus-Dark/128x128/places/${icon_name}.svg"
        if [[ ! -f "$icon_path" ]]; then
          icon_path="$ICON_BASE/${icon_name}.svg"
        fi
        gio set "$folder_path" metadata::custom-icon-name "$icon_name" 2>/dev/null || true
        gio set "$folder_path" metadata::custom-icon "file://$icon_path" 2>/dev/null || true
      fi
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

if [[ -f "$ICON_BASE/folder-code.svg" ]]; then
  set_folder_icon "$HOME/Work" "folder-code"
else
  WORK_ICON="folder-${PAPIRUS_COLOR}-projects"
  if [[ ! -f "$ICON_BASE/${WORK_ICON}.svg" ]]; then
    WORK_ICON="folder-${PAPIRUS_COLOR}"
  fi
  if [[ -f "$ICON_BASE/${WORK_ICON}.svg" ]]; then
    set_folder_icon "$HOME/Work" "$WORK_ICON"
  fi
fi

# Set Games folder icon
GAMES_ICON="folder-${PAPIRUS_COLOR}-games"
if [[ ! -f "$ICON_BASE/${GAMES_ICON}.svg" ]]; then
  GAMES_ICON="folder-games"
fi
set_folder_icon "$HOME/Games" "$GAMES_ICON"

# Set SteamLibrary folder icon (common locations)
STEAM_ICON="folder-${PAPIRUS_COLOR}-steam"
if [[ ! -f "$ICON_BASE/${STEAM_ICON}.svg" ]]; then
  STEAM_ICON="folder-steam"
fi
for steam_path in "$HOME/.steam/steam" "$HOME/SteamLibrary" /media/*/Games/SteamLibrary; do
  if [[ -d "$steam_path" ]]; then
    set_folder_icon "$steam_path" "$STEAM_ICON"
  fi
done
