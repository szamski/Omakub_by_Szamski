#!/bin/bash

# Simple utility functions for Omakub Simple Edition

# Copy config file if it doesn't exist or ask to override
install_config() {
  local source="$1"
  local target="$2"
  local name="${3:-config}"

  if [ ! -f "$source" ]; then
    echo "Warning: Source file $source not found, skipping $name"
    return 0
  fi

  mkdir -p "$(dirname "$target")"

  if [ -f "$target" ]; then
    echo "Config $name already exists at $target, overwriting..."
  fi

  cp "$source" "$target"
  echo "Installed: $name -> $target"
}

# Ensure package is not installed via snap
ensure_no_snap() {
  local pkg="$1"
  if snap list "$pkg" 2>/dev/null | grep -q "$pkg"; then
    echo "Removing snap package: $pkg"
    sudo snap remove --purge "$pkg"
  fi
}

# Ensure package is not installed via flatpak
ensure_no_flatpak() {
  local pkg="$1"
  if flatpak list 2>/dev/null | grep -q "$pkg"; then
    echo "Removing flatpak package: $pkg"
    flatpak uninstall -y "$pkg"
  fi
}

# Run apt update only once
apt_update_once() {
  if [[ "${APT_UPDATED:-false}" != "true" ]]; then
    sudo apt update -y
    export APT_UPDATED=true
  fi
}
