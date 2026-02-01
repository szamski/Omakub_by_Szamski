#!/bin/bash

source "$SIMPLE_PATH/lib/utils.sh"

# Consistency check
ensure_no_snap "code"
ensure_no_flatpak "com.visualstudio.code"

# Check if VS Code (.deb) is already installed
if command -v code >/dev/null 2>&1; then
  echo "Skip: VS Code already installed"
else
  # Download and install VS Code .deb
  echo "Installing VS Code..."
  cd /tmp
  wget -qO vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
  sudo dpkg -i vscode.deb
  sudo apt-get install -f -y
  rm vscode.deb
  cd - >/dev/null
fi

echo "Done: VS Code installed"
