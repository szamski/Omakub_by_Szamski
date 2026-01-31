#!/bin/bash

source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"

# Ensure consistent source
ensure_no_snap "spotify"
ensure_no_flatpak "com.spotify.Client"

# Stream music using https://spotify.com
if [ ! -f /etc/apt/sources.list.d/spotify.list ]; then
  [ -f /etc/apt/trusted.gpg.d/spotify.gpg ] && sudo rm /etc/apt/trusted.gpg.d/spotify.gpg
  curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
  echo "deb [signed-by=/etc/apt/trusted.gpg.d/spotify.gpg] https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
fi

sudo apt update
sudo apt install -y spotify-client
echo "Done: Spotify installed via apt"
