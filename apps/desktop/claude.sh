#!/bin/bash

# Install Claude Code CLI
# AI-powered coding assistant from Anthropic

if command -v claude >/dev/null 2>&1; then
  echo "Skip: Claude Code already installed"
  exit 0
fi

echo "Installing Claude Code CLI..."

# Install via official installer
curl -fsSL https://claude.ai/install.sh | bash

echo "Done: Claude Code installed"
echo "Run 'claude --help' to get started"
