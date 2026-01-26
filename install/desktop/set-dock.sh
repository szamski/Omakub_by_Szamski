#!/bin/bash

# Desired order of applications in Dash
# Format: "display_name:desktop_file_variants"
# First found variant will be used
apps=(
  "ghostty:ghostty_ghostty.desktop,ghostty.desktop"
  "chrome:google-chrome.desktop,chromium-browser.desktop,chromium.desktop"
  "vscode:code.desktop"
  "spotify:spotify_spotify.desktop,spotify.desktop"
  "discord:discord.desktop"
  "slack:slack_slack.desktop,slack.desktop"
  "files:org.gnome.Nautilus.desktop"
)

installed_apps=()

# Search directories for .desktop files
# Including snap directory
desktop_dirs=(
  "/var/lib/snapd/desktop/applications"
  "/var/lib/flatpak/exports/share/applications"
  "/usr/share/applications"
  "/usr/local/share/applications"
  "$HOME/.local/share/applications"
)

# Find and add installed apps in order
for app_entry in "${apps[@]}"; do
  # Split "display_name:variants" format
  IFS=':' read -r display_name variants <<< "$app_entry"
  
  # Split variants by comma
  IFS=',' read -ra variant_list <<< "$variants"
  
  # Try each variant until we find an installed one
  found=false
  for variant in "${variant_list[@]}"; do
    for dir in "${desktop_dirs[@]}"; do
      if [ -f "$dir/$variant" ]; then
        installed_apps+=("$variant")
        found=true
        break 2  # Break both loops
      fi
    done
  done
done

# Create favorites list
favorites_list=$(printf "'%s'," "${installed_apps[@]}")
favorites_list="[${favorites_list%,}]"

# Set GNOME favorites
gsettings set org.gnome.shell favorite-apps "$favorites_list"

echo "✓ GNOME Dash favorites set:"
for app in "${installed_apps[@]}"; do
  echo "  - $app"
done
