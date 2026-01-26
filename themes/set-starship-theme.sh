#!/bin/bash

set -euo pipefail

OMAKUB_THEME="${1:-${OMAKUB_THEME:-}}"
if [[ -z "$OMAKUB_THEME" ]]; then
  echo "Error: Theme name is required"
  return 1
fi

OMAKUB_PATH="${OMAKUB_SZAMSKI_PATH:-${OMAKUB_PATH:-$HOME/.local/share/omakub-szamski}}"
THEME_DIR="$OMAKUB_PATH/themes/$OMAKUB_THEME"
THEME_COLORS="$THEME_DIR/ghostty.toml"

if [[ ! -f "$THEME_COLORS" ]]; then
  echo "Warning: Ghostty theme file not found for $OMAKUB_THEME"
  return 0
fi

mkdir -p "$HOME/.config"
if [[ ! -f "$HOME/.config/starship.toml" ]]; then
  cp "$OMAKUB_PATH/configs/starship.toml" "$HOME/.config/starship.toml"
fi

OMAKUB_THEME="$OMAKUB_THEME" THEME_COLORS="$THEME_COLORS" python3 << 'PY'
import os
import re

theme = os.environ["OMAKUB_THEME"]
colors_path = os.environ["THEME_COLORS"]
config_path = os.path.expanduser("~/.config/starship.toml")

background = None
foreground = None
palette = []
in_palette = False

with open(colors_path, "r", encoding="utf-8") as f:
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

if not background or len(palette) != 16:
    raise SystemExit("Invalid ghostty palette data")

# Map starship palette names to ghostty colors
def pick(idx, fallback):
    return palette[idx] if idx < len(palette) else fallback

palette_map = {
    "red": pick(1, "#ff0000"),
    "peach": pick(3, "#ffaa00"),
    "yellow": pick(11, pick(3, "#ffff00")),
    "green": pick(2, "#00ff00"),
    "sapphire": pick(4, "#00aaff"),
    "lavender": pick(5, "#aa00ff"),
    "crust": background,
    "text": foreground or "#ffffff",
}

block_header = f"[palettes.{theme}]"
block_lines = [block_header] + [f"{k} = \"{v}\"" for k, v in palette_map.items()]

with open(config_path, "r", encoding="utf-8") as f:
    content = f.read().splitlines()

out = []
in_block = False
for line in content:
    if line.strip().startswith("[palettes."):
        if line.strip() == block_header:
            in_block = True
            continue
        else:
            if in_block:
                in_block = False
    if in_block:
        continue
    out.append(line)

out.append("")
out.extend(block_lines)
out.append("")

# Update palette selector
out = [re.sub(r"^palette\s*=.*", f"palette = '{theme}'", l) for l in out]

with open(config_path, "w", encoding="utf-8") as f:
    f.write("\n".join(out) + "\n")

print(f"✓ Starship theme applied: {theme}")
PY
