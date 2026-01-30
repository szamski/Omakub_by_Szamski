#!/bin/bash

# Browser choice
BROWSER_SELECTED=$(gum choose "Google Chrome" "None - Skip" --header "Select browser to install")

case "$BROWSER_SELECTED" in
  "Google Chrome")
    export SETUP_CHROME=true
    ;;
  *)
    export SETUP_CHROME=false
    ;;
esac

# Ghostty window size
GHOSTTY_SIZE=$(gum choose "Full HD (150x45)" "1440p (170x50)" "4K (200x60)" "Custom" --header "Ghostty window size")
case "$GHOSTTY_SIZE" in
  "Full HD (150x45)")
    export GHOSTTY_WINDOW_WIDTH=150
    export GHOSTTY_WINDOW_HEIGHT=45
    ;;
  "1440p (170x50)")
    export GHOSTTY_WINDOW_WIDTH=170
    export GHOSTTY_WINDOW_HEIGHT=50
    ;;
  "4K (200x60)")
    export GHOSTTY_WINDOW_WIDTH=200
    export GHOSTTY_WINDOW_HEIGHT=60
    ;;
  "Custom")
    CUSTOM_WIDTH=$(gum input --header "Ghostty window width (columns)" --placeholder "150")
    CUSTOM_HEIGHT=$(gum input --header "Ghostty window height (rows)" --placeholder "55")
    export GHOSTTY_WINDOW_WIDTH="${CUSTOM_WIDTH:-150}"
    export GHOSTTY_WINDOW_HEIGHT="${CUSTOM_HEIGHT:-55}"
    ;;
esac

GHOSTTY_SIZE_FILE="$HOME/.config/omakub/ghostty-window-size.env"
mkdir -p "$(dirname "$GHOSTTY_SIZE_FILE")"
printf "GHOSTTY_WINDOW_WIDTH=%s\nGHOSTTY_WINDOW_HEIGHT=%s\n" \
  "${GHOSTTY_WINDOW_WIDTH:-150}" "${GHOSTTY_WINDOW_HEIGHT:-55}" > "$GHOSTTY_SIZE_FILE"

# Desktop apps (GNOME only)
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  THEME_NAMES=(
    "Tokyo Night"
    "Catppuccin"
    "Nord"
    "Everforest"
    "Gruvbox"
    "Kanagawa"
    "Ristretto"
    "Rose Pine"
    "Matte Black"
    "Osaka Jade"
  )
  THEME_SELECTED=$(gum choose "${THEME_NAMES[@]}" --header "Select theme" --selected "Catppuccin")
  export OMAKUB_THEME=$(echo "$THEME_SELECTED" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
  if [[ -z "$OMAKUB_THEME" ]]; then
    export OMAKUB_THEME="catppuccin"
  fi

  DESKTOP_APPS=(
    "VSCodium"
    "Discord"
    "Slack"
    "Spotify"
    "LibreOffice"
    "1Password"
    "Dropbox"
    "Bambu Studio (3D Printing)"
  )

  DEFAULT_APPS="VSCodium"
  SELECTED_APPS=$(gum choose "${DESKTOP_APPS[@]}" --no-limit --selected "$DEFAULT_APPS" --header "Select desktop apps to install")

  export SETUP_CODIUM=false
  export SETUP_DISCORD=false
  export SETUP_SLACK=false
  export SETUP_SPOTIFY=false
  export SETUP_LIBREOFFICE=false
  export SETUP_1PASSWORD=false
  export SETUP_DROPBOX=false
  export SETUP_BAMBUSTUDIO=false

  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "VSCodium"; then
    export SETUP_CODIUM=true
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
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "LibreOffice"; then
    export SETUP_LIBREOFFICE=true
  fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "1Password"; then
    export SETUP_1PASSWORD=true
  fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "Dropbox"; then
    export SETUP_DROPBOX=true
  fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "Bambu Studio (3D Printing)"; then
    export SETUP_BAMBUSTUDIO=true
  fi

  if [[ "$SETUP_CODIUM" == true ]] && snap list codium >/dev/null 2>&1; then
    CODIUM_SWITCH=$(gum choose "Switch to .deb (recommended)" "Keep snap" --header "VSCodium source")
    if [[ "$CODIUM_SWITCH" == "Switch to .deb (recommended)" ]]; then
      export CODIUM_REMOVE_SNAP=true
    else
      export CODIUM_REMOVE_SNAP=false
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

fi

# AI Tools choice
AI_TOOLS=(
  "Claude Code (Anthropic CLI)"
  "OpenCode"
)

SELECTED_AI=$(gum choose "${AI_TOOLS[@]}" --no-limit --header "Select AI coding tools to install (optional)")

export SETUP_CLAUDE_CODE=false
export SETUP_OPENCODE=false

if printf '%s\n' "$SELECTED_AI" | grep -Fxq "Claude Code (Anthropic CLI)"; then
  export SETUP_CLAUDE_CODE=true
fi
if printf '%s\n' "$SELECTED_AI" | grep -Fxq "OpenCode"; then
  export SETUP_OPENCODE=true
fi

# Gaming choice
GAMING_CHOICE=$(gum choose "Install Steam" "Skip Gaming" --header "Gaming setup")
if [[ "$GAMING_CHOICE" == "Install Steam" ]]; then
  export SETUP_STEAM=true
else
  export SETUP_STEAM=false
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
