#!/bin/bash

ICON_NAME="com.mitchellh.ghostty"
ICON_FILE="/usr/share/icons/Papirus-Dark/48x48/apps/${ICON_NAME}.svg"

if [[ ! -f "$ICON_FILE" ]]; then
  return 0
fi

LOCAL_APPS="$HOME/.local/share/applications"
mkdir -p "$LOCAL_APPS"

for desktop_file in /usr/share/applications/ghostty.desktop /usr/local/share/applications/ghostty.desktop; do
  if [[ -f "$desktop_file" ]]; then
    cp "$desktop_file" "$LOCAL_APPS/ghostty.desktop"
    if grep -q '^Icon=' "$LOCAL_APPS/ghostty.desktop"; then
      sed -i "s/^Icon=.*/Icon=${ICON_NAME}/" "$LOCAL_APPS/ghostty.desktop"
    else
      echo "Icon=${ICON_NAME}" >> "$LOCAL_APPS/ghostty.desktop"
    fi
    break
  fi
done

echo "Done: Ghostty icon set to Papirus"
