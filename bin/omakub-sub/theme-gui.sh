#!/bin/bash

OMAKUB_SZAMSKI_PATH="${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub-szamski}"
APP_DIR="$OMAKUB_SZAMSKI_PATH/apps/theme-switcher"
BIN="$APP_DIR/target/release/omakub-theme-switcher"

if ! command -v cargo >/dev/null 2>&1; then
  echo "Rust toolchain not found. Install rustc/cargo first."
  exit 1
fi

if ! pkg-config --exists gtk4; then
  echo "GTK4 dev package not found. Install: sudo apt install -y libgtk-4-dev"
  exit 1
fi

if [[ ! -x "$BIN" ]]; then
  echo "Building theme switcher..."
  (cd "$APP_DIR" && cargo build --release)
fi

"$BIN"
