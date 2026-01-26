#!/bin/bash

# Install Rust toolchain if missing
if command -v cargo >/dev/null 2>&1; then
  echo "⏭️  Rust toolchain already installed, skipping..."
  return 0
fi

echo "Installing Rust toolchain..."
sudo apt update
sudo apt install -y rustc cargo

echo "✓ Rust toolchain installed"
