#!/bin/bash

# Install OpenCode - Open source AI coding assistant
# https://github.com/opencode-ai/opencode

if command -v opencode >/dev/null 2>&1; then
  echo "⏭️  OpenCode already installed"
  exit 0
fi

echo "Installing OpenCode..."

# Install via Go (requires Go to be installed)
if command -v go >/dev/null 2>&1; then
  go install github.com/opencode-ai/opencode@latest
else
  # Fallback: download binary
  OPENCODE_VERSION=$(curl -s https://api.github.com/repos/opencode-ai/opencode/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
  if [[ -n "$OPENCODE_VERSION" ]]; then
    curl -fsSL "https://github.com/opencode-ai/opencode/releases/download/v${OPENCODE_VERSION}/opencode_${OPENCODE_VERSION}_linux_amd64.tar.gz" | tar -xz -C /tmp
    sudo mv /tmp/opencode /usr/local/bin/
    sudo chmod +x /usr/local/bin/opencode
  else
    echo "⚠ Could not determine OpenCode version, skipping..."
    exit 1
  fi
fi

echo "✓ OpenCode installed"
echo "  Run 'opencode' to start"
