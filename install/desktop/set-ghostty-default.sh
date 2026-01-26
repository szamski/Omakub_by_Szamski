#!/bin/bash

GHOSTTY_BIN="$(command -v ghostty 2>/dev/null || true)"
if [[ -x "/snap/bin/ghostty" ]]; then
  GHOSTTY_BIN="/snap/bin/ghostty"
fi
if [[ -z "$GHOSTTY_BIN" ]]; then
  echo "⚠️  Ghostty not found, skipping default terminal"
  return 0
fi

# Register alternative if needed, then set it
if ! update-alternatives --display x-terminal-emulator >/dev/null 2>&1; then
  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$GHOSTTY_BIN" 50 || true
fi

sudo update-alternatives --set x-terminal-emulator "$GHOSTTY_BIN" || true
echo "✓ Ghostty set as default terminal"
