#!/bin/bash

set -e

ascii_art=$(cat <<'EOF'
 _______                 __          __        ____        _____            __         __
|   _   .-----.-----.----|  |_.--.--.|  |_.----|    |      |  _  |--.--.-----|  |_.--.--|  |--.----.
|.  1   |  _  |  _  |   _|   _|  |  ||   _|   _|    |      |   __|  |  |__ --|   _|  |  |  _  |   _|
|.  ____|_____|_____|__| |____|_____||____|__| |____|      |__|  |_____|_____|____|_____|_____|__|
|:  |
|:: |
`---'
EOF
)

echo -e "$ascii_art"
echo "=> Omakub_by_Szamski is for Ubuntu 22.04+ installations!"
echo -e "\nBegin installation (or abort with ctrl+c)..."

sudo apt-get update >/dev/null
sudo apt-get install -y git >/dev/null

REPO_URL="${OMAKUB_SZAMSKI_REPO:-https://github.com/szamski/Omakub_by_Szamski.git}"

echo "Cloning Omakub_by_Szamski..."
rm -rf ~/.local/share/omakub-szamski
git clone "$REPO_URL" ~/.local/share/omakub-szamski >/dev/null

if [[ -n "$OMAKUB_SZAMSKI_REF" ]]; then
  cd ~/.local/share/omakub-szamski
  git fetch origin "$OMAKUB_SZAMSKI_REF" && git checkout "$OMAKUB_SZAMSKI_REF"
  cd - >/dev/null
fi

echo "Installation starting..."
source ~/.local/share/omakub-szamski/install.sh
