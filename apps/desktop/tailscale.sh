#!/bin/bash

# Install Tailscale VPN
# Zero config VPN for secure networking

if command -v tailscale >/dev/null 2>&1; then
  echo "Skip: Tailscale already installed"
  exit 0
fi

echo "Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

echo "Done: Tailscale installed"
echo "Run 'sudo tailscale up' to connect"
