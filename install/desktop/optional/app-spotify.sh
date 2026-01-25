#!/bin/bash

if [[ "$SPOTIFY_REMOVE_SNAP" == true ]]; then
  if snap list spotify >/dev/null 2>&1; then
    sudo snap remove spotify
  fi
fi

if ! command -v spotify >/dev/null 2>&1 || [[ "$SPOTIFY_REMOVE_SNAP" == true ]]; then
  if [ ! -f /etc/apt/sources.list.d/spotify.list ]; then
    [ -f /etc/apt/trusted.gpg.d/spotify.gpg ] && sudo rm /etc/apt/trusted.gpg.d/spotify.gpg
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/spotify.gpg] https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
  fi

  sudo apt update
  sudo apt install -y spotify-client
fi
