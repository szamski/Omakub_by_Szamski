#!/bin/bash

source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"

# Remove snap/flatpak if detected to ensure consistency
ensure_no_snap "discord"
ensure_no_flatpak "com.discordapp.Discord"

# A Communication platform for voice, video, and text messaging https://discord.com/
cd /tmp
wget https://discord.com/api/download?platform=linux -O discord.deb
sudo apt install ./discord.deb -y
rm discord.deb
cd - >/dev/null
