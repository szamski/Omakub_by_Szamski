#!/bin/bash

# Prefer snap version (better performance and updates)
# Set SPOTIFY_USE_APT=true to force apt installation

# Check if Spotify is already installed (any version) - skip if found
if command -v spotify >/dev/null 2>&1 || snap list spotify >/dev/null 2>&1; then
  echo "⏭️  Spotify already installed, skipping..."
  return 0
fi

if [[ "$SPOTIFY_USE_APT" == true ]]; then
  # Install via apt
  echo "Installing Spotify via apt..."
  
  if [ ! -f /etc/apt/sources.list.d/spotify.list ]; then
    [ -f /etc/apt/trusted.gpg.d/spotify.gpg ] && sudo rm /etc/apt/trusted.gpg.d/spotify.gpg
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/spotify.gpg] https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
  fi
  
  sudo apt update
  sudo apt install -y spotify-client
  echo "✓ Spotify installed via apt"
else
  # Default: Install via snap (recommended)
  echo "Installing Spotify via snap (recommended)..."
  
  # Remove apt version if exists
  if dpkg -l | grep -q spotify-client 2>/dev/null; then
    echo "Removing apt version of Spotify..."
    sudo apt remove -y spotify-client
    sudo rm -f /etc/apt/sources.list.d/spotify.list
    sudo rm -f /etc/apt/trusted.gpg.d/spotify.gpg
  fi
  
  # Install via snap
  sudo snap install spotify
  echo "✓ Spotify installed via snap"
fi
