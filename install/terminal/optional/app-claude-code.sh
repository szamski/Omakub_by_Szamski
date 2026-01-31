#!/bin/bash

# Install Claude Code (Anthropic's official CLI)
# Requires Node.js (installed via mise)

if command -v claude >/dev/null 2>&1; then
  echo "Skip: Claude Code already installed"
  exit 0
fi

echo "Installing Claude Code..."

# Install via npm globally
npm install -g @anthropic-ai/claude-code

echo "Done: Claude Code installed"
echo "  Run 'claude' to start"
