#!/bin/bash

set -e

# Determine installation path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SIMPLE_PATH="$SCRIPT_DIR"
export OMAKUB_SZAMSKI_PATH="$(dirname "$SCRIPT_DIR")"

# Check not running as root
if [[ "$EUID" -eq 0 ]]; then
  echo "Error: Do not run with sudo."
  echo "Run: ./install.sh [--dry-run]"
  exit 1
fi

# Parse arguments
DRY_RUN=false
for arg in "$@"; do
  if [[ "$arg" == "--dry-run" ]]; then
    DRY_RUN=true
  fi
done
export DRY_RUN

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log() {
  echo -e "${BLUE}==>${NC} $1"
}

success() {
  echo -e "${GREEN}✓${NC} $1"
}

warn() {
  echo -e "${YELLOW}⚠${NC} $1"
}

dry_run_info() {
  echo -e "${CYAN}[DRY-RUN]${NC} $1"
}

# Run command or show dry-run message
run_step() {
  local title="$1"
  local cmd="$2"

  if [[ "$DRY_RUN" == "true" ]]; then
    dry_run_info "$title"
    return 0
  fi

  if command -v gum >/dev/null 2>&1; then
    gum spin --spinner dot --title "$title" -- bash -c "$cmd"
  else
    log "$title"
    bash -c "$cmd"
  fi
  success "$title"
}

# Ensure sudo access (unless dry-run)
if [[ "$DRY_RUN" != "true" ]]; then
  log "Requesting sudo access..."
  sudo -v
fi

# Install gum first (required for UI)
log "Installing gum (interactive UI)..."
if [[ "$DRY_RUN" == "true" ]]; then
  dry_run_info "Would install gum"
elif ! command -v gum >/dev/null 2>&1; then
  source "$SIMPLE_PATH/apps/terminal/gum.sh"
  success "gum installed"
else
  success "gum already installed"
fi

# Welcome message
if command -v gum >/dev/null 2>&1; then
  clear
  gum style \
    --border normal \
    --margin "1" \
    --padding "1 2" \
    --border-foreground 212 \
    "Welcome to Omakub_by_Szamski Simple Edition" \
    "" \
    "This installer will set up your Ubuntu development environment" \
    "with carefully selected tools and applications." \
    "" \
    "$([ "$DRY_RUN" == "true" ] && echo "[DRY-RUN MODE - No changes will be made]" || echo "")"

  echo ""
  gum confirm "Ready to begin?" || exit 0
fi

# Interactive app selection
if command -v gum >/dev/null 2>&1; then
  echo ""
  gum style --foreground 212 "Select Desktop Applications to Install:"
  echo ""

  SELECTED_APPS=$(gum choose --no-limit --height 15 \
    "Google Chrome" \
    "VS Code" \
    "1Password" \
    "Slack" \
    "Spotify" \
    "Discord" \
    "OBS Studio" \
    "VirtualBox" \
    "Steam" \
    "Dropbox" \
    "NordVPN" \
    "Tailscale" \
    "LocalSend" \
    "Claude Desktop" \
    "OnlyOffice" || echo "")

  # Dev language selection
  echo ""
  gum style --foreground 212 "Select Programming Languages:"
  echo ""

  SELECTED_LANGUAGES=$(gum choose --no-limit --height 10 \
    "Python" \
    "Node.js" \
    "Ruby" \
    "Go" \
    "PHP" \
    "Elixir" \
    "Rust" \
    "Java" || echo "")

  # Confirm selections
  echo ""
  gum style --border normal --padding "1 2" --border-foreground 99 \
    "Selected Applications:" \
    "$SELECTED_APPS" \
    "" \
    "Programming Languages:" \
    "$SELECTED_LANGUAGES"

  echo ""
  gum confirm "Proceed with installation?" || exit 0
else
  # Fallback if gum not available
  SELECTED_APPS=""
  SELECTED_LANGUAGES="Python
Node.js"
fi

# Start installation
if command -v gum >/dev/null 2>&1; then
  clear
  gum style --border double --padding "1 2" --border-foreground 212 \
    "$([ "$DRY_RUN" == "true" ] && echo "DRY-RUN Mode - Showing planned actions" || echo "Starting Installation...")"
  echo ""
fi

# Remove Firefox (Ubuntu 25.10 ships with snap version)
if snap list firefox 2>/dev/null | grep -q firefox; then
  run_step "Removing Firefox snap" "sudo snap remove --purge firefox"
fi

# Update system
run_step "Updating system packages" "sudo apt update && sudo apt upgrade -y"

# Install libraries and build essentials
run_step "Installing build essentials" "source '$SIMPLE_PATH/system/libraries.sh'"

# Install terminal tools
run_step "Installing terminal tools" "source '$SIMPLE_PATH/apps/terminal/terminal-tools.sh'"

# Install mise
run_step "Installing mise" "source '$SIMPLE_PATH/apps/terminal/mise.sh'"

# Install programming languages via mise
if [[ -n "$SELECTED_LANGUAGES" ]]; then
  export SELECTED_LANGUAGES
  run_step "Installing programming languages" "source '$SIMPLE_PATH/system/languages.sh'"
fi

# Install GitHub CLI
run_step "Installing GitHub CLI" "source '$SIMPLE_PATH/apps/terminal/github-cli.sh'"

# Install Nerd Fonts
run_step "Installing Nerd Fonts" "source '$SIMPLE_PATH/apps/terminal/nerd-fonts.sh'"

# Install Starship prompt
run_step "Installing Starship" "source '$SIMPLE_PATH/apps/terminal/starship.sh'"

# Install fastfetch
run_step "Installing fastfetch" "source '$SIMPLE_PATH/apps/terminal/fastfetch.sh'"

# Install wl-clipboard
run_step "Installing wl-clipboard" "source '$SIMPLE_PATH/apps/terminal/wl-clipboard.sh'"

# Configure bash
run_step "Configuring bash" "
  cp '$SIMPLE_PATH/configs/bash/bashrc' '$HOME/.bashrc'
  cp '$SIMPLE_PATH/configs/bash/inputrc' '$HOME/.inputrc'
  mkdir -p '$HOME/.local/share/omakub-simple/configs/bash'
  cp -r '$SIMPLE_PATH/configs/bash/defaults' '$HOME/.local/share/omakub-simple/configs/bash/'
"

# Configure starship
run_step "Configuring starship" "
  mkdir -p '$HOME/.config'
  cp '$SIMPLE_PATH/configs/starship.toml' '$HOME/.config/starship.toml'
"

# Configure fastfetch
run_step "Configuring fastfetch" "
  mkdir -p '$HOME/.config/fastfetch'
  cp '$SIMPLE_PATH/configs/fastfetch.jsonc' '$HOME/.config/fastfetch/config.jsonc'
"

# Install selected desktop apps
if [[ -n "$SELECTED_APPS" ]]; then
  echo "$SELECTED_APPS" | while IFS= read -r app; do
    case "$app" in
      "Google Chrome")
        run_step "Installing Google Chrome" "source '$SIMPLE_PATH/apps/desktop/chrome.sh'"
        ;;
      "VS Code")
        run_step "Installing VS Code" "source '$SIMPLE_PATH/apps/desktop/vscode.sh'"
        ;;
      "1Password")
        run_step "Installing 1Password" "source '$SIMPLE_PATH/apps/desktop/1password.sh'"
        ;;
      "Slack")
        run_step "Installing Slack" "source '$SIMPLE_PATH/apps/desktop/slack.sh'"
        ;;
      "Spotify")
        run_step "Installing Spotify" "source '$SIMPLE_PATH/apps/desktop/spotify.sh'"
        ;;
      "Discord")
        run_step "Installing Discord" "source '$SIMPLE_PATH/apps/desktop/discord.sh'"
        ;;
      "OBS Studio")
        run_step "Installing OBS Studio" "source '$SIMPLE_PATH/apps/desktop/obs-studio.sh'"
        ;;
      "VirtualBox")
        run_step "Installing VirtualBox" "source '$SIMPLE_PATH/apps/desktop/virtualbox.sh'"
        ;;
      "Steam")
        run_step "Installing Steam" "source '$SIMPLE_PATH/apps/desktop/steam.sh'"
        ;;
      "Dropbox")
        run_step "Installing Dropbox" "source '$SIMPLE_PATH/apps/desktop/dropbox.sh'"
        ;;
      "NordVPN")
        run_step "Installing NordVPN" "sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh) -p nordvpn-gui"
        ;;
      "Tailscale")
        run_step "Installing Tailscale" "curl -fsSL https://tailscale.com/install.sh | sh"
        ;;
      "LocalSend")
        run_step "Installing LocalSend" "
          cd /tmp
          wget -q https://github.com/localsend/localsend/releases/download/v1.17.0/LocalSend-1.17.0-linux-x86-64.deb
          sudo dpkg -i LocalSend-1.17.0-linux-x86-64.deb || sudo apt-get install -f -y
          rm LocalSend-1.17.0-linux-x86-64.deb
          cd - >/dev/null
        "
        ;;
      "Claude Desktop")
        run_step "Installing Claude Desktop" "curl -fsSL https://claude.ai/install.sh | bash"
        ;;
      "OnlyOffice")
        run_step "Installing OnlyOffice" "
          cd /tmp
          wget -q https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb
          sudo dpkg -i onlyoffice-desktopeditors_amd64.deb || sudo apt-get install -f -y
          rm onlyoffice-desktopeditors_amd64.deb
          cd - >/dev/null
        "
        ;;
    esac
  done
fi

# Configure GNOME (if running GNOME)
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
  run_step "Configuring GNOME" "
    # Set dark theme
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'

    # Configure Ptyxis terminal
    dconf write /org/gnome/Ptyxis/font-name \"'CaskaydiaCove Nerd Font Mono 10'\"
    dconf write /org/gnome/Ptyxis/use-system-font false

    # Set dock favorites (Chrome, Ptyxis, Files, Slack, Spotify, VS Code)
    gsettings set org.gnome.shell favorite-apps \"['google-chrome.desktop', 'org.gnome.Ptyxis.desktop', 'org.gnome.Nautilus.desktop', 'slack.desktop', 'spotify.desktop', 'code.desktop']\"

    # Set default terminal to Ptyxis
    gsettings set org.gnome.desktop.default-applications.terminal exec 'ptyxis'
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
  "
fi

# Cleanup
run_step "Cleaning up" "sudo apt autoremove -y && sudo apt autoclean"

# Done!
echo ""
echo ""
if command -v gum >/dev/null 2>&1; then
  if [[ "$DRY_RUN" == "true" ]]; then
    gum style \
      --border double \
      --padding "1 4" \
      --border-foreground 99 \
      "Dry-Run Complete!" \
      "" \
      "No changes were made to your system." \
      "Run without --dry-run to perform actual installation."
  else
    gum style \
      --border double \
      --padding "1 4" \
      --border-foreground 212 \
      "Installation Complete! 🚀" \
      "" \
      "Next steps:" \
      "  1. Restart your terminal: source ~/.bashrc" \
      "  2. Log out and back in (for GNOME changes)" \
      "" \
      "Enjoy your new development environment!"
  fi
else
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Dry-Run Complete! No changes were made."
  else
    echo "Installation Complete!"
  fi
fi
