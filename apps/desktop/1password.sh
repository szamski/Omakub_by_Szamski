#!/bin/bash

# Install 1Password GUI
cd /tmp
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb -O 1password.deb
sudo apt install -y ./1password.deb
rm 1password.deb

# Install 1Password CLI
if ! command -v op >/dev/null 2>&1; then
  echo "Installing 1Password CLI..."
  wget https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-amd64-latest.deb -O 1password-cli.deb
  sudo apt install -y ./1password-cli.deb
  rm 1password-cli.deb
fi

cd - >/dev/null

autostart_dir="$HOME/.config/autostart"
autostart_file="$autostart_dir/1password.desktop"

if command -v 1password >/dev/null 2>&1; then
  mkdir -p "$autostart_dir"
  cat >"$autostart_file" <<'EOF'
[Desktop Entry]
Type=Application
Name=1Password
Exec=1password --silent
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=5
NoDisplay=true
EOF
fi

echo "Done: 1Password and 1Password CLI installed"
