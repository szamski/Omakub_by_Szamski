#!/bin/bash

# Install OnlyOffice Desktop Editors
# Free office suite compatible with MS Office formats

if command -v onlyoffice-desktopeditors >/dev/null 2>&1; then
  echo "Skip: OnlyOffice already installed"
  exit 0
fi

echo "Installing OnlyOffice..."
cd /tmp
wget -q https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb
sudo dpkg -i onlyoffice-desktopeditors_amd64.deb || sudo apt-get install -f -y
rm onlyoffice-desktopeditors_amd64.deb
cd - >/dev/null

echo "Done: OnlyOffice installed"
