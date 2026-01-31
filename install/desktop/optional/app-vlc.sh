#!/bin/bash

source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"

ensure_no_snap "vlc"
ensure_no_flatpak "org.videolan.VLC"

sudo apt install -y vlc
echo "Done: VLC installed"
