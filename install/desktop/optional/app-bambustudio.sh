#!/bin/bash

# Install Bambu Studio (3D printing slicer) via Flatpak
if flatpak list --app 2>/dev/null | grep -q "com.bambulab.BambuStudio"; then
  echo "⏭️  Bambu Studio already installed"
else
  echo "Installing Bambu Studio..."
  flatpak install -y flathub com.bambulab.BambuStudio
fi

# Set Papirus icon for Bambu Studio
DESKTOP_FILE="$HOME/.local/share/applications/com.bambulab.BambuStudio.desktop"
FLATPAK_DESKTOP="/var/lib/flatpak/app/com.bambulab.BambuStudio/current/active/export/share/applications/com.bambulab.BambuStudio.desktop"

# Check if Papirus has a bambu/3d-printer icon
PAPIRUS_ICON=""
for icon_name in "bambu-studio" "bambustudio" "3d-printer" "cura"; do
  if [[ -f "/usr/share/icons/Papirus-Dark/48x48/apps/${icon_name}.svg" ]]; then
    PAPIRUS_ICON="$icon_name"
    break
  fi
done

if [[ -n "$PAPIRUS_ICON" && -f "$FLATPAK_DESKTOP" ]]; then
  mkdir -p "$(dirname "$DESKTOP_FILE")"
  cp "$FLATPAK_DESKTOP" "$DESKTOP_FILE"
  sed -i "s/^Icon=.*/Icon=$PAPIRUS_ICON/" "$DESKTOP_FILE"
  echo "✓ Bambu Studio installed with Papirus icon ($PAPIRUS_ICON)"
else
  echo "✓ Bambu Studio installed"
fi
