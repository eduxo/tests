#!/bin/bash
# This script prepare container debian:12 for exercise

ID="103"
HOSTNAME="103"
IPv4="10.20.30.103/24"

pct create "$ID" /var/lib/vz/template/cache/debian-12-standard_12.2-1_amd64.tar.zst \
    -arch amd64 \
    -ostype debian \
    -hostname $HOSTNAME \
    -cores 1 \
    -memory 512 \
    -swap 512 \
#    -storage local-lvm \
    -rootfs volume=local-lvm:8 \
#    -password \
    -net0 name=eth0,bridge=vmbr1,gw=10.20.30.1,ip=$IPv4,type=veth  &&\
pct start $ID &&\
sleep 10 &&\

pct exec $ID -- bash -c "apt update -y &&\
    apt install -y openssh-server &&\
    systemctl start sshd &&\
    groupadd sysadmin &&\
    useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin &&\
    sh -c 'echo "sysadmin:Netlab!23" | chpasswd'"


# --------------------------------SETTINGS FOR EXERCISES---------------------------------------



# --------------------------------SETTINGS FOR EXERCISES---------------------------------------