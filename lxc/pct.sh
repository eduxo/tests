#!/bin/bash
# This script prepare container debian:12 for exercise

pct create 102 /var/lib/vz/template/cache/debian-12-standard_12.2-1_amd64.tar.zst \
    -arch amd64 \
    -ostype debian \
    -hostname name \
    -cores 1 \
    -memory 512 \
    -swap 512 \
    -storage local-lvm \
    -net0 name=eth0,bridge=vmbr1,gw=10.20.30.1,ip=10.20.30.102/24,type=veth  &&\
pct start 102 &&\
sleep 10 &&\

pct exec 102 -- bash -c "apt update -y &&\
    apt install -y openssh-server &&\
    systemctl start sshd &&\
    useradd -mU sysadmin &&\
    echo "sysadmin:Netlab!23" | chpasswd"


# --------------------------------SETTINGS FOR EXERCISES---------------------------------------



# --------------------------------SETTINGS FOR EXERCISES---------------------------------------