#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

THEMES_DIR="$SCRIPT_DIR" python3 << 'PY'
import os
import re

themes_dir = os.path.abspath(os.environ["THEMES_DIR"])

section_re = re.compile(r"^\[(.+)\]\s*$")
kv_re = re.compile(r"^([A-Za-z0-9_]+)\s*=\s*\"([^\"]+)\"\s*$")

color_order = ["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"]

for theme_name in os.listdir(themes_dir):
    theme_path = os.path.join(themes_dir, theme_name)
    if not os.path.isdir(theme_path):
        continue

    alacritty_path = os.path.join(theme_path, "alacritty.toml")
    if not os.path.isfile(alacritty_path):
        continue

    colors = {"primary": {}, "normal": {}, "bright": {}}
    current = None

    with open(alacritty_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            section_match = section_re.match(line)
            if section_match:
                current = section_match.group(1)
                continue
            kv_match = kv_re.match(line)
            if not kv_match:
                continue
            key, value = kv_match.groups()
            if current == "colors.primary":
                colors["primary"][key] = value
            elif current == "colors.normal":
                colors["normal"][key] = value
            elif current == "colors.bright":
                colors["bright"][key] = value

    background = colors["primary"].get("background")
    foreground = colors["primary"].get("foreground")
    if not background or not foreground:
        raise SystemExit(f"Missing primary colors in {alacritty_path}")

    palette = [colors["normal"].get(c) for c in color_order] + [colors["bright"].get(c) for c in color_order]
    if any(p is None for p in palette):
        missing = [color_order[i % 8] for i, p in enumerate(palette) if p is None]
        raise SystemExit(f"Missing colors in {alacritty_path}: {missing}")

    ghostty_path = os.path.join(theme_path, "ghostty.toml")
    with open(ghostty_path, "w", encoding="utf-8") as out:
        out.write(f"background = \"{background}\"\n")
        out.write(f"foreground = \"{foreground}\"\n")
        out.write("palette = [\n")
        for idx, color in enumerate(palette):
            comma = "," if idx < len(palette) - 1 else ""
            out.write(f"  \"{color}\"{comma}\n")
        out.write("]\n")

    print(f"Generated {ghostty_path}")

PY
