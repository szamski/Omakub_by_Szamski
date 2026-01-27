#!/bin/bash

# Enable debug logging
set -x

sudo apt install -y gnome-shell-extension-manager gir1.2-gtop-2.0 gir1.2-clutter-1.0 libgtop2-dev

EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"

echo "=== DEBUG: Extensions directory: $EXTENSIONS_DIR ==="

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
  echo "Installing extension: $uuid..."
  if gext install "$uuid"; then
    if [[ -d "$EXTENSIONS_DIR/$uuid" ]]; then
      chmod -R go-w "$EXTENSIONS_DIR/$uuid" >/dev/null 2>&1 || true
      echo "✓ Installed: $uuid"
    else
      echo "⚠ Warning: Extension not found after install: $uuid"
    fi
  else
    echo "⚠ Warning: Failed to install extension: $uuid"
  fi
}

# Install new extensions
install_extension "just-perfection-desktop@just-perfection"
install_extension "blur-my-shell@aunetx"
install_extension "AlphabeticalAppGrid@stuarthayhurst"
install_extension "tophat@fflewddur.github.io" || echo "Warning: TopHat extension failed to install"

# Give GNOME Shell time to detect all installed extensions
echo "=== DEBUG: Installed extensions in filesystem ==="
ls -la "$EXTENSIONS_DIR" 2>/dev/null || echo "Extensions directory not found"
echo ""
echo "=== DEBUG: Extensions detected by gnome-extensions ==="
gnome-extensions list 2>&1 || echo "gnome-extensions command failed"
echo ""
echo "Waiting for GNOME Shell to detect extensions..."
sleep 3

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
    gsettings --schemadir "$schema_dir" set "$schema" "$key" "$value" 2>/dev/null || true
  else
    gsettings set "$schema" "$key" "$value" 2>/dev/null || true
  fi
}

# Install local theme switcher extension BEFORE enabling
OMAKUB_PATH="${OMAKUB_PATH:-$HOME/.local/share/omakub}"
LOCAL_THEME_EXT_SRC="$OMAKUB_PATH/extensions/omakub-theme@szamski"
LOCAL_THEME_EXT_DST="$EXTENSIONS_DIR/omakub-theme@szamski"
THEME_ICON_SRC="$OMAKUB_PATH/icons/omakub-theme-symbolic.svg"
THEME_ICON_DST="$HOME/.local/share/icons/hicolor/scalable/apps/omakub-theme-symbolic.svg"
echo "=== DEBUG: Installing local Omakub Theme Switcher extension ==="
echo "  Source: $LOCAL_THEME_EXT_SRC"
echo "  Destination: $LOCAL_THEME_EXT_DST"
if [[ -d "$LOCAL_THEME_EXT_SRC" ]]; then
  echo "  Source directory exists, copying..."
  rm -rf "$LOCAL_THEME_EXT_DST"
  cp -r "$LOCAL_THEME_EXT_SRC" "$LOCAL_THEME_EXT_DST"
  chmod -R go-w "$LOCAL_THEME_EXT_DST" >/dev/null 2>&1 || true
  echo "  Files copied:"
  ls -la "$LOCAL_THEME_EXT_DST" 2>/dev/null || echo "  Failed to list destination"
  # Give GNOME Shell time to detect the new extension
  sleep 2
else
  echo "  ⚠ Source directory not found!"
fi
echo ""
if [[ -f "$THEME_ICON_SRC" ]]; then
  mkdir -p "$(dirname "$THEME_ICON_DST")"
  cp "$THEME_ICON_SRC" "$THEME_ICON_DST"
fi

enable_extension() {
  local target="$1"
  local installed
  
  echo "=== DEBUG: Trying to enable extension: $target ==="
  
  # Check if extension exists in filesystem first
  if [[ -d "$EXTENSIONS_DIR/$target" ]]; then
    echo "  Found in filesystem: $EXTENSIONS_DIR/$target"
    installed="$target"
  else
    echo "  Not found in filesystem, trying gnome-extensions list..."
    # Try to find it via gnome-extensions
    installed=$(gnome-extensions list 2>/dev/null | grep -i "^${target}$" || true)
    if [[ -z "$installed" ]]; then
      installed=$(gnome-extensions list 2>/dev/null | grep -i "${target}" | head -1 || true)
    fi
    if [[ -n "$installed" ]]; then
      echo "  Found via gnome-extensions: $installed"
    fi
  fi
  
  if [[ -n "$installed" ]]; then
    echo "  Attempting to enable: $installed"
    if gnome-extensions enable "$installed" 2>&1; then
      echo "✓ Enabled extension: $installed"
    else
      echo "⚠ Failed to enable extension: $installed"
    fi
  else
    echo "⚠ Extension not found: $target"
  fi
  echo ""
}

echo "=== DEBUG: Checking if gnome-extensions command works ==="
if gnome-extensions list >/dev/null 2>&1; then
  echo "✓ gnome-extensions command is working"
  echo ""
  
  # Enable extensions (ignore failures if not supported)
  enable_extension "just-perfection-desktop@just-perfection"
  enable_extension "blur-my-shell@aunetx"
  enable_extension "alphabetical-app-grid@stuarthayhurst"
  enable_extension "AlphabeticalAppGrid@stuarthayhurst"
  enable_extension "tophat@fflewddur.github.io"
  enable_extension "omakub-theme@szamski"
  
  echo "=== DEBUG: Final state of extensions ==="
  gnome-extensions list --enabled 2>&1 || echo "Failed to list enabled extensions"
  echo ""
  
  echo "Waiting for extensions to fully load..."
  sleep 2
else
  echo "⚠ Warning: GNOME Shell not detected (no DBus session). Skipping extension enable."
fi

# Configure extensions AFTER enabling them
echo "=== DEBUG: Configuring extensions ==="
just_perfection_schema_dir="$(find_schema_dir \
  "$EXTENSIONS_DIR/just-perfection-desktop@just-perfection/schemas")"
echo "Just Perfection schema dir: $just_perfection_schema_dir"
compile_schemas_dir "$just_perfection_schema_dir"

if [[ -n "$just_perfection_schema_dir" ]]; then
  echo "Configuring Just Perfection..."
  gsettings_set "$just_perfection_schema_dir" org.gnome.shell.extensions.just-perfection animation 2
  gsettings_set "$just_perfection_schema_dir" org.gnome.shell.extensions.just-perfection dash-app-running true
  gsettings_set "$just_perfection_schema_dir" org.gnome.shell.extensions.just-perfection workspace true
  gsettings_set "$just_perfection_schema_dir" org.gnome.shell.extensions.just-perfection workspace-popup false
  echo "✓ Just Perfection configured"
else
  echo "⚠ Just Perfection schema not found, skipping configuration"
fi

top_hat_schema_dir="$(find_schema_dir \
  "$EXTENSIONS_DIR/tophat@fflewddur.github.io/schemas")"
echo "TopHat schema dir: $top_hat_schema_dir"
compile_schemas_dir "$top_hat_schema_dir"

if [[ -n "$top_hat_schema_dir" ]]; then
  echo "Configuring TopHat..."
  gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat show-icons false
  gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat show-cpu false
  gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat show-disk false
  gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat show-mem false
  gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat show-fs false
  gsettings_set "$top_hat_schema_dir" org.gnome.shell.extensions.tophat network-usage-unit bits
  echo "✓ TopHat configured"
else
  echo "⚠ TopHat schema not found, skipping configuration"
fi

alphabetical_schema_dir="$(find_schema_dir \
  "$EXTENSIONS_DIR/AlphabeticalAppGrid@stuarthayhurst/schemas" \
  "$EXTENSIONS_DIR/alphabetical-app-grid@stuarthayhurst/schemas")"
echo "AlphabeticalAppGrid schema dir: $alphabetical_schema_dir"
compile_schemas_dir "$alphabetical_schema_dir"

if [[ -n "$alphabetical_schema_dir" ]]; then
  echo "Configuring AlphabeticalAppGrid..."
  gsettings_set "$alphabetical_schema_dir" org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'
  echo "✓ AlphabeticalAppGrid configured"
else
  echo "⚠ AlphabeticalAppGrid schema not found, skipping configuration"
fi

echo ""
echo "=== DEBUG: Extension setup complete ==="
set +x

# Configure Blur My Shell from saved settings
if [[ -f "$OMAKUB_PATH/configs/gnome/blur-my-shell.dconf" ]]; then
  dconf load /org/gnome/shell/extensions/blur-my-shell/ < "$OMAKUB_PATH/configs/gnome/blur-my-shell.dconf"
fi
