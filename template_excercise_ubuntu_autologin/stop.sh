#!/bin/bash
# This script prepare container debian:12 for exercise
# https://pve.proxmox.com/pve-docs/pct.1.html

# Container Settings
ID="102"
HOSTNAME="ubuntu"
IPv4="10.20.30.102"

# Destroy container
echo -e '\e[0;92mDestroying Container ...\e[0m'
sudo pct destroy $ID \
    --purge 1 \
    --destroy-unreferenced-disks 1 \
    --force 1 &&\

sleep 2 &&\

# Edit /etc/hosts
sudo sed -i '/'$IPv4' '$HOSTNAME' '$HOSTNAME'.eduxo.lab/d' /etc/hosts
echo -e '\n\e[0;92mDONE\e[0m'