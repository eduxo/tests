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

# Container Settings
ID="101"
HOSTNAME="debian"
IPv4="10.20.30.101"
TEMPLATE="debian-12-standard_12.2-1_amd64.tar.zst"

# Create Container
echo -e '\e[0;92m\nDeploying container '$HOSTNAME' ...\e[0m'
sudo pct create "$ID" /var/lib/vz/template/cache/$TEMPLATE \
    -arch amd64 \
    -ostype debian \
    -hostname $HOSTNAME \
    -features nesting=1 \
    -unprivileged 1 \
    -rootfs volume=local-lvm:8 \
    -cores 1 \
    -memory 512 \
    -swap 512 \
    -net0 name=eth0,bridge=vmbr1,gw=10.20.30.1,ip=$IPv4/24,firewall=1 \
    -nameserver 1.1.1.1 &&\
#   -ssh-public-keys <filepath> \
#             Setup public SSH keys (one key per line, OpenSSH format).
#   -password \
#             Sets root password inside container.

# Start Container
sudo pct start $ID &&\
sleep 10 &&\

# Install sudo 
sudo pct exec $ID -- apt update -y
sudo pct exec $ID -- apt install sudo -y

# Add user to container
sudo pct exec $ID -- groupadd sysadmin
sudo pct exec $ID -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
sudo pct exec $ID -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'
sudo pct exec $ID -- usermod -aG users sysadmin
sudo pct exec $ID -- setcap cap_net_raw+p /bin/ping

# --------------------------------SETTINGS FOR EXERCISES---------------------------------------



# --------------------------------SETTINGS FOR EXERCISES---------------------------------------

# Edit /etc/hosts
sudo sh -c 'echo "'$IPv4' '$HOSTNAME' '$HOSTNAME'.eduxo.lab" >> /etc/hosts'

echo -e '\n\e[0;92mContejner '$HOSTNAME' is ready.\e[0m

Container-name: '$HOSTNAME'
Domain-name: '$HOSTNAME'.eduxo.lab
IPv4 adresa: '$IPv4'

Login: sysadmin
Password: Netlab!23

Website: http://'$HOSTNAME'.eduxo.lab/\n'