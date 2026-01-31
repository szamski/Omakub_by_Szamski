#!/bin/bash

# Skip if LibreOffice is already installed
if command -v libreoffice >/dev/null 2>&1; then
  echo "Skip: LibreOffice already installed"
  return 0
fi

echo "Installing LibreOffice..."
sudo apt update
sudo apt install -y libreoffice

echo "Done: LibreOffice installed"
