#!/bin/bash

if [[ "$DISCORD_REMOVE_SNAP" == true ]]; then
  if snap list discord >/dev/null 2>&1; then
    sudo snap remove discord
  fi
fi

if ! command -v discord >/dev/null 2>&1 || [[ "$DISCORD_REMOVE_SNAP" == true ]]; then
  cd /tmp
  wget https://discord.com/api/download?platform=linux -O discord.deb
  sudo apt install -y ./discord.deb
  rm discord.deb
  cd - >/dev/null
fi
