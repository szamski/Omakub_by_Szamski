#!/bin/bash

CURRENT_NAME=$(git config --global user.name 2>/dev/null || true)
CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || true)

if [[ -n "$CURRENT_NAME" && -n "$CURRENT_EMAIL" ]]; then
  echo "Git is already configured:"
  echo "  Name: $CURRENT_NAME"
  echo "  Email: $CURRENT_EMAIL"

  KEEP_CONFIG=$(gum choose "Keep current config" "Change it" --header "Git configuration")
  if [[ "$KEEP_CONFIG" == "Keep current config" ]]; then
    return 0
  fi
fi

GIT_NAME=$(gum input --placeholder "Your full name" --header "Git user.name")
GIT_EMAIL=$(gum input --placeholder "you@example.com" --header "Git user.email")

if [[ -n "$GIT_NAME" ]]; then
  git config --global user.name "$GIT_NAME"
fi

if [[ -n "$GIT_EMAIL" ]]; then
  git config --global user.email "$GIT_EMAIL"
fi

echo "Done: Git configured"
