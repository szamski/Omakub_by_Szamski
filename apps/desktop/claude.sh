#!/bin/bash

# Install Claude Desktop
# AI assistant desktop application

if command -v claude >/dev/null 2>&1; then
  echo "Skip: Claude Desktop already installed"
  exit 0
fi

echo "Installing Claude Desktop..."

# Download and install Claude Desktop
cd /tmp
wget -q https://storage.googleapis.com/osprey-downloads-c02f6a0d-347c-492b-a752-3e0651722e97/nest-linux-x64/Claude-x86_64.AppImage -O claude.appimage

# Make it executable and move to /usr/local/bin
chmod +x claude.appimage
sudo mv claude.appimage /usr/local/bin/claude

# Create desktop entry
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/claude.desktop <<'EOF'
[Desktop Entry]
Name=Claude
Comment=AI Assistant
Exec=/usr/local/bin/claude
Icon=claude
Terminal=false
Type=Application
Categories=Office;Utility;
EOF

cd - >/dev/null

echo "Done: Claude Desktop installed"
