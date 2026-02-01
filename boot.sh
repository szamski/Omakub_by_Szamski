#!/bin/bash

set -e

ascii_art=$(cat <<'EOF'
 _______                 __          __        ____        _____            __         __
|   _   .-----.-----.----|  |_.--.--.|  |_.----|    |      |  _  |--.--.-----|  |_.--.--|  |--.----.
|.  1   |  _  |  _  |   _|   _|  |  ||   _|   _|    |      |   __|  |  |__ --|   _|  |  |  _  |   _|
|.  ____|_____|_____|__| |____|_____||____|__| |____|      |__|  |_____|_____|____|_____|_____|__|
|:  |                            SIMPLE EDITION
|:: |
`---'
EOF
)

echo -e "$ascii_art"
echo "=> Omakub_by_Szamski Simple Edition for Ubuntu 25.04+"
echo -e "\nBegin installation (or abort with ctrl+c)..."

sudo apt-get update >/dev/null
sudo apt-get install -y git >/dev/null

REPO_URL="${OMAKUB_SZAMSKI_REPO:-https://github.com/szamski/Omakub_by_Szamski.git}"
BRANCH="${OMAKUB_SZAMSKI_BRANCH:-simple-installer}"

echo "Cloning Omakub_by_Szamski (Simple Edition)..."
rm -rf ~/.local/share/omakub-simple
git clone -b "$BRANCH" "$REPO_URL" ~/.local/share/omakub-simple >/dev/null 2>&1 || \
  git clone "$REPO_URL" ~/.local/share/omakub-simple >/dev/null

cd ~/.local/share/omakub-simple
git checkout "$BRANCH" 2>/dev/null || true
cd - >/dev/null

echo "Installation starting..."
source ~/.local/share/omakub-simple/install.sh
