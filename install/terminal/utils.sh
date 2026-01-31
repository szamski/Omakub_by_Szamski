#!/bin/bash

# Web to App generator
function web2app() {
  local name="$1"
  local url="$2"
  local icon="$3"
  local chrome_path="/usr/bin/google-chrome"
  
  if [ ! -f "$chrome_path" ]; then
    echo "Google Chrome is required for Web Apps but not found."
    return 1
  fi

  # Create desktop entry
  mkdir -p ~/.local/share/applications
  cat <<EOF > ~/.local/share/applications/"$name".desktop
[Desktop Entry]
Version=1.0
Name=$name
Exec=$chrome_path --app="$url" %U
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=$name
StartupWMClass=$name
StartupNotify=true
EOF

  # Download icon if provided
  if [[ -n "$icon" ]]; then
    mkdir -p ~/.local/share/icons
    wget -qO ~/.local/share/icons/"$name".png "$icon"
    sed -i "s|Icon=$name|Icon=$HOME/.local/share/icons/$name.png|g" ~/.local/share/applications/"$name".desktop
  fi
}

function app2folder() {
  local desktop_file="$1"
  local folder="$2"
  true
}

# Smart Config Installer
# Checks if config exists and differs, then asks user what to do.
function install_config() {
  local source_file="$1"
  local dest_file="$2"
  local name="$3"
  local backup_dir="${BACKUP_DIR:-$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)}"

  if [ ! -f "$source_file" ]; then
    echo "Warning: source config for $name not found at $source_file"
    return 1
  fi

  # Create parent directory if needed
  mkdir -p "$(dirname "$dest_file")"

  if [ -f "$dest_file" ]; then
    # Check if files differ
    if ! cmp -s "$source_file" "$dest_file"; then
      echo "Configuration conflict for $name"
      
      # Use gum if available, else standard prompt (but we assume gum is installed by now)
      if command -v gum >/dev/null 2>&1; then
        gum style --border normal --margin "1" --padding "1 2" --border-foreground 214 "Config conflict: $dest_file"
        CHOICE=$(gum choose "Backup & Overwrite (Recommended)" "Overwrite (No Backup)" "Keep Existing" --header "Choose what to do" || true)
        if [[ -z "$CHOICE" ]]; then
          CHOICE="Keep Existing"
        fi
      else
        CHOICE="Backup & Overwrite (Recommended)"
      fi

      case "$CHOICE" in
        "Backup & Overwrite (Recommended)")
          mkdir -p "$backup_dir"
          cp "$dest_file" "$backup_dir/$(basename "$dest_file")_$name.bak"
          cp "$source_file" "$dest_file"
          echo "Updated $name (backup saved)"
          ;;
        "Overwrite (No Backup)")
          cp "$source_file" "$dest_file"
          echo "Updated $name"
          ;;
        "Keep Existing")
          echo "Skipped $name config update"
          ;;
      esac
    else
      echo "$name config is up to date"
    fi
  else
    cp "$source_file" "$dest_file"
    echo "Installed $name config"
  fi
}

# Source Consistency Enforcer
# Ensures app is NOT installed via Snap/Flatpak if we want the Deb version
function ensure_no_snap() {
  local app_name="$1"
  
  if command -v snap >/dev/null 2>&1; then
    if snap list "$app_name" >/dev/null 2>&1; then
      echo "Removing Snap version of $app_name to ensure consistency..."
      sudo snap remove "$app_name"
    fi
  fi
}

function ensure_no_flatpak() {
  local app_id="$1"
  
  if command -v flatpak >/dev/null 2>&1; then
    if flatpak list | grep -q "$app_id"; then
      echo "Removing Flatpak version of $app_id to ensure consistency..."
      flatpak uninstall -y "$app_id"
    fi
  fi
}
