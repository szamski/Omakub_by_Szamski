#!/bin/bash

# Set Papirus icons for web apps (PWAs) and snap apps

LOCAL_APPS="$HOME/.local/share/applications"
SNAP_APPS="/var/lib/snapd/desktop/applications"

mkdir -p "$LOCAL_APPS"

set_icon_for_desktop() {
  local desktop_file="$1"
  local icon_name="$2"

  if [[ -f "$desktop_file" ]]; then
    if grep -q '^Icon=' "$desktop_file"; then
      sed -i "s/^Icon=.*/Icon=${icon_name}/" "$desktop_file"
    else
      echo "Icon=${icon_name}" >> "$desktop_file"
    fi
    return 0
  fi
  return 1
}

# WhatsApp - check snap first, then local
WHATSAPP_SET=false

# Check snap WhatsApp
for snap_file in "$SNAP_APPS"/*whatsapp*.desktop "$SNAP_APPS"/*WhatsApp*.desktop; do
  if [[ -f "$snap_file" ]]; then
    local_copy="$LOCAL_APPS/$(basename "$snap_file")"
    cp "$snap_file" "$local_copy"
    set_icon_for_desktop "$local_copy" "whatsapp"
    echo "✓ WhatsApp (snap) icon set to Papirus"
    WHATSAPP_SET=true
    break
  fi
done

# Check local webapp if snap not found
if [[ "$WHATSAPP_SET" == false ]]; then
  for desktop_file in "$LOCAL_APPS"/*WhatsApp*.desktop "$LOCAL_APPS"/*whatsapp*.desktop; do
    if [[ -f "$desktop_file" ]]; then
      set_icon_for_desktop "$desktop_file" "whatsapp"
      echo "✓ WhatsApp icon set to Papirus"
      break
    fi
  done
fi
