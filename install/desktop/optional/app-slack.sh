#!/bin/bash

# Install Slack via apt repository (no snap/flatpak)
if command -v slack >/dev/null 2>&1; then
  echo "⏭️  Slack already installed, skipping..."
  return 0
fi

if snap list slack >/dev/null 2>&1; then
  sudo snap remove slack >/dev/null 2>&1 || true
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
echo "✓ Slack installed via apt"
