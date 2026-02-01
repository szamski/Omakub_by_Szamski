#!/bin/bash

# Install LocalSend
# Share files to nearby devices

if command -v localsend_app >/dev/null 2>&1; then
  echo "Skip: LocalSend already installed"
  exit 0
fi

echo "Installing LocalSend..."
cd /tmp
wget -q https://github.com/localsend/localsend/releases/download/v1.17.0/LocalSend-1.17.0-linux-x86-64.deb
sudo dpkg -i LocalSend-1.17.0-linux-x86-64.deb || sudo apt-get install -f -y
rm LocalSend-1.17.0-linux-x86-64.deb
cd - >/dev/null

echo "Done: LocalSend installed"
