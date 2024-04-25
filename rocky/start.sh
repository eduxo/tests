#!/bin/bash
# This script prepare container rocky:9 for exercise
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

# Container Settings
ID="101"
HOSTNAME="rocky"
IPv4="10.20.30.101"
TEMPLATE="rockylinux-9-default_20221109_amd64.tar.xz"

if [ ! -f "/var/lib/vz/template/cache/$TEMPLATE" ]; then
  sudo pveam update
  sudo pveam download local $TEMPLATE
fi

# Create Container
echo -e '\e[0;92m\nDeploying container '$HOSTNAME' ...\e[0m\n'
sudo pct create "$ID" /var/lib/vz/template/cache/$TEMPLATE \
    --arch amd64 \
    --ostype centos \
    --hostname $HOSTNAME \
    --features nesting=1 \
    --unprivileged 0 \
    --rootfs volume=local-lvm:8 \
    --cores 1 \
    --memory 512 \
    --swap 512 \
    --net0 name=eth0,bridge=vmbr1,gw=10.20.30.1,ip=$IPv4/24,firewall=1 \
    --nameserver 1.1.1.1 &&\
#   --onboot 1 \
#   -ssh-public-keys <filepath> \
#             Setup public SSH keys (one key per line, OpenSSH format).
#   -password \
#             Sets root password inside container.

# Start Container
sudo pct start $ID &&\
echo -e '\e[0;92m\nWait about 30s for completion!\e[0m\n'
sleep 10 &&\

# Install sudo 
#sudo pct exec $ID -- dnf update -y
sudo pct exec $ID -- dnf install openssh-server nano -y
sudo pct exec $ID -- systemctl restart sshd

# Add user to container
sudo pct exec $ID -- useradd sysadmin
sudo pct exec $ID -- usermod -a -G wheel sysadmin
sudo pct exec $ID -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'
sudo pct exec $ID -- setcap cap_net_raw+p /bin/ping

# --------------------------------SETTINGS FOR EXERCISES---------------------------------------

# EXAM NAME
REPO="test"
EXAM="rocky"

# Shared folder
# Container must be priviledge => --unprivileged 0 \
sudo pct shutdown $ID
sudo pct set $ID -mp0 ~/$REPO/$EXAM/files/,mp=/home/sysadmin/shared
sudo pct start $ID
sleep 10

# Import One File
sudo pct push $ID ~/$REPO/$EXAM/files/file.txt /home/sysadmin/files \
    --user sysadmin \
    --group sysadmin


# sudo pct exec $ID -- dnf update -y &&\

# --------------------------------SETTINGS FOR EXERCISES---------------------------------------

# Edit /etc/hosts
sudo sh -c 'echo "'$IPv4' '$HOSTNAME' '$HOSTNAME'.eduxo.lab" >> /etc/hosts'

echo -e '\n\e[0;92mContejner '$HOSTNAME' is ready.\e[0m

Container-name: '$HOSTNAME'
Domain-name: '$HOSTNAME'.eduxo.lab
IPv4 address: '$IPv4'

Login: sysadmin
Password: Netlab!23

Website: http://'$HOSTNAME'.eduxo.lab/\n'