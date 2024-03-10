#!/bin/bash
# This script prepare container debian:12 for exercise
# https://pve.proxmox.com/pve-docs/pct.1.html

# Test internet connection
function check_internet() {
  printf "Checking if you are online...\n"
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo -e '\e[0;92mOnline. Continuing.\e[0m'
  else
    echo -e '\e[0;91mOffline. Go connect to the internet then run the script again.\e[0m'
  fi
}

check_internet

# EXAM NAME
REPO="tests"
EXAM="template_excercise_ubuntu_autologin"

# Container Settings
ID="102"
HOSTNAME="ubuntu"
IPv4="10.20.30.102"
TEMPLATE="ubuntu-22.04-standard_22.04-1_amd64.tar.zst"

# Create Container
echo -e '\e[0;92m\nDeploying container '$HOSTNAME' ...\e[0m'
sudo pct create "$ID" /var/lib/vz/template/cache/$TEMPLATE \
    -arch amd64 \
    -ostype ubuntu \
    -hostname $HOSTNAME \
    -features nesting=1 \
    -unprivileged 1 \
    -rootfs volume=local-lvm:8 \
    -cores 1 \
    -memory 512 \
    -swap 512 \
    -net0 name=eth0,bridge=vmbr1,gw=10.20.30.1,ip=$IPv4/24,firewall=1 \
    -nameserver 1.1.1.1 \
    -ssh-public-keys $HOME/.ssh/server_key.pub &&\

# Start Container
sudo pct start $ID &&\
sleep 10 &&\

# Add user to container
sudo pct exec $ID -- groupadd sysadmin
sudo pct exec $ID -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
sudo pct exec $ID -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'
sudo pct exec $ID -- usermod -aG users sysadmin
# Enable "ping" for unpriviledge user
sudo pct exec $ID -- setcap cap_net_raw+p /bin/ping
# SSH Authorized Key
sudo pct exec $ID -- mkdir /home/sysadmin/.ssh/
sudo pct exec $ID -- chown sysadmin:sysadmin /home/sysadmin/.ssh/ 
sudo pct exec $ID -- cp /root/.ssh/authorized_keys /home/sysadmin/.ssh/
sudo pct exec $ID -- chown sysadmin:sysadmin /home/sysadmin/.ssh/authorized_keys

# Import files - neovereno
sudo pct set $ID -mp0 ~/$REPO/$EXAM/files/,mp=/shared
sudo pct push $ID ~/$REPO/$EXAM/files/* /home/sysadmin/ --user sysadmin

# --------------------------------SETTINGS FOR EXERCISES---------------------------------------

# sudo pct exec $ID -- apt update -y &&\

# --------------------------------SETTINGS FOR EXERCISES---------------------------------------

# Edit /etc/hosts
sudo sh -c 'echo "'$IPv4' '$HOSTNAME' '$HOSTNAME'.eduxo.lab" >> /etc/hosts'

ssh -o "StrictHostKeyChecking no" sysadmin@$HOSTNAME.eduxo.lab