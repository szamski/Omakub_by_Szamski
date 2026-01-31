#!/bin/bash

# Rust toolchain (rustc/cargo) is installed via libraries.sh
# This script exists for future extensibility (e.g., rustup installation)
if command -v cargo >/dev/null 2>&1; then
  echo "Skip: Rust toolchain already installed"
  return 0
fi

echo "Error: Rust toolchain not found. This should have been installed via libraries.sh"
return 1
