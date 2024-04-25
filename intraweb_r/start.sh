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
ID="120"
HOSTNAME="intraweb"
IPv4="10.20.30.120"
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
    --unprivileged 1 \
    --onboot 1 \
    --rootfs volume=local-lvm:8 \
    --cores 1 \
    --memory 512 \
    --swap 512 \
    --net0 name=eth0,bridge=vmbr1,gw=10.20.30.1,ip=$IPv4/24,firewall=1 \
    --nameserver 1.1.1.1 &&\

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

# Install NGINX
sudo pct exec $ID -- dnf update -y
sudo pct exec $ID -- dnf install nginx -y

sudo pct exec $ID -- sh -c 'echo "
<!doctype html>
<html>
  <head>
    <title>IntraWeb</title>
  </head>
  <body>
    <h1>IntraWeb</h1>
    <p>This is the main website of the <strong><a href="http://intraweb.eduxo.lab/">http://intraweb.eduxo.lab</a></strong> server.</p>
    <p>
      <ul>
        <li><a href="http://intraweb.eduxo.lab/1rocnik">1. rocnik</a></li>
        <li><a href="http://intraweb.eduxo.lab/2rocnik">2. rocnik</a></li>
        <li><a href="http://intraweb.eduxo.lab/3rocnik">3. rocnik</a></li>
        <li><a href="http://intraweb.eduxo.lab/4rocnik">4. rocnik</a></li>
        <li><a href="http://intraweb.eduxo.lab/maturita">maturita</a></li>
       </ul>
    </p>
  </body>
</html>
" > /var/www/html/index.html'

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