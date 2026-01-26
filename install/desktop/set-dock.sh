#!/bin/bash

# Desired order of applications in Dash
# Format: "display_name:desktop_file_variants"
# First found variant will be used
apps=(
  "ghostty:ghostty_ghostty.desktop,ghostty.desktop"
  "files:org.gnome.Nautilus.desktop"
  "chromium:org.chromium.Chromium.desktop,chromium-browser.desktop,chromium.desktop,google-chrome.desktop"
  "vscode:code.desktop"
  "spotify:spotify_spotify.desktop,spotify.desktop"
  "riff:dev.diegovsky.Riff.desktop"
  "discord:discord.desktop"
  "slack:slack_slack.desktop,slack.desktop"
  "libreoffice:libreoffice-startcenter.desktop"
  "localsend:org.localsend.localsend_app.desktop"
)

installed_apps=()

# Search directories for .desktop files
# Including snap directory
desktop_dirs=(
  "/var/lib/snapd/desktop/applications"
  "/var/lib/flatpak/exports/share/applications"
  "$HOME/.local/share/flatpak/exports/share/applications"
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

# Define preferred order - this will be order we try to achieve
preferred_order=(
  "ghostty_ghostty.desktop"
  "org.gnome.Nautilus.desktop" 
  "org.chromium.Chromium.desktop"
  "google-chrome.desktop"
  "code.desktop"
  "spotify_spotify.desktop"
  "dev.diegovsky.Riff.desktop"
  "discord.desktop"
  "slack_slack.desktop"
  "libreoffice-startcenter.desktop"
  "org.localsend.localsend_app.desktop"
)

# Create ordered list - maintain original order but sort by preferred order
ordered_apps=()
for preferred_app in "${preferred_order[@]}"; do
  for installed_app in "${installed_apps[@]}"; do
    if [[ "$installed_app" == "$preferred_app" ]]; then
      ordered_apps+=("$installed_app")
      break
    fi
  done
done

# Add any remaining apps not in preferred order
for installed_app in "${installed_apps[@]}"; do
  found=false
  for ordered_app in "${ordered_apps[@]}"; do
    if [[ "$installed_app" == "$ordered_app" ]]; then
      found=true
      break
    fi
  done
  if [[ "$found" == false ]]; then
    ordered_apps+=("$installed_app")
  fi
done

# Create favorites list
favorites_list=$(printf "'%s'," "${ordered_apps[@]}")
favorites_list="[${favorites_list%,}]"

# Set GNOME favorites
gsettings set org.gnome.shell favorite-apps "$favorites_list"

echo "✓ GNOME Dash favorites set:"
for app in "${ordered_apps[@]}"; do
  echo "  - $app"
done

echo ""
echo "📋 Final order in GNOME Dash:"
echo "  1. Ghostty"
echo "  2. Files (Nautilus)"
echo "  3. Chrome/Chromium"
echo "  4. VS Code"
echo "  5. Spotify"
echo "  6. Discord"
echo "  7. Slack"
