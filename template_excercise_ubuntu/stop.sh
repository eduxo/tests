#!/bin/bash
# This script prepare container debian:12 for exercise
# https://pve.proxmox.com/pve-docs/pct.1.html

# ------------------------------------ SERVER A -------------------------------------------
# Container Server A Settings
ID="101"
HOSTNAME="serverA"
IPv4="10.20.30.101"

# Destroy Container Server A
echo -e '\e[0;92mDestroying Container ...\e[0m'
sudo pct destroy $ID \
    --purge 1 \
    --destroy-unreferenced-disks 1 \
    --force 1 &&\

sleep 2 &&\

# Edit /etc/hosts
sudo sed -i '/'$IPv4' '$HOSTNAME' '$HOSTNAME'.eduxo.lab/d' /etc/hosts


# ------------------------------------ SERVER B -------------------------------------------
# Container Server B Settings
ID="102"
HOSTNAME="serverB"
IPv4="10.20.30.102"

# Destroy Container Server B
echo -e '\e[0;92mDestroying Container ...\e[0m'
sudo pct destroy $ID \
    --purge 1 \
    --destroy-unreferenced-disks 1 \
    --force 1 &&\

sleep 2 &&\

# Edit /etc/hosts
sudo sed -i '/'$IPv4' '$HOSTNAME' '$HOSTNAME'.eduxo.lab/d' /etc/hosts

echo -e '\n\e[0;92mDONE\e[0m'