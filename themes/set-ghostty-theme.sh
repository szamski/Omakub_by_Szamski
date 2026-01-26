#!/bin/bash

set -euo pipefail

OMAKUB_THEME="${1:-${OMAKUB_THEME:-}}"
if [[ -z "$OMAKUB_THEME" ]]; then
  echo "Error: Theme name is required"
  return 1
fi

OMAKUB_PATH="${OMAKUB_SZAMSKI_PATH:-${OMAKUB_PATH:-$HOME/.local/share/omakub-szamski}}"
THEME_DIR="$OMAKUB_PATH/themes/$OMAKUB_THEME"
TEMPLATE_PATH="$OMAKUB_PATH/themes/ghostty.template"
THEME_COLORS="$THEME_DIR/ghostty.toml"

if [[ ! -f "$TEMPLATE_PATH" ]]; then
  echo "Error: Ghostty template not found: $TEMPLATE_PATH"
  return 1
fi

if [[ ! -f "$THEME_COLORS" ]]; then
  echo "Error: Ghostty theme file not found: $THEME_COLORS"
  return 1
fi

mkdir -p "$HOME/.config/ghostty"

TEMPLATE_PATH="$TEMPLATE_PATH" THEME_COLORS="$THEME_COLORS" OMAKUB_THEME="$OMAKUB_THEME" python3 << 'PY'
import os
import re

template_path = os.environ["TEMPLATE_PATH"]
theme_colors = os.environ["THEME_COLORS"]
output_path = os.path.expanduser("~/.config/ghostty/config")

with open(template_path, "r", encoding="utf-8") as f:
    template = f.read()

background = None
foreground = None
palette = []
in_palette = False

with open(theme_colors, "r", encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("background ="):
            background = line.split("=", 1)[1].strip().strip('"')
        elif line.startswith("foreground ="):
            foreground = line.split("=", 1)[1].strip().strip('"')
        elif line.startswith("palette ="):
            in_palette = True
        elif in_palette:
            if line.startswith("]"):
                in_palette = False
                continue
            color = line.strip().strip(",").strip().strip('"')
            if color:
                palette.append(color)

def normalize(value: str) -> str:
    if value.startswith("0x"):
        return "#" + value[2:]
    if value.startswith("#"):
        return value
    return "#" + value

if not background or not foreground:
    raise SystemExit("Missing background/foreground in ghostty.toml")
if len(palette) != 16:
    raise SystemExit("Palette must contain 16 colors")

palette_lines = "\n".join([f"palette = {i}={normalize(color)}" for i, color in enumerate(palette)])

template = template.replace("{{BACKGROUND}}", normalize(background))
template = template.replace("{{FOREGROUND}}", normalize(foreground))
template = template.replace("{{PALETTE}}", palette_lines)

with open(output_path, "w", encoding="utf-8") as out:
    out.write(template)

print(f"✓ Ghostty theme applied: {os.environ.get('OMAKUB_THEME')}")
PY

if command -v ghostty >/dev/null 2>&1; then
  if command -v xdotool >/dev/null 2>&1 && [[ -n "${DISPLAY:-}" ]]; then
    xdotool search --class ghostty key --window %@ ctrl+shift+comma >/dev/null 2>&1 || true
  else
    echo "ℹ️  Reload Ghostty with Ctrl+Shift+,"
  fi
fi
