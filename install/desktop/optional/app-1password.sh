#!/bin/bash

cd /tmp
wget https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb -O 1password.deb
sudo apt install -y ./1password.deb
rm 1password.deb
cd - >/dev/null
