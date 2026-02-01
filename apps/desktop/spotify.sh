#!/bin/bash

source "$SIMPLE_PATH/lib/utils.sh"

# Ensure consistent source
ensure_no_apt "spotify-client"
ensure_no_flatpak "com.spotify.Client"

# Stream music using https://spotify.com
sudo snap install spotify
echo "Done: Spotify installed via snap"
