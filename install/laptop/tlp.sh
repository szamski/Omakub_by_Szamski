#!/bin/bash

if ! command -v tlp >/dev/null 2>&1; then
  sudo apt install -y tlp tlp-rdw
fi

sudo systemctl enable tlp.service
sudo systemctl start tlp.service

if [[ "$TLP_OPTIMIZE" == true ]]; then
  if [[ "$AUTO_BACKUP" == true ]] && [ -f /etc/tlp.conf ]; then
    mkdir -p "$BACKUP_DIR/etc"
    sudo cp /etc/tlp.conf "$BACKUP_DIR/etc/tlp.conf"
  fi

  sudo tee -a /etc/tlp.conf >/dev/null <<'EOF'

# === Omakub_by_Szamski TLP Optimizations ===

CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave

CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=balance_power

CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0

PLATFORM_PROFILE_ON_AC=performance
PLATFORM_PROFILE_ON_BAT=low-power

START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80

RUNTIME_PM_ON_AC=on
RUNTIME_PM_ON_BAT=auto

WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=on

SOUND_POWER_SAVE_ON_AC=0
SOUND_POWER_SAVE_ON_BAT=1

USB_AUTOSUSPEND=1
EOF

  sudo tlp start
fi
