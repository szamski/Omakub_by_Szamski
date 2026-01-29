# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Omakub_by_Szamski is a personalized Ubuntu 22.04+ development environment setup framework. It orchestrates installation of terminal tools, GNOME desktop customization, and themed configurations across multiple applications (Ghostty, Neovim, btop, VS Code, Starship, GNOME).

## Key Commands

### Installation
```bash
# Standard installation (remote)
bash <(curl -fsSL https://raw.githubusercontent.com/szamski/Omakub_by_Szamski/rework/boot.sh)

# Dry-run (no changes)
./install.sh --dry-run
# or
OMAKUB_SZAMSKI_DRY_RUN=1 ./install.sh
```

### Post-install CLI
```bash
omakub-szamski help          # Show commands
omakub-szamski theme         # Interactive theme switcher
omakub-szamski update        # Pull latest from git
omakub-szamski reinstall     # Re-run full installation
omakub-szamski backup        # Create configs backup
omakub-szamski restore <dir> # Restore from backup
```

### Theme Switcher Rust App
```bash
cd apps/theme-switcher
cargo build --release
# Binary outputs to bin/omakub-theme-switcher
```

## Architecture

### Installation Flow
```
boot.sh → install.sh → first-run-choices.sh (gum menus)
                     → terminal.sh (all terminal tools)
                     → desktop.sh (GNOME + optional apps)
                     → apply-theme.sh (if theme selected)
```

### Script Patterns
- **Sourcing**: Scripts are `source`d, not executed as subprocesses, to share environment variables
- **Progress tracking**: `run_step "title" "command"` logs to file and shows gum spinner
- **File descriptors**: `OMAKUB_STDOUT_FD=3` for parallel output during progress display
- **Dry-run mode**: Check `$DRY_RUN` before making changes

### Key Environment Variables
- `OMAKUB_SZAMSKI_PATH` - Installation root (defaults to `~/.local/share/omakub-szamski`)
- `OMAKUB_THEME` - Selected theme name (catppuccin, tokyo-night, nord, etc.)
- `DRY_RUN` - Skip actual changes, only print planned actions
- `SETUP_*` flags - Feature toggles (VSCODE, DISCORD, SLACK, TAILSCALE, etc.)

### Theme System
Each theme in `themes/<name>/` contains:
- `gnome.sh` - GTK theme, wallpaper, Papirus color
- `ghostty.toml` - Terminal colors
- `neovim.lua` - Colorscheme config
- `btop.theme` - System monitor colors
- `vscode.json` - Editor theme

`themes/apply-theme.sh` orchestrates applying all theme components by calling individual `set-*-theme.sh` scripts.

### Directory Structure
- `install/` - Installation scripts (terminal/, desktop/, laptop/)
- `configs/` - Application configs copied to `~/.config/`
- `themes/` - 10 color schemes with per-app configs
- `bin/` - Post-install CLI tools
- `apps/theme-switcher/` - Rust GTK4 theme selector GUI
- `extensions/omakub-theme@szamski/` - GNOME Shell extension
- `defaults/bash/` - Shared shell initialization files

### Adding New Apps
1. Create `install/terminal/app-<name>.sh` or `install/desktop/app-<name>.sh`
2. For optional apps, place in `optional/` subdirectory
3. Add selection to `install/first-run-choices.sh` gum menu
4. Add `SETUP_<NAME>` check in `install.sh` for step counting
5. Add installation call in `terminal.sh` or `desktop.sh`

### Adding New Themes
1. Create `themes/<name>/` directory
2. Add: `gnome.sh`, `ghostty.toml`, `neovim.lua`, `btop.theme`, `vscode.json`
3. Theme is auto-discovered by the theme switcher (scans `themes/*/gnome.sh`)
