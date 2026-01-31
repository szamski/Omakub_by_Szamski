#!/bin/bash

source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"

install_config "$OMAKUB_SZAMSKI_PATH/configs/bashrc" "$HOME/.bashrc" "bashrc"
install_config "$OMAKUB_SZAMSKI_PATH/configs/inputrc" "$HOME/.inputrc" "inputrc"

source "$OMAKUB_SZAMSKI_PATH/defaults/bash/shell"
