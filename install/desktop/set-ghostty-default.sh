#!/bin/bash

GHOSTTY_BIN="$(command -v ghostty 2>/dev/null || true)"
GHOSTTY_DESKTOP=""

# Fallback to system/local desktop file
if [[ -f "/usr/share/applications/com.mitchellh.ghostty.desktop" ]] || [[ -f "$HOME/.local/share/applications/com.mitchellh.ghostty.desktop" ]]; then
  GHOSTTY_DESKTOP="com.mitchellh.ghostty.desktop"
fi

if [[ -z "$GHOSTTY_BIN" ]]; then
  echo "Warning: Ghostty not found, skipping default terminal"
  return 0
fi

if [[ -z "$GHOSTTY_DESKTOP" ]]; then
  GHOSTTY_DESKTOP="com.mitchellh.ghostty.desktop"
fi

# Register alternative if needed, then set it
if ! update-alternatives --display x-terminal-emulator >/dev/null 2>&1; then
  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$GHOSTTY_BIN" 50 || true
fi

sudo update-alternatives --set x-terminal-emulator "$GHOSTTY_BIN" || true
echo "Done: Ghostty set as default terminal"

# Prefer Ghostty for GNOME/Nautilus via xdg-terminal-exec
if ! command -v xdg-terminal-exec >/dev/null 2>&1; then
  sudo apt install -y xdg-terminal-exec || true
fi

if command -v xdg-terminal-exec >/dev/null 2>&1; then
  mkdir -p ~/.config
  printf "%s\n" "$GHOSTTY_DESKTOP" > ~/.config/xdg-terminals.list
  gsettings set org.gnome.desktop.default-applications.terminal exec "xdg-terminal-exec"
  gsettings set org.gnome.desktop.default-applications.terminal exec-arg ""
  echo "Done: GNOME terminal set to xdg-terminal-exec (using $GHOSTTY_DESKTOP)"
fi
