#!/bin/bash

sudo apt install -y fzf ripgrep bat eza zoxide plocate apache2-utils fd-find

if command -v pipx >/dev/null 2>&1; then
  if ! command -v tldr >/dev/null 2>&1; then
    pipx install tldr
  fi
fi
