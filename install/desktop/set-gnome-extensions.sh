#!/bin/bash

sudo apt install -y gnome-shell-extension-manager gir1.2-gtop-2.0 gir1.2-clutter-1.0

EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"

if command -v gext >/dev/null 2>&1; then
  echo "⏭️  gnome-extensions-cli already installed"
else
  pipx install gnome-extensions-cli
fi

# Pause to assure user is ready to accept confirmations
if command -v gum >/dev/null 2>&1; then
  gum confirm "To install Gnome extensions, you need to accept some confirmations. Ready?"
else
  read -r -p "To install Gnome extensions, you need to accept some confirmations. Ready? (y/N) " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || return 0
fi

install_extension() {
  local uuid="$1"
  gext install "$uuid" || true
  if [[ -d "$EXTENSIONS_DIR/$uuid" ]]; then
    chmod -R go-w "$EXTENSIONS_DIR/$uuid" >/dev/null 2>&1 || true
  else
    echo "Warning: Extension not found after install: $uuid"
  fi
}

# Install new extensions
install_extension "just-perfection-desktop@just-perfection"
install_extension "blur-my-shell@aunetx"
install_extension "AlphabeticalAppGrid@stuarthayhurst"
install_extension "tophat@fflewddur.github.io"

OMAKUB_PATH="${OMAKUB_PATH:-$HOME/.local/share/omakub}"
# Install local theme switcher extension
LOCAL_THEME_EXT_SRC="$OMAKUB_PATH/extensions/omakub-theme@szamski"
LOCAL_THEME_EXT_DST="$EXTENSIONS_DIR/omakub-theme@szamski"
THEME_ICON_SRC="$OMAKUB_PATH/icons/omakub-theme-symbolic.svg"
THEME_ICON_DST="$HOME/.local/share/icons/hicolor/scalable/apps/omakub-theme-symbolic.svg"
if [[ -d "$LOCAL_THEME_EXT_SRC" ]]; then
  rm -rf "$LOCAL_THEME_EXT_DST"
  cp -r "$LOCAL_THEME_EXT_SRC" "$LOCAL_THEME_EXT_DST"
  chmod -R go-w "$LOCAL_THEME_EXT_DST" >/dev/null 2>&1 || true
fi
if [[ -f "$THEME_ICON_SRC" ]]; then
  mkdir -p "$(dirname "$THEME_ICON_DST")"
  cp "$THEME_ICON_SRC" "$THEME_ICON_DST"
fi

find_schema_dir() {
  for dir in "$@"; do
    if [[ -d "$dir" ]]; then
      echo "$dir"
      return 0
    fi
  done
  return 1
}

compile_schemas_dir() {
  local dir="$1"
  if [[ -n "$dir" && -d "$dir" ]]; then
    if [[ ! -f "$dir/gschemas.compiled" ]]; then
      glib-compile-schemas "$dir" >/dev/null 2>&1 || true
    fi
  fi
}

gsettings_set() {
  local schema_dir="$1"
  local schema="$2"
  local key="$3"
  local value="$4"
  if [[ -n "$schema_dir" && -d "$schema_dir" ]]; then
    gsettings --schemadir "$schema_dir" set "$schema" "$key" "$value"
  else
    gsettings set "$schema" "$key" "$value"
  fi
}

just_perfection_schema_dir="$(find_schema_dir \
  "$EXTENSIONS_DIR/just-perfection-desktop@just-perfection/schemas")"
compile_schemas_dir "$just_perfection_schema_dir"

# Configure Just Perfection
gsettings_set "$just_perfection_schema_dir" org.gnome.shell.extensions.just-perfection animation 2
gsettings_set "$just_perfection_schema_dir" org.gnome.shell.extensions.just-perfection dash-app-running true
gsettings_set "$just_perfection_schema_dir" org.gnome.shell.extensions.just-perfection workspace true
gsettings_set "$just_perfection_schema_dir" org.gnome.shell.extensions.just-perfection workspace-popup false

top_hat_schema_dir="$(find_schema_dir \
  "$EXTENSIONS_DIR/tophat@fflewddur.github.io/schemas")"
compile_schemas_dir "$top_hat_schema_dir"

# Configure TopHat
gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat show-icons false
gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat show-cpu false
gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat show-disk false
gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat show-mem false
gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat show-fs false
gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat network-usage-unit bits

alphabetical_schema_dir="$(find_schema_dir \
  "$EXTENSIONS_DIR/AlphabeticalAppGrid@stuarthayhurst/schemas" \
  "$EXTENSIONS_DIR/alphabetical-app-grid@stuarthayhurst/schemas")"
compile_schemas_dir "$alphabetical_schema_dir"

# Configure AlphabeticalAppGrid
gsettings_set "$alphabetical_schema_dir" org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'

enable_extension() {
  local target="$1"
  local installed
  installed=$(gnome-extensions list 2>/dev/null | grep -i "^${target}$" || true)
  if [[ -z "$installed" ]]; then
    installed=$(gnome-extensions list 2>/dev/null | grep -i "${target}" | head -1 || true)
  fi
  if [[ -n "$installed" ]]; then
    gnome-extensions enable "$installed" >/dev/null 2>&1 || true
  fi
}

if gnome-extensions list >/dev/null 2>&1; then
  # Enable extensions (ignore failures if not supported)
  enable_extension "just-perfection-desktop@just-perfection"
  enable_extension "blur-my-shell@aunetx"
  enable_extension "alphabetical-app-grid@stuarthayhurst"
  enable_extension "AlphabeticalAppGrid@stuarthayhurst"
  enable_extension "tophat@fflewddur.github.io"
  enable_extension "omakub-theme@szamski"
else
  echo "Warning: GNOME Shell not detected (no DBus session). Skipping extension enable."
fi

# Configure Blur My Shell from saved settings
if [[ -f "$OMAKUB_PATH/configs/gnome/blur-my-shell.dconf" ]]; then
  dconf load /org/gnome/shell/extensions/blur-my-shell/ < "$OMAKUB_PATH/configs/gnome/blur-my-shell.dconf"
fi
