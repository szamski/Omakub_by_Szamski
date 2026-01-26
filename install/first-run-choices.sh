#!/bin/bash

# Browser choice
BROWSER_SELECTED=$(gum choose "Google Chrome" "Chromium" "None - Skip" --header "Select browser to install")

case "$BROWSER_SELECTED" in
  "Google Chrome")
    export SETUP_CHROME=true
    export SETUP_CHROMIUM=false
    ;;
  "Chromium")
    export SETUP_CHROME=false
    export SETUP_CHROMIUM=true
    ;;
  *)
    export SETUP_CHROME=false
    export SETUP_CHROMIUM=false
    ;;
esac

# Desktop apps (GNOME only)
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  DESKTOP_APPS=(
    "VS Code"
    "Discord"
    "Slack"
    "Spotify"
    "1Password"
    "Dropbox"
  )

  DEFAULT_APPS="VS Code"
  SELECTED_APPS=$(gum choose "${DESKTOP_APPS[@]}" --no-limit --selected "$DEFAULT_APPS" --header "Select desktop apps to install")

  export SETUP_VSCODE=false
  export SETUP_DISCORD=false
  export SETUP_SLACK=false
  export SETUP_SPOTIFY=false
  export SETUP_1PASSWORD=false
  export SETUP_DROPBOX=false

  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "VS Code"; then
    export SETUP_VSCODE=true
  fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "Discord"; then
    export SETUP_DISCORD=true
  fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "Slack"; then
    export SETUP_SLACK=true
  fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "Spotify"; then
    export SETUP_SPOTIFY=true
  fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "1Password"; then
    export SETUP_1PASSWORD=true
  fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "Dropbox"; then
    export SETUP_DROPBOX=true
  fi

  if [[ "$SETUP_VSCODE" == true ]] && snap list code >/dev/null 2>&1; then
    VSCODE_SWITCH=$(gum choose "Switch to .deb (recommended)" "Keep snap" --header "VS Code source")
    if [[ "$VSCODE_SWITCH" == "Switch to .deb (recommended)" ]]; then
      export VSCODE_REMOVE_SNAP=true
    else
      export VSCODE_REMOVE_SNAP=false
    fi
  fi

  if [[ "$SETUP_DISCORD" == true ]] && snap list discord >/dev/null 2>&1; then
    DISCORD_SWITCH=$(gum choose "Switch to .deb" "Keep snap" --header "Discord source")
    if [[ "$DISCORD_SWITCH" == "Switch to .deb" ]]; then
      export DISCORD_REMOVE_SNAP=true
    else
      export DISCORD_REMOVE_SNAP=false
    fi
  fi

  if [[ "$SETUP_SPOTIFY" == true ]] && snap list spotify >/dev/null 2>&1; then
    SPOTIFY_SWITCH=$(gum choose "Switch to .deb" "Keep snap" --header "Spotify source")
    if [[ "$SPOTIFY_SWITCH" == "Switch to .deb" ]]; then
      export SPOTIFY_REMOVE_SNAP=true
    else
      export SPOTIFY_REMOVE_SNAP=false
    fi
  fi
fi

# VPN choice
VPN_SELECTED=$(gum choose "Both (Tailscale + NordVPN)" "Only Tailscale" "Only NordVPN" "None" --header "Select VPN setup")

case "$VPN_SELECTED" in
  "Both (Tailscale + NordVPN)")
    export SETUP_TAILSCALE=true
    export SETUP_NORDVPN=true
    ;;
  "Only Tailscale")
    export SETUP_TAILSCALE=true
    export SETUP_NORDVPN=false
    ;;
  "Only NordVPN")
    export SETUP_TAILSCALE=false
    export SETUP_NORDVPN=true
    ;;
  *)
    export SETUP_TAILSCALE=false
    export SETUP_NORDVPN=false
    ;;
esac

# Laptop power management (TLP)
CHASSIS_TYPE=$(cat /sys/class/dmi/id/chassis_type 2>/dev/null || echo "0")
if [[ "$CHASSIS_TYPE" =~ ^(8|9|10|14)$ ]]; then
  export IS_LAPTOP=true

  if command -v tlp >/dev/null 2>&1; then
    TLP_CHOICE=$(gum choose "Optimize TLP for laptop" "Keep current TLP config" "Skip TLP" --header "TLP configuration")
    case "$TLP_CHOICE" in
      "Optimize TLP for laptop")
        export SETUP_TLP=true
        export TLP_OPTIMIZE=true
        ;;
      "Keep current TLP config")
        export SETUP_TLP=true
        export TLP_OPTIMIZE=false
        ;;
      *)
        export SETUP_TLP=false
        export TLP_OPTIMIZE=false
        ;;
    esac
  else
    TLP_INSTALL=$(gum choose "Yes" "No" --header "Install and optimize TLP for battery life?")
    if [[ "$TLP_INSTALL" == "Yes" ]]; then
      export SETUP_TLP=true
      export TLP_OPTIMIZE=true
    else
      export SETUP_TLP=false
    fi
  fi
else
  export IS_LAPTOP=false
  export SETUP_TLP=false
fi

# Config overwrite strategy
CONFIG_STRATEGY=$(gum choose "Auto backup and overwrite" "Keep existing configs" --header "Config file strategy")
if [[ "$CONFIG_STRATEGY" == "Auto backup and overwrite" ]]; then
  export AUTO_BACKUP=true
else
  export AUTO_BACKUP=false
fi
