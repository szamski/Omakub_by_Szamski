#!/bin/bash

if [[ "$AUTO_BACKUP" == true ]]; then
  backup_config "$HOME/.bashrc"
  backup_config "$HOME/.inputrc"
fi

cp "$OMAKUB_SZAMSKI_PATH/configs/bashrc" ~/.bashrc
cp "$OMAKUB_SZAMSKI_PATH/configs/inputrc" ~/.inputrc

source "$OMAKUB_SZAMSKI_PATH/defaults/bash/shell"
