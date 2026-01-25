#!/bin/bash

backup_config() {
  local path="$1"

  if [[ -f "$path" || -d "$path" ]]; then
    mkdir -p "$BACKUP_DIR"
    local backup_path="$BACKUP_DIR/${path#$HOME/}"
    mkdir -p "$(dirname "$backup_path")"
    cp -r "$path" "$backup_path"
    echo "  ✓ Backed up: $path"
  fi
}

export -f backup_config
