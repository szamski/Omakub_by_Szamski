#!/bin/bash

# Set browser theme color for snap/flatpak Chromium-based browsers
# apt/deb browsers are handled in set-gnome-theme.sh (single pkexec)
# Uses OMAKUB_BROWSER_COLOR from theme's gnome.sh

BROWSER_COLOR="${OMAKUB_BROWSER_COLOR:-#1a1b26}"
POLICY_CONTENT="{\"BrowserThemeColor\": \"$BROWSER_COLOR\"}"

set_user_policy() {
  local policy_dir="$1"
  mkdir -p "$policy_dir" 2>/dev/null || return 1
  echo "$POLICY_CONTENT" > "$policy_dir/color.json" 2>/dev/null
}

# Snap installations
[[ -d "$HOME/snap/chromium" ]] && set_user_policy "$HOME/snap/chromium/current/.config/chromium/policies/managed" || true
[[ -d "$HOME/snap/brave" ]] && set_user_policy "$HOME/snap/brave/current/.config/BraveSoftware/Brave-Browser/policies/managed" || true

# Flatpak installations - use filesystem override to expose host policies
# Create policy in ~/.config and give flatpak read access

# Flatpak installations use ~/.var/app/<app-id>/config/ as XDG_CONFIG_HOME
# Chromium Flatpak
if flatpak list --app 2>/dev/null | grep -q "org.chromium.Chromium"; then
  set_user_policy "$HOME/.var/app/org.chromium.Chromium/config/chromium/policies/managed"
fi

# Brave Flatpak
if flatpak list --app 2>/dev/null | grep -q "com.brave.Browser"; then
  set_user_policy "$HOME/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/policies/managed"
fi

# Google Chrome Flatpak
if flatpak list --app 2>/dev/null | grep -q "com.google.Chrome"; then
  set_user_policy "$HOME/.var/app/com.google.Chrome/config/google-chrome/policies/managed"
fi
