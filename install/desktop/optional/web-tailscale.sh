#!/bin/bash
source $OMAKUB_SZAMSKI_PATH/install/terminal/utils.sh
web2app 'Tailscale' https://login.tailscale.com/admin/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/tailscale-light.png
app2folder 'Tailscale.desktop' WebApps
