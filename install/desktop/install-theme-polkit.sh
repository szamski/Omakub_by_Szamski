#!/bin/bash
# Install PolicyKit policy for Omakub theme switching

OMAKUB_PATH="${OMAKUB_SZAMSKI_PATH:-$HOME/.local/share/omakub-szamski}"

# Install the root helper script
sudo install -m 755 "$OMAKUB_PATH/bin/omakub-theme-root" /usr/local/bin/omakub-theme-root

# Install PolicyKit policy
sudo install -m 644 "$OMAKUB_PATH/install/desktop/com.omakub.theme.policy" /usr/share/polkit-1/actions/com.omakub.theme.policy

echo "PolicyKit policy installed for Omakub theme switching"
