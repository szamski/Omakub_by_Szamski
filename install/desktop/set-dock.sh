#!/bin/bash

# Desired order of applications in Dash (stable across apt/snap/flatpak/source)
# Apps not installed are automatically skipped
app_order=(
  "ghostty"
  "files"
  "chromium"
  "calendar"
  "vscode"
  "spotify"
  "whatsapp"
  "discord"
  "slack"
  "steam"
)

# Search directories for .desktop files
desktop_dirs=(
  "/var/lib/snapd/desktop/applications"
  "/var/lib/flatpak/exports/share/applications"
  "$HOME/.local/share/flatpak/exports/share/applications"
  "/usr/share/applications"
  "/usr/local/share/applications"
  "$HOME/.local/share/applications"
)

declare -A desktop_path
declare -A desktop_name
declare -A desktop_exec
declare -A desktop_wmclass
desktop_ids=()

for dir in "${desktop_dirs[@]}"; do
  [[ -d "$dir" ]] || continue
  for file in "$dir"/*.desktop; do
    [[ -f "$file" ]] || continue
    id="$(basename "$file")"
    desktop_ids+=("$id")
    desktop_path["$id"]="$file"
    desktop_name["$id"]="$(awk -F= '/^Name=/{print $2; exit}' "$file")"
    desktop_exec["$id"]="$(awk -F= '/^Exec=/{print $2; exit}' "$file")"
    desktop_wmclass["$id"]="$(awk -F= '/^StartupWMClass=/{print $2; exit}' "$file")"
  done
done

if [[ ${#desktop_ids[@]} -eq 0 ]]; then
  echo "No .desktop entries found. Skipping GNOME Dash favorites."
  exit 0
fi

declare -A app_id_variants
declare -A app_exec_regex
declare -A app_wmclass_regex
declare -A app_name_regex

app_id_variants["ghostty"]="ghostty_ghostty.desktop,ghostty.desktop,com.mitchellh.ghostty.desktop"
app_id_variants["files"]="org.gnome.Nautilus.desktop"
app_id_variants["chromium"]="chromium_chromium.desktop,org.chromium.Chromium.desktop,chromium-browser.desktop,chromium.desktop,google-chrome.desktop,google-chrome-stable.desktop"
app_id_variants["calendar"]="org.gnome.Calendar.desktop,gnome-calendar.desktop"
app_id_variants["vscode"]="code.desktop,code_code.desktop,com.visualstudio.code.desktop,com.visualstudio.code.oss.desktop"
app_id_variants["spotify"]="spotify_spotify.desktop,spotify.desktop,com.spotify.Client.desktop"
app_id_variants["whatsapp"]="whatsapp-linux-desktop_whatsapp-linux-desktop.desktop,webapp-WhatsApp.desktop,whatsapp.desktop,com.github.nickvergessen.whatsapp.desktop"
app_id_variants["discord"]="discord.desktop,com.discordapp.Discord.desktop"
app_id_variants["slack"]="slack_slack.desktop,slack.desktop,com.slack.Slack.desktop"
app_id_variants["steam"]="steam-wayland.desktop,steam.desktop,com.valvesoftware.Steam.desktop"

app_exec_regex["ghostty"]="ghostty"
app_exec_regex["files"]="nautilus"
app_exec_regex["chromium"]="chromium|google-chrome"
app_exec_regex["calendar"]="gnome-calendar"
app_exec_regex["vscode"]="code|code-oss"
app_exec_regex["spotify"]="spotify"
app_exec_regex["whatsapp"]="whatsapp"
app_exec_regex["discord"]="discord"
app_exec_regex["slack"]="slack"
app_exec_regex["steam"]="steam"

app_wmclass_regex["ghostty"]="ghostty"
app_wmclass_regex["files"]="nautilus"
app_wmclass_regex["chromium"]="chromium|google-chrome"
app_wmclass_regex["calendar"]="gnome-calendar"
app_wmclass_regex["vscode"]="code|code-oss"
app_wmclass_regex["spotify"]="spotify"
app_wmclass_regex["whatsapp"]="whatsapp"
app_wmclass_regex["discord"]="discord"
app_wmclass_regex["slack"]="slack"
app_wmclass_regex["steam"]="steam"

app_name_regex["ghostty"]="ghostty"
app_name_regex["files"]="files|nautilus"
app_name_regex["chromium"]="chromium|chrome"
app_name_regex["calendar"]="calendar"
app_name_regex["vscode"]="code|visual studio code"
app_name_regex["spotify"]="spotify"
app_name_regex["whatsapp"]="whatsapp"
app_name_regex["discord"]="discord"
app_name_regex["slack"]="slack"
app_name_regex["steam"]="steam"

match_by_regex() {
  local value="$1"
  local regex="$2"
  [[ -n "$value" && -n "$regex" ]] || return 1
  local value_lc="${value,,}"
  [[ "$value_lc" =~ $regex ]]
}

find_desktop_for_app() {
  local app="$1"
  local id_variants="${app_id_variants[$app]}"
  local exec_re="${app_exec_regex[$app]}"
  local wmclass_re="${app_wmclass_regex[$app]}"
  local name_re="${app_name_regex[$app]}"

  IFS=',' read -ra id_list <<< "$id_variants"
  for id in "${id_list[@]}"; do
    if [[ -n "${desktop_path[$id]:-}" ]]; then
      echo "$id"
      return 0
    fi
  done

  if [[ -n "$exec_re" ]]; then
    for id in "${desktop_ids[@]}"; do
      if match_by_regex "${desktop_exec[$id]}" "$exec_re"; then
        echo "$id"
        return 0
      fi
    done
  fi

  if [[ -n "$wmclass_re" ]]; then
    for id in "${desktop_ids[@]}"; do
      if match_by_regex "${desktop_wmclass[$id]}" "$wmclass_re"; then
        echo "$id"
        return 0
      fi
    done
  fi

  if [[ -n "$name_re" ]]; then
    for id in "${desktop_ids[@]}"; do
      if match_by_regex "${desktop_name[$id]}" "$name_re"; then
        echo "$id"
        return 0
      fi
    done
  fi

  return 1
}

ordered_apps=()
declare -A chosen

for app in "${app_order[@]}"; do
  id="$(find_desktop_for_app "$app" 2>/dev/null || true)"
  if [[ -n "$id" && -z "${chosen[$id]:-}" ]]; then
    ordered_apps+=("$id")
    chosen["$id"]=1
  fi
done

if [[ ${#ordered_apps[@]} -eq 0 ]]; then
  echo "No matching apps found for GNOME Dash favorites."
  exit 0
fi

favorites_list=$(printf "'%s'," "${ordered_apps[@]}")
favorites_list="[${favorites_list%,}]"

gsettings set org.gnome.shell favorite-apps "$favorites_list"

echo "OK: GNOME Dash favorites set:"
for app in "${ordered_apps[@]}"; do
  echo "  - $app"
done
