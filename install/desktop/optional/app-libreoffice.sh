#!/bin/bash

# Skip if LibreOffice is already installed
if command -v libreoffice >/dev/null 2>&1; then
  echo "⏭️  LibreOffice already installed, skipping..."
  return 0
fi

echo "Installing LibreOffice..."
sudo apt update
sudo apt install -y libreoffice

echo "✓ LibreOffice installed"
