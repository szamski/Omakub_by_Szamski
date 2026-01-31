#!/bin/bash

OMAKUB_SZAMSKI_PATH="${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub-szamski}"
APP_DIR="$OMAKUB_SZAMSKI_PATH/apps/theme-switcher"
BIN="$APP_DIR/target/release/omakub-theme-switcher"
DESKTOP_SRC="$APP_DIR/omakub-theme-switcher.desktop"
DESKTOP_DST="$HOME/.local/share/applications/omakub-theme-switcher.desktop"
ICON_SRC="$OMAKUB_SZAMSKI_PATH/icons/omacom.png"
ICON_DST="$HOME/.local/share/icons/hicolor/512x512/apps/omacom.png"
WRAPPER_SRC="$OMAKUB_SZAMSKI_PATH/bin/omakub-theme-switcher"
WRAPPER_DST="$HOME/.local/bin/omakub-theme-switcher"

if ! command -v cargo >/dev/null 2>&1; then
  echo "Rust toolchain not found. Skipping GUI build."
  return 0
fi

if ! pkg-config --exists gtk4; then
  echo "GTK4 dev package not found. Skipping GUI build."
  return 0
fi

if [[ ! -d "$APP_DIR" ]]; then
  echo "Theme switcher app not found. Skipping GUI build."
  return 0
fi

echo "Building theme switcher GUI..."
(cd "$APP_DIR" && cargo build --release)

if [[ -x "$BIN" ]]; then
echo "Done: Theme switcher GUI built"
  if [[ -f "$DESKTOP_SRC" ]]; then
    mkdir -p "$(dirname "$DESKTOP_DST")"
    cp "$DESKTOP_SRC" "$DESKTOP_DST"
    echo "Done: Theme switcher desktop entry installed"
  fi
  if [[ -f "$ICON_SRC" ]]; then
    mkdir -p "$(dirname "$ICON_DST")"
    cp "$ICON_SRC" "$ICON_DST"
  echo "Done: Theme switcher icon installed"
  fi
  if [[ -f "$WRAPPER_SRC" ]]; then
    mkdir -p "$(dirname "$WRAPPER_DST")"
    cp "$WRAPPER_SRC" "$WRAPPER_DST"
    chmod +x "$WRAPPER_DST"
  echo "Done: Theme switcher launcher installed"
  fi
fi
