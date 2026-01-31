#!/bin/bash

GUM_HEIGHT_DEFAULT=12
GUM_HEIGHT_SHORT=6
GUM_HEIGHT_TALL=15

# Progress tracking for configuration steps (dynamically calculated)
CHOICE_TOTAL=10  # Base: Browser, Ghostty, Terminal Tools, Languages, Databases, AI Tools, Gaming, NordVPN, Config Strategy, Pre-flight
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  CHOICE_TOTAL=$((CHOICE_TOTAL + 3))  # Theme, Desktop Apps, Web Apps
fi
CHASSIS_TYPE=$(cat /sys/class/dmi/id/chassis_type 2>/dev/null || echo "0")
if [[ "$CHASSIS_TYPE" =~ ^(8|9|10|14)$ ]]; then
  CHOICE_TOTAL=$((CHOICE_TOTAL + 1))  # TLP for laptops
fi
CHOICE_CURRENT=0

show_choice_progress() {
  CHOICE_CURRENT=$((CHOICE_CURRENT+1))
  if command -v gum >/dev/null 2>&1; then
    gum style --border rounded --padding "0 2" --border-foreground 99 \
      "Configuration Step $CHOICE_CURRENT/$CHOICE_TOTAL"
  else
    echo "Configuration Step $CHOICE_CURRENT/$CHOICE_TOTAL"
  fi
}

gum_choose() {
  local header="$1"
  local default_value="$2"
  shift 2
  local result
  result=$(gum choose --height "$GUM_HEIGHT_DEFAULT" --header "$header" "$@" || true)
  if [[ -z "$result" ]]; then
    result="$default_value"
  fi
  printf "%s" "$result"
}

gum_choose_multi() {
  local header="$1"
  local selected="$2"
  shift 2
  local result
  result=$(gum choose --no-limit --height "$GUM_HEIGHT_DEFAULT" --selected "$selected" --header "$header" "$@" || true)
  printf "%s" "$result"
}

# Browser choice
gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Welcome to Omakub by Szamski Installer"

show_choice_progress
BROWSER_SELECTED=$(gum_choose "Select browser to install" "None - Skip" "Google Chrome" "None - Skip")

case "$BROWSER_SELECTED" in
  "Google Chrome")
    export SETUP_CHROME=true
    ;;
  *)
    export SETUP_CHROME=false
    ;;
esac

# Ghostty window size
show_choice_progress
GHOSTTY_SIZE=$(gum_choose "Ghostty window size" "Full HD (150x45)" "Full HD (150x45)" "1440p (170x50)" "4K (200x60)" "Custom")
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
    CUSTOM_WIDTH=$(gum input --header "Ghostty window width (columns)" --placeholder "150" || true)
    CUSTOM_HEIGHT=$(gum input --header "Ghostty window height (rows)" --placeholder "55" || true)
    export GHOSTTY_WINDOW_WIDTH="${CUSTOM_WIDTH:-150}"
    export GHOSTTY_WINDOW_HEIGHT="${CUSTOM_HEIGHT:-55}"
    ;;
esac

GHOSTTY_SIZE_FILE="$HOME/.config/omakub/ghostty-window-size.env"
mkdir -p "$(dirname "$GHOSTTY_SIZE_FILE")"
printf "GHOSTTY_WINDOW_WIDTH=%s\nGHOSTTY_WINDOW_HEIGHT=%s\n" \
  "${GHOSTTY_WINDOW_WIDTH:-150}" "${GHOSTTY_WINDOW_HEIGHT:-55}" > "$GHOSTTY_SIZE_FILE"

# Terminal Tools Choice (Granular)
gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Terminal Tools"

show_choice_progress
TERMINAL_TOOLS=(
  "Fastfetch (System info)"
  "Btop (Resource monitor)"
  "Neovim (Editor)"
  "Ghostty (Terminal)"
  "Starship (Shell prompt)"
  "Zoxide (Directory jumper)"
  "Lazygit (Git UI)"
  "Lazydocker (Docker UI)"
  "Docker"
  "Mise (Version manager)"
  "Rust Toolchain"
  "GitHub CLI"
  "Tailscale (VPN)"
  "wl-clipboard (Clipboard utility)"
)

# Pre-select all by default except Tailscale
DEFAULT_TERMINAL_TOOLS="Fastfetch (System info),Btop (Resource monitor),Neovim (Editor),Ghostty (Terminal),Starship (Shell prompt),Zoxide (Directory jumper),Lazygit (Git UI),Lazydocker (Docker UI),Docker,Mise (Version manager),Rust Toolchain,GitHub CLI,wl-clipboard (Clipboard utility)"

SELECTED_TERMINAL_TOOLS=$(gum_choose_multi "Select terminal tools to install" "$DEFAULT_TERMINAL_TOOLS" "${TERMINAL_TOOLS[@]}")

export SETUP_FASTFETCH=false
export SETUP_BTOP=false
export SETUP_NEOVIM=false
export SETUP_GHOSTTY=false
export SETUP_STARSHIP=false
export SETUP_ZOXIDE=false
export SETUP_LAZYGIT=false
export SETUP_LAZYDOCKER=false
export SETUP_DOCKER=false
export SETUP_MISE=false
export SETUP_RUST=false
export SETUP_GH_CLI=false
export SETUP_TAILSCALE=false
export SETUP_WL_CLIPBOARD=false

if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Fastfetch"; then export SETUP_FASTFETCH=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Btop"; then export SETUP_BTOP=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Neovim"; then export SETUP_NEOVIM=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Ghostty"; then export SETUP_GHOSTTY=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Starship"; then export SETUP_STARSHIP=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Zoxide"; then export SETUP_ZOXIDE=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Lazygit"; then export SETUP_LAZYGIT=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Lazydocker"; then export SETUP_LAZYDOCKER=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Docker"; then export SETUP_DOCKER=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Mise"; then export SETUP_MISE=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Rust"; then export SETUP_RUST=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "GitHub CLI"; then export SETUP_GH_CLI=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "Tailscale"; then export SETUP_TAILSCALE=true; fi
if printf '%s\n' "$SELECTED_TERMINAL_TOOLS" | grep -Fq "wl-clipboard"; then export SETUP_WL_CLIPBOARD=true; fi

# Developer Stack (Languages & Databases)
gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Developer Stack"

show_choice_progress
# Languages
AVAILABLE_LANGUAGES=("Ruby" "Node.js" "Go" "PHP" "Python" "Elixir" "Java" "Rust")
SELECTED_LANGUAGES_RAW=$(gum choose "${AVAILABLE_LANGUAGES[@]}" --no-limit --height "$GUM_HEIGHT_TALL" --header "Select programming languages to install (via mise)" || true)
# Convert newlines to commas for export
export SELECTED_LANGUAGES=$(echo "$SELECTED_LANGUAGES_RAW" | tr '\n' ',')

# Databases
show_choice_progress
AVAILABLE_DBS=("MySQL" "PostgreSQL" "Redis" "MongoDB" "MariaDB")
SELECTED_DBS_RAW=$(gum choose "${AVAILABLE_DBS[@]}" --no-limit --height "$GUM_HEIGHT_DEFAULT" --header "Select databases to install (via Docker)" || true)
export SELECTED_DBS=$(echo "$SELECTED_DBS_RAW" | tr '\n' ',')

# Desktop apps (GNOME only)
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Desktop Environment"

  show_choice_progress
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
  THEME_SELECTED=$(gum choose "${THEME_NAMES[@]}" --height "$GUM_HEIGHT_DEFAULT" --header "Select theme" --selected "Catppuccin" || true)
  if [[ -z "$THEME_SELECTED" ]]; then
    THEME_SELECTED="Catppuccin"
  fi
  export OMAKUB_THEME=$(echo "$THEME_SELECTED" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
  if [[ -z "$OMAKUB_THEME" ]]; then
    export OMAKUB_THEME="catppuccin"
  fi

  show_choice_progress
  DESKTOP_APPS=(
    "VS Code"
    "Discord"
    "Slack"
    "Spotify"
    "LibreOffice"
    "1Password"
    "Dropbox"
    "Bambu Studio (3D Printing)"
    "OBS Studio (Screen Recording)"
    "VirtualBox (VMs)"
    "VLC (Media Player)"
    "GNOME Sushi (Previewer)"
  )

  DEFAULT_APPS="VS Code,GNOME Sushi (Previewer)"
  SELECTED_APPS=$(gum_choose_multi "Select desktop apps to install" "$DEFAULT_APPS" "${DESKTOP_APPS[@]}")

  export SETUP_VSCODE=false
  export SETUP_DISCORD=false
  export SETUP_SLACK=false
  export SETUP_SPOTIFY=false
  export SETUP_LIBREOFFICE=false
  export SETUP_1PASSWORD=false
  export SETUP_DROPBOX=false
  export SETUP_BAMBUSTUDIO=false
  export SETUP_OBS=false
  export SETUP_VIRTUALBOX=false
  export SETUP_VLC=false
  export SETUP_SUSHI=false

  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "VS Code"; then export SETUP_VSCODE=true; fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "Discord"; then export SETUP_DISCORD=true; fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "Slack"; then export SETUP_SLACK=true; fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "Spotify"; then export SETUP_SPOTIFY=true; fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "LibreOffice"; then export SETUP_LIBREOFFICE=true; fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "1Password"; then export SETUP_1PASSWORD=true; fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "Dropbox"; then export SETUP_DROPBOX=true; fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "Bambu Studio (3D Printing)"; then export SETUP_BAMBUSTUDIO=true; fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "OBS Studio (Screen Recording)"; then export SETUP_OBS=true; fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "VirtualBox (VMs)"; then export SETUP_VIRTUALBOX=true; fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "VLC (Media Player)"; then export SETUP_VLC=true; fi
  if printf '%s\n' "$SELECTED_APPS" | grep -Fxq "GNOME Sushi (Previewer)"; then export SETUP_SUSHI=true; fi

  if [[ "$SETUP_VSCODE" == true ]] && snap list code >/dev/null 2>&1; then
    gum style --foreground 214 "Existing VS Code snap detected. It will be replaced with .deb for consistency."
    export VSCODE_REMOVE_SNAP=true
  fi

  if [[ "$SETUP_DISCORD" == true ]] && snap list discord >/dev/null 2>&1; then
    gum style --foreground 214 "Existing Discord snap detected. It will be replaced with .deb for consistency."
    export DISCORD_REMOVE_SNAP=true
  fi

  # Web Apps
  show_choice_progress
  AVAILABLE_WEB_APPS=("Chat GPT" "Google Photos" "Google Contacts" "Tailscale")
  SELECTED_WEB_APPS_RAW=$(gum choose "${AVAILABLE_WEB_APPS[@]}" --no-limit --height "$GUM_HEIGHT_DEFAULT" --header "Select Web Apps (PWAs) to install" || true)
  export SELECTED_WEB_APPS=$(echo "$SELECTED_WEB_APPS_RAW" | tr '\n' ',')
fi

# AI Tools choice
show_choice_progress
AI_TOOLS=(
  "Claude Code (Anthropic CLI)"
  "OpenCode"
)

SELECTED_AI=$(gum choose "${AI_TOOLS[@]}" --no-limit --height "$GUM_HEIGHT_SHORT" --header "Select AI coding tools to install (optional)" || true)

export SETUP_CLAUDE_CODE=false
export SETUP_OPENCODE=false

if printf '%s\n' "$SELECTED_AI" | grep -Fxq "Claude Code (Anthropic CLI)"; then
  export SETUP_CLAUDE_CODE=true
fi
if printf '%s\n' "$SELECTED_AI" | grep -Fxq "OpenCode"; then
  export SETUP_OPENCODE=true
fi

# Gaming choice
show_choice_progress
GAMING_CHOICE=$(gum_choose "Gaming setup" "Skip Gaming" "Install Steam" "Skip Gaming")
if [[ "$GAMING_CHOICE" == "Install Steam" ]]; then
  export SETUP_STEAM=true
else
  export SETUP_STEAM=false
fi

# VPN choice (NordVPN)
show_choice_progress
VPN_SELECTED=$(gum_choose "NordVPN Setup (Tailscale is in terminal tools)" "Skip NordVPN" "Install NordVPN" "Skip NordVPN")

if [[ "$VPN_SELECTED" == "Install NordVPN" ]]; then
  export SETUP_NORDVPN=true
else
  export SETUP_NORDVPN=false
fi

# Laptop power management (TLP)
CHASSIS_TYPE=$(cat /sys/class/dmi/id/chassis_type 2>/dev/null || echo "0")
if [[ "$CHASSIS_TYPE" =~ ^(8|9|10|14)$ ]]; then
  export IS_LAPTOP=true
  show_choice_progress
  gum format -- "**TLP** is a feature-rich command line utility for Linux that saves laptop battery power."

  if command -v tlp >/dev/null 2>&1; then
    TLP_CHOICE=$(gum_choose "TLP configuration" "Skip TLP" "Optimize TLP for laptop" "Keep current TLP config" "Skip TLP")
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
    TLP_INSTALL=$(gum_choose "Install and optimize TLP for battery life?" "No" "Yes" "No")
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
show_choice_progress
gum format -- "**Auto Backup**: If enabled, existing config files will be backed up to ~/.config-backup-<date> before being overwritten."
CONFIG_STRATEGY=$(gum_choose "Config file strategy" "Keep existing configs" "Auto backup and overwrite" "Keep existing configs")
if [[ "$CONFIG_STRATEGY" == "Auto backup and overwrite" ]]; then
  export AUTO_BACKUP=true
else
  export AUTO_BACKUP=false
fi


# Pre-flight Check (Summary)
SUMMARY_FILE=$(mktemp)

truncate_value() {
  local value="$1"
  local max_len="$2"
  if [[ ${#value} -gt $max_len ]]; then
    printf "%s..." "${value:0:$((max_len-3))}"
  else
    printf "%s" "$value"
  fi
}

add_summary_row() {
  local category="$1"
  local option="$2"
  local trimmed
  trimmed=$(truncate_value "$option" 60)
  printf "%s\t%s\n" "$category" "$trimmed" >> "$SUMMARY_FILE"
}

join_flags() {
  local -n items=$1
  local result=""
  for item in "${items[@]}"; do
    if [[ -n "$result" ]]; then
      result+="; "
    fi
    result+="$item"
  done
  if [[ -z "$result" ]]; then
    result="None"
  fi
  printf "%s" "$result"
}

parse_csv() {
  local csv="$1"
  local items=()
  IFS=',' read -ra raw <<< "$csv"
  for item in "${raw[@]}"; do
    if [[ -n "${item// /}" ]]; then
      items+=("${item//\n/}")
    fi
  done
  join_flags items
}

add_summary_row "Browser" "$BROWSER_SELECTED"
add_summary_row "Theme" "${THEME_SELECTED:-None}"
add_summary_row "Ghostty Size" "$GHOSTTY_SIZE"
add_summary_row "Backup Strategy" "$CONFIG_STRATEGY"

terminal_items=()
[[ "$SETUP_FASTFETCH" == true ]] && terminal_items+=("Fastfetch")
[[ "$SETUP_BTOP" == true ]] && terminal_items+=("Btop")
[[ "$SETUP_NEOVIM" == true ]] && terminal_items+=("Neovim")
[[ "$SETUP_GHOSTTY" == true ]] && terminal_items+=("Ghostty")
[[ "$SETUP_STARSHIP" == true ]] && terminal_items+=("Starship")
[[ "$SETUP_ZOXIDE" == true ]] && terminal_items+=("Zoxide")
[[ "$SETUP_LAZYGIT" == true ]] && terminal_items+=("Lazygit")
[[ "$SETUP_LAZYDOCKER" == true ]] && terminal_items+=("Lazydocker")
[[ "$SETUP_DOCKER" == true ]] && terminal_items+=("Docker")
[[ "$SETUP_MISE" == true ]] && terminal_items+=("Mise")
[[ "$SETUP_RUST" == true ]] && terminal_items+=("Rust")
[[ "$SETUP_GH_CLI" == true ]] && terminal_items+=("GitHub CLI")
[[ "$SETUP_TAILSCALE" == true ]] && terminal_items+=("Tailscale")
[[ "$SETUP_WL_CLIPBOARD" == true ]] && terminal_items+=("wl-clipboard")
add_summary_row "Terminal Tools" "$(join_flags terminal_items)"

if [[ -n "$SELECTED_LANGUAGES" ]]; then
  add_summary_row "Languages" "$(parse_csv "$SELECTED_LANGUAGES")"
else
  add_summary_row "Languages" "None"
fi

if [[ -n "$SELECTED_DBS" ]]; then
  add_summary_row "Databases" "$(parse_csv "$SELECTED_DBS")"
else
  add_summary_row "Databases" "None"
fi

desktop_items=()
[[ "$SETUP_VSCODE" == true ]] && desktop_items+=("VS Code")
[[ "$SETUP_DISCORD" == true ]] && desktop_items+=("Discord")
[[ "$SETUP_SLACK" == true ]] && desktop_items+=("Slack")
[[ "$SETUP_SPOTIFY" == true ]] && desktop_items+=("Spotify")
[[ "$SETUP_LIBREOFFICE" == true ]] && desktop_items+=("LibreOffice")
[[ "$SETUP_1PASSWORD" == true ]] && desktop_items+=("1Password")
[[ "$SETUP_DROPBOX" == true ]] && desktop_items+=("Dropbox")
[[ "$SETUP_BAMBUSTUDIO" == true ]] && desktop_items+=("Bambu Studio")
[[ "$SETUP_OBS" == true ]] && desktop_items+=("OBS Studio")
[[ "$SETUP_VIRTUALBOX" == true ]] && desktop_items+=("VirtualBox")
[[ "$SETUP_VLC" == true ]] && desktop_items+=("VLC")
[[ "$SETUP_SUSHI" == true ]] && desktop_items+=("GNOME Sushi")
add_summary_row "Desktop Apps" "$(join_flags desktop_items)"

if [[ -n "$SELECTED_WEB_APPS" ]]; then
  add_summary_row "Web Apps" "$(parse_csv "$SELECTED_WEB_APPS")"
else
  add_summary_row "Web Apps" "None"
fi

add_summary_row "VPN" "$([[ "$SETUP_NORDVPN" == true ]] && echo "NordVPN" || echo "None")"
add_summary_row "Laptop" "$([[ "$SETUP_TLP" == true ]] && echo "TLP Optimized" || echo "None")"

show_choice_progress
gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Pre-flight Check: Installation Summary"
gum table --print --columns "Category" --columns "Selected Option" --widths 20,60 --height 20 < "$SUMMARY_FILE"
rm "$SUMMARY_FILE"

if ! gum confirm "Ready to proceed with installation?"; then
  echo "Installation cancelled."
  exit 0
fi
