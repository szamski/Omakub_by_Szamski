#!/bin/bash

sudo apt install -y gnome-shell-extension-manager gir1.2-gtop-2.0 gir1.2-clutter-1.0

if command -v gext >/dev/null 2>&1; then
  echo "⏭️  gnome-extensions-cli already installed"
else
  pipx install gnome-extensions-cli
fi

# Pause to assure user is ready to accept confirmations
if command -v gum >/dev/null 2>&1; then
  gum confirm "To install Gnome extensions, you need to accept some confirmations. Ready?"
else
  read -r -p "To install Gnome extensions, you need to accept some confirmations. Ready? (y/N) " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || return 0
fi

# Install new extensions
gext install just-perfection-desktop@just-perfection || true
gext install blur-my-shell@aunetx || true
gext install AlphabeticalAppGrid@stuarthayhurst || true
gext install tophat@fflewddur.github.io || true

# Compile gsettings schemas in order to be able to set them
sudo cp ~/.local/share/gnome-shell/extensions/just-perfection-desktop\@just-perfection/schemas/org.gnome.shell.extensions.just-perfection.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/blur-my-shell\@aunetx/schemas/org.gnome.shell.extensions.blur-my-shell.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/tophat\@fflewddur.github.io/schemas/org.gnome.shell.extensions.tophat.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/AlphabeticalAppGrid\@stuarthayhurst/schemas/org.gnome.shell.extensions.AlphabeticalAppGrid.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

# Configure Just Perfection
gsettings set org.gnome.shell.extensions.just-perfection animation 2
gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true
gsettings set org.gnome.shell.extensions.just-perfection workspace true
gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false

# Configure TopHat
gsettings set org.gnome.shell.extensions.tophat show-icons false
gsettings set org.gnome.shell.extensions.tophat show-cpu false
gsettings set org.gnome.shell.extensions.tophat show-disk false
gsettings set org.gnome.shell.extensions.tophat show-mem false
gsettings set org.gnome.shell.extensions.tophat show-fs false
gsettings set org.gnome.shell.extensions.tophat network-usage-unit bits

# Configure AlphabeticalAppGrid
gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'

enable_extension() {
  local target="$1"
  local installed
  installed=$(gnome-extensions list 2>/dev/null | grep -i "^${target}$" || true)
  if [[ -z "$installed" ]]; then
    installed=$(gnome-extensions list 2>/dev/null | grep -i "${target}" | head -1 || true)
  fi
  if [[ -n "$installed" ]]; then
    gnome-extensions enable "$installed" >/dev/null 2>&1 || true
  fi
}

# Enable extensions (ignore failures if not supported)
enable_extension "just-perfection-desktop@just-perfection"
enable_extension "blur-my-shell@aunetx"
enable_extension "alphabetical-app-grid@stuarthayhurst"
enable_extension "AlphabeticalAppGrid@stuarthayhurst"
enable_extension "tophat@fflewddur.github.io"

# Configure Blur My Shell from saved settings
OMAKUB_SZAMSKI_PATH="${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub-szamski}"
if [[ -f "$OMAKUB_SZAMSKI_PATH/configs/gnome/blur-my-shell.dconf" ]]; then
  dconf load /org/gnome/shell/extensions/blur-my-shell/ < "$OMAKUB_SZAMSKI_PATH/configs/gnome/blur-my-shell.dconf"
fi
