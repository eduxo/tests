#!/bin/bash
# This script prepare container debian:12 for exercise
# https://pve.proxmox.com/pve-docs/pct.1.html

# Container Settings
ID="101"
HOSTNAME="101"
IPv4="10.20.30.101/24"

# Create Container
sudo pct create "$ID" /var/lib/vz/template/cache/debian-12-standard_12.2-1_amd64.tar.zst \
    -arch amd64 \
    -ostype debian \
    -hostname $HOSTNAME \
    -features nesting=1 \
    -unprivileged 1 \
    -password \
    -rootfs volume=local-lvm:8 \
    -cores 1 \
    -memory 512 \
    -swap 512 \
    -net0 name=eth0,bridge=vmbr1,gw=10.20.30.1,ip=$IPv4,firewall=1 \
    -nameserver 1.1.1.1 &&\
#   -ssh-public-keys <filepath> \
#             Setup public SSH keys (one key per line, OpenSSH format).
#   -password \
#             Sets root password inside container.

# Start Container
sudo pct start $ID &&\
sleep 10 &&\

# Enable SSH Password Authentication
#sudo pct exec $ID -- sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
#sudo pct exec $ID -- systemctl restart sshd

# Install sudo 
sudo pct exec $ID -- apt update -y
sudo pct exec $ID -- apt install sudo -y

# Add user to container
sudo pct exec $ID -- groupadd sysadmin
sudo pct exec $ID -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
sudo pct exec $ID -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'
sudo pct exec $ID -- usermod -aG users sysadmin


# --------------------------------SETTINGS FOR EXERCISES---------------------------------------

# sudo pct exec $ID -- apt update -y

# sudo pct exec $ID -- apt-get upgrade -y
# sudo pct exec $ID -- apt-get autoremove -y
# sudo pct reboot $ID

# pct resize <id> rootfs <storage(ex: +4G)>
# pct exec <id> -- mkdir -p /root/.ssh/
# pct push <id> ~/.ssh/authorized_keys /root/.ssh/authorized_keys

# --------------------------------SETTINGS FOR EXERCISES---------------------------------------

# Edit /etc/hosts
# echo -e '\e[0;92mPro nastaveni domain-name je nutne opravneni:\e[0m'
# sudo sh -c 'echo "'$IPv4' '$HOSTNAME'.eduxo.lab '$HOSTNAME'
# " >> /etc/hosts'