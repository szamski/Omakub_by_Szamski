#!/bin/bash

# Set WhatsApp icon to Papirus for snap installation

ICON_NAME="whatsapp"
LOCAL_APPS="$HOME/.local/share/applications"

# Check if Papirus icon exists
if [[ ! -f "/usr/share/icons/Papirus-Dark/48x48/apps/${ICON_NAME}.svg" ]]; then
  return 0
fi

mkdir -p "$LOCAL_APPS"

# whatsapp-linux-desktop snap
if [[ -f "/var/lib/snapd/desktop/applications/whatsapp-linux-desktop_whatsapp-linux-desktop.desktop" ]]; then
  cp "/var/lib/snapd/desktop/applications/whatsapp-linux-desktop_whatsapp-linux-desktop.desktop" "$LOCAL_APPS/"
  sed -i "s/^Icon=.*/Icon=${ICON_NAME}/" "$LOCAL_APPS/whatsapp-linux-desktop_whatsapp-linux-desktop.desktop"
  echo "✓ WhatsApp icon set to Papirus"
fi

# whatsapp-for-linux snap (alternative)
if [[ -f "/var/lib/snapd/desktop/applications/whatsapp-for-linux_whatsapp-for-linux.desktop" ]]; then
  cp "/var/lib/snapd/desktop/applications/whatsapp-for-linux_whatsapp-for-linux.desktop" "$LOCAL_APPS/"
  sed -i "s/^Icon=.*/Icon=${ICON_NAME}/" "$LOCAL_APPS/whatsapp-for-linux_whatsapp-for-linux.desktop"
  echo "✓ WhatsApp icon set to Papirus"
fi
