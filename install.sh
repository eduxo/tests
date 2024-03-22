#!/bin/bash
# This script prepare VM eduxo VPS-LabX
# Tested on Proxmox VE


# Test internet connection
function check_internet() {
  printf "Checking if you are online...\n"
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo -e '\e[0;92m\nOnline. Continuing.\e[0m'
  else
    echo -e '\e[0;91m\nOffline. Go connect to the internet then run the script again.\e[0m'
  fi
}
check_internet


echo -e '\e[1;92m\nStart installation.\e[0m'
apt-get update -y
apt-get dist-upgrade -y

sh -c 'echo "iface eth0 inet manual

auto vmbr0
iface vmbr0 inet dhcp
        bridge-ports none
        bridge-stp off
        bridge-fd 0
	bridge-maxwait 0

auto vmbr1
iface vmbr1 inet static
        address	10.20.30.1/24
        bridge-ports none
        bridge-stp off
        bridge-fd 0
	bridge-maxwait 3

        post-up   echo 1 > /proc/sys/net/ipv4/ip_forward
        post-up   iptables -t nat -A POSTROUTING -s '10.20.30.0/24' -o vmbr0 -j MASQUERADE
        post-down iptables -t nat -D POSTROUTING -s '10.20.30.0/24' -o vmbr0 -j MASQUERADE
" > /etc/hosts'

clear

# New user sysadmin
echo -e '\e[0;92m\nCreate new user: sysadmin\e[0m'
adduser sysadmin

clear

# Install upgrades and basic programs
echo -e '\e[0;92m\nInstalling basic programs, wait for completion.\e[0m'
apt-get install gnome -y
apt-get install sudo -y
usermod -aG sudo sysadmin

# Install PackerTracer (CiscoPacketTracer_820_Ubuntu_64bit.deb)
wget --no-check-certificate 'https://drive.google.com/uc?id=1vj_lEcH3KKmnsWsVCNaAa-0endJOr6Aq&confirm=no_antivirus&export=download' -O 'CiscoPacketTracer_821_Ubuntu_64bit.deb'
echo "PacketTracer PacketTracer_821_amd64/accept-eula select true" |  debconf-set-selections
 DEBIAN_FRONTEND=noninteractive apt-get install -y ./CiscoPacketTracer_821_Ubuntu_64bit.deb
rm CiscoPacketTracer_821_Ubuntu_64bit.deb

# Install Wireshark
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
apt-get install -y wireshark
adduser sysadmin wireshark

echo -e '\e[0;92m\nInstallation basic programs is completed.\e[0m'
sleep 3
clear


# GIT clone
#cd $HOME/ && git clone https://github.com/eduxo/eduxo.git

# Update GIT eduxo on login
#sh -c 'echo "
# eduxo
#cd $HOME/eduxo/ && git pull > /dev/null 2>&1
#" >> $HOME/.profile'

# Update GIT eduxo on login via rdp
#sh -c 'echo "

# eduxo
#cd $HOME/eduxo/ && git pull > /dev/null 2>&1
#" >> /etc/xrdp/startwm.sh'


# Install Docker (https://docs.docker.com/engine/install/debian/)
echo -e '\e[0;92m\nInstalling Docker, wait for completion.\e[0m'
sleep 2

# Uninstall old versions
# sudo apt-get remove docker docker-engine docker.io containerd runc

# Add Docker's official GPG key:
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
     
# Install Docker Engine
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
     
# Add your user to the docker group
usermod -aG docker sysadmin
     
# Install Portainer
docker pull portainer/portainer-ce:latest
docker run -d \
--name portainer \
--restart always \
--publish 9443:9443 \
--volume /var/run/docker.sock:/var/run/docker.sock \
--volume portainer_data:/data portainer/portainer-ce:latest

echo -e '\e[0;92m\nInstallation Docker is completed.\e[0m'
sleep 3
clear

# clean & restart
echo -e '\e[0;92m\nCleaning ...\e[0m'
sleep 2
apt-get autoremove -y
history -c
unset DEBIAN_FRONTEND

echo -e '\n\e[1;92m\nInstallation is completed, restarting PC!\e[0m'
sleep 3
reboot


# Post-autoinstall
# ================
# Set Background
# Set Homepage (www.eduxo.cz)
# Set GNS3
# Menu Education (mozo)
# Associate files for GNS3 portable projects