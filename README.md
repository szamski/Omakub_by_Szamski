# Omakub_by_Szamski

Personalny setup dla Ubuntu inspirowany Omakub, ale dopasowany do Twojego obecnego srodowiska (Ghostty, Starship, Catppuccin Mocha) i bez wywracania systemu do gory nogami.

## Wymagania

- Ubuntu 22.04+
- GNOME (opcjonalnie, dla ustawien desktopowych)

## Instalacja

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/szamski/Omakub_by_Szamski/main/boot.sh)
```

### Dry-run (bez zmian w systemie)

```bash
OMAKUB_SZAMSKI_DRY_RUN=1 bash <(curl -fsSL https://raw.githubusercontent.com/szamski/Omakub_by_Szamski/main/boot.sh)
```

Lokalnie mozesz uruchomic:

```bash
./install.sh --dry-run
```

Mozesz tez ustawic repo lub ref:

```bash
OMAKUB_SZAMSKI_REPO="https://github.com/TwojUser/Omakub_by_Szamski.git" \
OMAKUB_SZAMSKI_REF="main" \
bash <(curl -fsSL https://raw.githubusercontent.com/szamski/Omakub_by_Szamski/main/boot.sh)
```

## Co instaluje

### Terminal (zawsze)

- Ghostty (konfiguracja zachowana)
- Starship (konfiguracja zachowana)
- Zoxide
- Neovim + LazyVim (Catppuccin Mocha)
- Fastfetch
- Btop (Catppuccin Mocha)
- Docker + Compose
- Mise
- FZF, ripgrep, bat, eza, fd-find, plocate, apache2-utils
- Lazygit, Lazydocker

### Desktop (opcjonalnie, przez gum)

- VS Code (.deb)
- Discord (snap lub .deb)
- Slack (snap)
- Spotify (snap lub .deb)
- Google Chrome lub Chromium (Flatpak + Google Sync)
- 1Password
- Dropbox

### VPN (opcjonalnie)

- Tailscale
- NordVPN

### Laptop

- TLP z optymalizacja (auto-detect laptopa)

## Konfiguracje

Wszystkie ustawienia trzymane sa w katalogu `configs/` i kopiowane do `~/.config`.
Przed nadpisaniem tworzony jest backup w `~/.config-backup-YYYYMMDD_HHMMSS/`.

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

Wyloguj i zaloguj sie ponownie, zeby grupa `docker` zadzialala.

## Narzedzie pomocnicze

Po instalacji dostajesz komende `omakub-szamski`:

```bash
omakub-szamski help
omakub-szamski update
omakub-szamski reinstall
omakub-szamski backup
omakub-szamski list-backups
omakub-szamski restore ~/.config-backup-YYYYMMDD_HHMMSS
```

## Struktura projektu

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
