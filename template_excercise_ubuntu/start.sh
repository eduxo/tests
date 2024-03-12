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

# ------------------------------------ SERVER A -------------------------------------------
# Container Server A Settings
ID="101"
HOSTNAME="serverA"
IPv4="10.20.30.101"
TEMPLATE="ubuntu-22.04-standard_22.04-1_amd64.tar.zst"

# Container Server A
echo -e '\e[0;92m\nDeploying container '$HOSTNAME' ...\e[0m'
sudo pct create "$ID" /var/lib/vz/template/cache/$TEMPLATE \
    -arch amd64 \
    -ostype ubuntu \
    -hostname $HOSTNAME \
    -features nesting=1 \
    -unprivileged 0 \
    -rootfs volume=local-lvm:8 \
    -cores 1 \
    -memory 512 \
    -swap 512 \
    -net0 name=eth0,bridge=vmbr1,gw=10.20.30.1,ip=$IPv4/24,firewall=1 \
    -nameserver 1.1.1.1 &&\

# Start Container
sudo pct start $ID &&\
sleep 10 &&\

# Add user to container
sudo pct exec $ID -- groupadd sysadmin
sudo pct exec $ID -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
sudo pct exec $ID -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'
sudo pct exec $ID -- usermod -aG users sysadmin
sudo pct exec $ID -- setcap cap_net_raw+p /bin/ping

# --------------------------------SETTINGS FOR SERVER A---------------------------------------

# EXAM NAME
REPO="tests"
EXAM="template_excercise_ubuntu"

# Shared folder
# Container must be priviledge => --unprivileged 0 \
sudo pct shutdown $ID
sudo pct set $ID -mp0 ~/$REPO/$EXAM/servera_files/,mp=/home/sysadmin/shared
sudo pct start $ID

# Import One File
sudo pct push $ID ~/$REPO/$EXAM/servera_files/file.txt /home/sysadmin/files \
    --user sysadmin \
    --group sysadmin


# sudo pct exec $ID -- apt update -y &&\

# --------------------------------SETTINGS FOR SERVER A---------------------------------------

# Edit /etc/hosts
sudo sh -c 'echo "'$IPv4' '$HOSTNAME' '$HOSTNAME'.eduxo.lab" >> /etc/hosts'

echo -e '\n\e[0;92mContejner '$HOSTNAME' is ready.\e[0m
Container-name: '$HOSTNAME'
Domain-name: '$HOSTNAME'.eduxo.lab
IPv4 address: '$IPv4'

Login: sysadmin
Password: Netlab!23\n'


# ------------------------------------ SERVER B -------------------------------------------
# Container Server B Settings
ID="102"
HOSTNAME="serverB"
IPv4="10.20.30.102"
TEMPLATE="ubuntu-22.04-standard_22.04-1_amd64.tar.zst"

# Container Server B
echo -e '\e[0;92m\nDeploying container '$HOSTNAME' ...\e[0m'
sudo pct create "$ID" /var/lib/vz/template/cache/$TEMPLATE \
    -arch amd64 \
    -ostype ubuntu \
    -hostname $HOSTNAME \
    -features nesting=1 \
    -unprivileged 0 \
    -rootfs volume=local-lvm:8 \
    -cores 1 \
    -memory 512 \
    -swap 512 \
    -net0 name=eth0,bridge=vmbr1,gw=10.20.30.1,ip=$IPv4/24,firewall=1 \
    -nameserver 1.1.1.1 &&\

# Start Container
sudo pct start $ID &&\
sleep 10 &&\

# Add user to container
sudo pct exec $ID -- groupadd sysadmin
sudo pct exec $ID -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
sudo pct exec $ID -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'
sudo pct exec $ID -- usermod -aG users sysadmin
sudo pct exec $ID -- setcap cap_net_raw+p /bin/ping

# --------------------------------SETTINGS FOR SERVER B---------------------------------------

# EXAM NAME
REPO="tests"
EXAM="template_excercise_ubuntu"

# Shared folder
# Container must be priviledge => --unprivileged 0 \
sudo pct shutdown $ID
sudo pct set $ID -mp0 ~/$REPO/$EXAM/serverb_files/,mp=/home/sysadmin/shared
sudo pct start $ID

# Import One File
sudo pct push $ID ~/$REPO/$EXAM/serverb_files/file.txt /home/sysadmin/files \
    --user sysadmin \
    --group sysadmin


# sudo pct exec $ID -- apt update -y &&\

# --------------------------------SETTINGS FOR SERVER B---------------------------------------

# Edit /etc/hosts
sudo sh -c 'echo "'$IPv4' '$HOSTNAME' '$HOSTNAME'.eduxo.lab" >> /etc/hosts'

echo -e '\n\e[0;92mContejner '$HOSTNAME' is ready.\e[0m
Container-name: '$HOSTNAME'
Domain-name: '$HOSTNAME'.eduxo.lab
IPv4 address: '$IPv4'

Login: sysadmin
Password: Netlab!23\n'