#!/bin/bash

# Web Apps Selection Logic (to be sourced in first-run-choices.sh or run standalone)
# This script handles the installation based on exported variables, similar to other apps.

if [[ -n "$SELECTED_WEB_APPS" ]]; then
  IFS=$','
  for app in $SELECTED_WEB_APPS; do
    case $app in
    "Chat GPT")
      source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/web-chatgpt.sh"
      ;;
    "Google Photos")
      source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/web-google-photos.sh"
      ;;
    "Google Contacts")
      source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/web-google-contacts.sh"
      ;;
    "Tailscale")
      source "$OMAKUB_SZAMSKI_PATH/install/desktop/optional/web-tailscale.sh"
      ;;
    esac
  done
fi
