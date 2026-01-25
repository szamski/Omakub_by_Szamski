#!/bin/bash

if [ ! -f /etc/os-release ]; then
  echo "Unsupported system: /etc/os-release not found."
  exit 1
fi

source /etc/os-release

if [[ "$ID" != "ubuntu" ]]; then
  echo "Omakub_by_Szamski supports Ubuntu only. Detected: $ID"
  exit 1
fi

if ! dpkg --compare-versions "$VERSION_ID" ge "22.04"; then
  echo "Omakub_by_Szamski requires Ubuntu 22.04+ (detected $VERSION_ID)."
  exit 1
fi
