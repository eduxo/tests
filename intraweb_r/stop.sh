#!/bin/bash
# This script prepare container debian:12 for exercise
# https://pve.proxmox.com/pve-docs/pct.1.html

# Container Settings
ID="120"
HOSTNAME="intraweb"
IPv4="10.20.30.120"

# Destroy container
echo -e '\e[0;92m\nDestroying Container ...\e[0m\n'
sudo pct destroy $ID \
    --purge 1 \
    --destroy-unreferenced-disks 1 \
    --force 1 &&\

sleep 2 &&\

# Edit /etc/hosts
sudo sed -i '/'$IPv4' '$HOSTNAME' '$HOSTNAME'.eduxo.lab/d' /etc/hosts
echo -e '\e[0;92m\nDONE\e[0m\n'