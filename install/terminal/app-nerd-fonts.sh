#!/bin/bash

# Install Nerd Fonts (CascadiaCode/CaskaydiaCove for Ghostty and terminal use)

# Check if fonts are already installed - skip if found
if [[ -d ~/.fonts/CaskaydiaCove ]] && \
   [[ $(find ~/.fonts/CaskaydiaCove -name "*.ttf" 2>/dev/null | wc -l) -gt 0 ]]; then
  echo "⏭️  CaskaydiaCove Nerd Font already installed, skipping..."
  return 0
fi

echo "Installing Nerd Fonts..."

# Make sure unzip is installed
if ! command -v unzip >/dev/null 2>&1; then
  echo "Installing unzip..."
  sudo apt update -y
  sudo apt install -y unzip
fi

mkdir -p ~/.fonts
cd /tmp

# CascadiaCode Nerd Font (contains CaskaydiaCove with ligatures)
echo "Downloading CaskaydiaCove Nerd Font..."
if ! wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip; then
  echo "❌ Failed to download Nerd Font"
  echo "   You can install it manually later"
  cd - >/dev/null
  return 0
fi

echo "Extracting font files..."
if ! unzip -q CascadiaCode.zip -d CascadiaFont; then
  echo "❌ Failed to extract font files"
  echo "   You can install it manually later"
  rm -rf CascadiaCode.zip
  cd - >/dev/null
  return 0
fi

mkdir -p ~/.fonts/CaskaydiaCove

# Copy .ttf files (check if any exist)
if ls CascadiaFont/*.ttf 1> /dev/null 2>&1; then
  cp CascadiaFont/*.ttf ~/.fonts/CaskaydiaCove/
  echo "✓ CaskaydiaCove Nerd Font installed ($(ls CascadiaFont/*.ttf | wc -l) files)"
else
  echo "⚠️  No .ttf files found in archive"
fi

rm -rf CascadiaCode.zip CascadiaFont

# Refresh font cache
if command -v fc-cache >/dev/null 2>&1; then
  echo "Refreshing font cache..."
  fc-cache -fv ~/.fonts
  echo "✓ Font cache refreshed"
else
  echo "⚠️  fc-cache not found, installing fontconfig..."
  sudo apt install -y fontconfig
  fc-cache -fv ~/.fonts
  echo "✓ Font cache refreshed"
fi

cd - >/dev/null

echo "✓ Nerd Fonts installation complete"
echo "  Available fonts:"
echo "  - CaskaydiaCove Nerd Font Mono (for terminals)"
echo "  - CaskaydiaCove Nerd Font (for applications)"
