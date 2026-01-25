#!/bin/bash

if ! snap list slack >/dev/null 2>&1; then
  sudo snap install slack
fi
