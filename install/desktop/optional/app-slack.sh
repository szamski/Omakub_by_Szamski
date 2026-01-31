#!/bin/bash

source "$OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh"

# Consistency check
ensure_no_snap "slack"
ensure_no_flatpak "com.slack.Slack"

# Install Slack via apt repository (no snap/flatpak)
if command -v slack >/dev/null 2>&1; then
  echo "Skip: Slack already installed"
  return 0
fi

echo "Installing Slack via apt..."

SLACK_KEYRING="/usr/share/keyrings/slack.gpg"
SLACK_LIST="/etc/apt/sources.list.d/slack.list"

if [ ! -f "$SLACK_LIST" ]; then
  curl -fsSL https://packagecloud.io/slacktechnologies/slack/gpgkey | sudo gpg --dearmor --yes -o "$SLACK_KEYRING"
  echo "deb [signed-by=$SLACK_KEYRING] https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" | sudo tee "$SLACK_LIST"
fi

sudo apt update
sudo apt install -y slack-desktop
echo "Done: Slack installed via apt"
