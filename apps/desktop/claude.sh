#!/bin/bash

# Install Claude Code CLI
# AI-powered coding assistant from Anthropic

if command -v claude >/dev/null 2>&1; then
  echo "Skip: Claude Code already installed"
  exit 0
fi

echo "Installing Claude Code CLI..."

# Install via npm (requires Node.js from mise)
if command -v npm >/dev/null 2>&1; then
  npm install -g @anthropic-ai/claude-code
else
  echo "Warning: npm not found. Install mise and Node.js first."
  exit 1
fi

echo "Done: Claude Code installed"
echo "Run 'claude --help' to get started"
