#!/bin/bash

set -euo pipefail

OMAKUB_THEME="${1:-${OMAKUB_THEME:-}}"
if [[ -z "$OMAKUB_THEME" ]]; then
  echo "Error: Theme name is required"
  return 1
fi

OMAKUB_PATH="${OMAKUB_PATH:-${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub}}"
THEME_FILE="$OMAKUB_PATH/themes/$OMAKUB_THEME/vscode.json"

read_json_value() {
  local key="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -r ".${key} // empty" "$THEME_FILE"
  else
    python - "$THEME_FILE" "$key" <<'PY'
import json
import sys

path = sys.argv[1]
key = sys.argv[2]
try:
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
    value = data.get(key, "")
    print(value if isinstance(value, str) else "")
except Exception:
    print("")
PY
  fi
}

set_theme() {
  local editor_cmd="$1"
  local settings_path="$2"
  local skip_flag="$3"

  command -v "$editor_cmd" >/dev/null 2>&1 || return 0
  [[ -f "$skip_flag" ]] && return 0

  if [[ -f "$THEME_FILE" ]]; then
    local theme_name
    local extension
    theme_name="$(read_json_value name)"
    extension="$(read_json_value extension)"

    if [[ -n "$extension" ]] && ! "$editor_cmd" --list-extensions | grep -Fxq "$extension"; then
      "$editor_cmd" --install-extension "$extension" >/dev/null 2>&1 || true
    fi

    mkdir -p "$(dirname "$settings_path")"
    [[ -f "$settings_path" ]] || printf '{\n}\n' >"$settings_path"

    if ! grep -q '"workbench.colorTheme"' "$settings_path"; then
      sed -i --follow-symlinks -E '0,/\{/{s/\{/{\ "workbench.colorTheme": "",/}' "$settings_path"
    fi

    sed -i --follow-symlinks -E \
      "s/(\"workbench.colorTheme\"[[:space:]]*:[[:space:]]*\")[^\"]*(\")/\1$theme_name\2/" \
      "$settings_path"
  elif [[ -f "$settings_path" ]]; then
    sed -i --follow-symlinks -E 's/\"workbench\.colorTheme\"[[:space:]]*:[^,}]*,?//' "$settings_path"
  fi
}

set_theme "codium" "$HOME/.config/VSCodium/User/settings.json" "$HOME/.local/state/omakub/toggles/skip-codium-theme-changes"
set_theme "cursor" "$HOME/.config/Cursor/User/settings.json" "$HOME/.local/state/omakub/toggles/skip-cursor-theme-changes"
