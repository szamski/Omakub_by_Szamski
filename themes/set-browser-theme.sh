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

# Flatpak installations - use extension point paths
# Chromium Flatpak reads policies from extension points, not config directory
ARCH="$(flatpak --default-arch 2>/dev/null || echo x86_64)"

# Chromium Flatpak
if flatpak list --app 2>/dev/null | grep -q "org.chromium.Chromium"; then
  set_user_policy "$HOME/.local/share/flatpak/extension/org.chromium.Chromium.Policy/$ARCH/1/policies/managed"
fi

# Brave Flatpak
if flatpak list --app 2>/dev/null | grep -q "com.brave.Browser"; then
  set_user_policy "$HOME/.local/share/flatpak/extension/com.brave.Browser.Policy/$ARCH/1/policies/managed"
fi

# Google Chrome Flatpak
if flatpak list --app 2>/dev/null | grep -q "com.google.Chrome"; then
  set_user_policy "$HOME/.local/share/flatpak/extension/com.google.Chrome.Policy/$ARCH/1/policies/managed"
fi
