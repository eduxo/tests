#!/bin/bash
# This script prepare container debian:12 for exercise

ID="101"
HOSTNAME="101"
IPv4="10.20.30.101/24"

sudo pct create "$ID" /var/lib/vz/template/cache/debian-12-standard_12.2-1_amd64.tar.zst \
    -arch amd64 \
    -ostype debian \
    -hostname $HOSTNAME \
    -cores 1 \
    -memory 512 \
    -swap 512 \
    -password heslo \
    -rootfs volume=local-lvm:8 \
    -net0 name=eth0,bridge=vmbr1,gw=10.20.30.1,ip=$IPv4,type=veth  &&\
sudo pct start $ID &&\
sleep 10 &&\

sudo pct exec $ID -- apt update -y
sudo pct exec $ID -- groupadd sysadmin
sudo pct exec $ID -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo sysadmin &&\
sudo pct exec $ID -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'


# --------------------------------SETTINGS FOR EXERCISES---------------------------------------

# pct resize <id> rootfs <storage(ex: +4G)>
# pct exec <id> -- mkdir -p /root/.ssh/
# pct push <id> ~/.ssh/authorized_keys /root/.ssh/authorized_keys
# -ssh-public-keys <filepath>
#             Setup public SSH keys (one key per line, OpenSSH format).

# --------------------------------SETTINGS FOR EXERCISES---------------------------------------