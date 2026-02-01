# Omakub_by_Szamski - Simple Edition

A simplified, streamlined Ubuntu 25.04+ development environment installer.

## Features

- 🚀 **Fast & Simple** - No complex configuration, just the essentials
- 🎨 **Interactive Menu** - Choose what you want using beautiful `gum` UI
- 🐍 **Python & Node** - Pre-configured with latest versions via `mise`
- 🛠️ **Essential Tools** - Terminal tools, dev languages, and desktop apps
- 🎯 **GNOME Ready** - Auto-configured Ptyxis terminal, dock, and dark theme
- ⚡ **Dry-Run Mode** - Test installation without making changes

## Quick Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/szamski/Omakub_by_Szamski/rework/boot.sh)
```

## What Gets Installed

### Core Tools (Always Installed)

**Terminal Tools:**
- `neovim` - Modern text editor with LazyVim + Gruvbox theme
- `mise` - Runtime version manager (with Python & Node.js latest)
- `fzf`, `ripgrep`, `bat`, `eza`, `zoxide`, `fd-find`, `plocate` - Modern CLI tools
- `tldr` - Community-driven man pages
- `starship` - Beautiful shell prompt
- `fastfetch` - System information display
- `gh` - GitHub CLI
- `wl-clipboard` - Wayland clipboard utilities
- Nerd Fonts (CaskaydiaCove)

**System:**
- Build essentials and development libraries
- Dark theme (Yaru-dark)
- Configured bash with custom aliases and functions

### Optional Desktop Applications

Choose from interactive menu:
- Google Chrome
- VS Code
- 1Password
- Slack
- Spotify
- Discord
- OBS Studio
- VirtualBox
- Steam
- Dropbox
- NordVPN
- Tailscale
- LocalSend
- Claude Code CLI
- OnlyOffice

### Programming Languages

Select languages to install via `mise`:
- **Python** (always installed - latest version)
- **Node.js** (always installed - latest version)
- Ruby (with Rails)
- Go
- PHP (with Composer)
- Elixir (with Erlang)
- Rust
- Java

## GNOME Configuration

Automatically configured:
- **Terminal**: Ptyxis with CaskaydiaCove Nerd Font Mono 11, block cursor
- **Text Editor**: GNOME Text Editor with line numbers, current line highlight, and minimap
- **Theme**: Yaru Dark
- **Dock**: Chrome, Ptyxis, Files, Slack, Spotify (snap), VS Code
- **Firefox**: Removed (snap version from Ubuntu 25.10)
- **Neovim**: LazyVim with Gruvbox theme, Polish & English spell checking

## File Structure

```
Omakub_by_Szamski/
├── boot.sh              # Remote bootstrap script
├── install.sh           # Main installer (supports --dry-run)
├── README.md            # This file
│
├── apps/                # Application installers
│   ├── terminal/        # Terminal/CLI tools
│   │   ├── gum.sh
│   │   ├── neovim.sh
│   │   ├── mise.sh
│   │   ├── starship.sh
│   │   ├── fastfetch.sh
│   │   ├── github-cli.sh
│   │   ├── nerd-fonts.sh
│   │   ├── wl-clipboard.sh
│   │   └── terminal-tools.sh
│   └── desktop/         # Desktop applications
│       ├── chrome.sh
│       ├── vscode.sh
│       ├── 1password.sh
│       ├── slack.sh
│       ├── spotify.sh
│       ├── discord.sh
│       ├── obs-studio.sh
│       ├── virtualbox.sh
│       ├── steam.sh
│       └── dropbox.sh
│
├── configs/             # Configuration files
│   ├── bash/
│   │   ├── bashrc
│   │   ├── inputrc
│   │   └── defaults/    # Aliases, functions, prompt, etc.
│   ├── neovim/
│   │   ├── theme.lua              # Gruvbox theme
│   │   ├── transparency.lua
│   │   ├── lazyvim.json
│   │   └── snacks-animated-scrolling-off.lua
│   ├── starship.toml
│   └── fastfetch.jsonc
│
├── system/              # System configuration
│   ├── libraries.sh     # Build essentials & libraries
│   └── languages.sh     # Programming language installer
│
└── lib/                 # Shared utilities
    └── utils.sh         # Helper functions
```

## Usage

### Install from GitHub

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/szamski/Omakub_by_Szamski/rework/boot.sh)
```

### Install from Local Clone

```bash
git clone https://github.com/szamski/Omakub_by_Szamski.git
cd Omakub_by_Szamski
git checkout rework
./install.sh
```

### Dry-Run Mode

Preview what will be installed without making any changes:

```bash
./install.sh --dry-run
```

## Post-Installation

1. **Reload terminal:**
   ```bash
   source ~/.bashrc
   ```

2. **Log out and back in** (for GNOME extensions to load)

3. **Verify installation:**
   ```bash
   mise --version
   python --version
   node --version
   starship --version
   ```

## Customization

### Bash Configuration

Edit these files in `~/.local/share/omakub-simple/configs/bash/defaults/`:
- `aliases` - Custom command aliases
- `functions` - Bash functions
- `prompt` - Shell prompt customization
- `shell` - Shell options
- `rc` - Sourced on shell start
- `init` - Initialization script

### Starship Prompt

Edit `~/.config/starship.toml`

### Fastfetch

Edit `~/.config/fastfetch/config.jsonc`

## Why Simple Edition?

**This Edition:**
- ✅ Clean, organized structure
- ✅ Single branch, simple installation
- ✅ Dry-run mode supported
- ✅ Focus on Ubuntu 25.04+
- ✅ Auto Python & Node.js
- ✅ Ptyxis terminal integration
- ✅ No theme complexity
- ✅ Faster installation

**vs Full Omakub:**
- Multiple theme support
- GNOME extensions system
- Ghostty terminal
- More customization options
- Desktop-specific optimizations

## Requirements

- Ubuntu 25.04+ (or compatible)
- GNOME Desktop (recommended)
- Internet connection
- Sudo access

## Troubleshooting

### Mise not working

```bash
# Add to ~/.bashrc if missing:
eval "$(mise activate bash)"
```

### Fonts not showing

```bash
# Refresh font cache:
fc-cache -fv
```

### GNOME settings not applied

Log out and back in, or run:
```bash
gnome-shell --replace &
```

## Contributing

Contributions welcome! This is a simplified, standalone edition.

## License

MIT License - See main repository for details

## Credits

Based on [Omakub](https://github.com/basecamp/omakub) by Basecamp
Simplified and customized by [@szamski](https://github.com/szamski)
