#!/bin/bash

OMAKUB_SZAMSKI_PATH="${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub-szamski}"
APP_DIR="$OMAKUB_SZAMSKI_PATH/apps/theme-switcher"
BIN="$APP_DIR/target/release/omakub-theme-switcher"

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
  echo "✓ Theme switcher GUI built"
fi
