#!/bin/bash

apps=(
  "google-chrome.desktop"
  "chromium-browser.desktop"
  "chromium.desktop"
  "ghostty.desktop"
  "Neovim.desktop"
  "code.desktop"
  "discord.desktop"
  "slack.desktop"
  "spotify.desktop"
  "ulauncher.desktop"
  "1password.desktop"
  "org.gnome.Settings.desktop"
  "org.gnome.Nautilus.desktop"
)

installed_apps=()

desktop_dirs=(
  "/var/lib/flatpak/exports/share/applications"
  "/usr/share/applications"
  "/usr/local/share/applications"
  "$HOME/.local/share/applications"
)

for app in "${apps[@]}"; do
  for dir in "${desktop_dirs[@]}"; do
    if [ -f "$dir/$app" ]; then
      installed_apps+=("$app")
      break
    fi
  done
done

favorites_list=$(printf "'%s'," "${installed_apps[@]}")
favorites_list="[${favorites_list%,}]"

gsettings set org.gnome.shell favorite-apps "$favorites_list"
