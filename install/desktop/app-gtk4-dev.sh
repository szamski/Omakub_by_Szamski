#!/bin/bash

# Install GTK4 development libraries for theme switcher GUI
if pkg-config --exists gtk4; then
  echo "Skip: GTK4 dev libraries already installed"
  return 0
fi

echo "Installing GTK4 development libraries..."
sudo apt update
sudo apt install -y libgtk-4-dev pkg-config

echo "Done: GTK4 development libraries installed"
