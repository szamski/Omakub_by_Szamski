# Omakub_by_Szamski

My Ubuntu setup, inspired by Omakub but tailored to my workflow (Ghostty, Starship, GNOME, Papirus). It installs the tools I actually use and keeps the rest of the system out of the way.

## Requirements

- Ubuntu 22.04+
- GNOME (optional, only for desktop tweaks)

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/szamski/Omakub_by_Szamski/main/boot.sh)
```

### Dry run (no changes)

```bash
OMAKUB_SZAMSKI_DRY_RUN=1 bash <(curl -fsSL https://raw.githubusercontent.com/szamski/Omakub_by_Szamski/main/boot.sh)
```

Local dry run:

```bash
./install.sh --dry-run
```

Use a different repo or branch:

```bash
OMAKUB_SZAMSKI_REPO="https://github.com/YourUser/Omakub_by_Szamski.git" \
OMAKUB_SZAMSKI_REF="main" \
bash <(curl -fsSL https://raw.githubusercontent.com/szamski/Omakub_by_Szamski/main/boot.sh)
```

## What it installs

### Terminal (always)

- Ghostty
- Starship
- Zoxide
- Neovim + LazyVim
- Fastfetch
- btop
- Docker + Compose
- mise
- fzf, ripgrep, bat, eza, fd-find, plocate, apache2-utils
- lazygit, lazydocker

### Desktop (optional, via gum)

- VS Code (.deb)
- Discord (snap or .deb)
- Slack (snap)
- Spotify (snap or .deb)
- Riff (Spotify GTK, Flatpak)
- LibreOffice
- LocalSend (Flatpak)
- Google Chrome or Chromium (Flatpak + Google Sync)
- 1Password
- Dropbox

### GNOME extras

- Papirus icon theme with color variants
- Extensions: Just Perfection, Blur My Shell, Alphabetical App Grid, TopHat
- Hotkeys and GNOME settings

### Themes

Themes apply to GNOME (GTK + wallpaper), Ghostty, Neovim, btop, and Starship.

Change theme:

```bash
omakub-szamski theme
```

### VPN (optional)

- Tailscale
- NordVPN

### Laptop

- TLP with laptop-friendly defaults

## Configs and backups

All settings live in `configs/` and are copied into `~/.config`. Before overwriting, the installer creates a backup in `~/.config-backup-YYYYMMDD_HHMMSS/`.

## Post-install

### Tailscale

```bash
sudo tailscale up
```

### NordVPN

```bash
nordvpn login
nordvpn set technology nordlynx
nordvpn set killswitch on
```

### Docker

Log out and back in so the `docker` group takes effect.

## Helper command

After install you get `omakub-szamski`:

```bash
omakub-szamski help
omakub-szamski update
omakub-szamski reinstall
omakub-szamski backup
omakub-szamski list-backups
omakub-szamski restore ~/.config-backup-YYYYMMDD_HHMMSS
```

## Project layout

```
Omakub_by_Szamski/
├── boot.sh
├── install.sh
├── install/
├── configs/
├── themes/
├── defaults/
└── bin/
```
