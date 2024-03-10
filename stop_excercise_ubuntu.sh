#!/bin/bash
# This script prepare container debian:12 for exercise
# https://pve.proxmox.com/pve-docs/pct.1.html

# Container Settings
ID="102"

# Stop container
echo -e '\n\e[0;92mStopping Container ...\e[0m'
sudo pct shutdown $ID \
#    --forceStop 0 \
#    --timeout 60 &&\
sleep 5 &&\

# Destroy container
echo -e '\e[0;92mDestroying Container ...\e[0m'
sudo pct destroy $ID \
    --purge 1 \
    --destroy-unreferenced-disks 1 \
    --force 1 &&\

sleep 5 &&\
echo -e '\n\e[0;92mDONE\e[0m'