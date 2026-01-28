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

# Flatpak installations
[[ -d "$HOME/.var/app/org.chromium.Chromium" ]] && set_user_policy "$HOME/.var/app/org.chromium.Chromium/config/chromium/policies/managed" || true
[[ -d "$HOME/.var/app/com.brave.Browser" ]] && set_user_policy "$HOME/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/policies/managed" || true
[[ -d "$HOME/.var/app/com.google.Chrome" ]] && set_user_policy "$HOME/.var/app/com.google.Chrome/config/google-chrome/policies/managed" || true
