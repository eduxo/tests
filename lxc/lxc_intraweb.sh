#!/bin/bash
# This script prepare container ubuntu:lts for exercise IntraWeb
# Tested on Ubuntu Server 22.04

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


# Container 
NAME="intraweb"
IP="10.20.30.101"

# Create container
echo -e '\e[0;92m\nDeploying container '$NAME' ...\e[0m'
lxc launch ubuntu:lts $NAME

# Add user to container
lxc exec $NAME -- groupadd sysadmin
lxc exec $NAME -- useradd -rm -d /home/sysadmin -s /bin/bash -g sysadmin -G sudo -u 1000 sysadmin
lxc exec $NAME -- sh -c 'echo "sysadmin:Netlab!23" | chpasswd'

# Enable SSH Password Authentication
lxc exec $NAME -- sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
lxc exec $NAME -- systemctl restart sshd

# Add static IP adress
lxc stop $NAME
lxc network attach vmbr1 $NAME eth0 eth0
lxc config device set $NAME eth0 ipv4.address $IP
lxc start $NAME
sleep 3


# --------------------------------SETTINGS FOR EXERCISES---------------------------------------

# Install NGINX
lxc exec $NAME -- apt-get update
lxc exec $NAME -- apt-get install nginx -y

lxc exec $NAME -- sh -c 'echo "
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
        <li><a href="http://intraweb.eduxo.lab/jnovak">Jan Novak</a></li>
        <li><a href="http://intraweb.eduxo.lab/jhrabal">Jakub Hrabal</a></li>
        <li><a href="http://intraweb.eduxo.lab/tsimakova">Tereza Simakova</a></li>
        <li><a href="http://intraweb.eduxo.lab/mmrazek">Martin Mrazek</a></li>
        <li><a href="http://intraweb.eduxo.lab/jkuliskova">Jitka Kuliskova</a></li>
       </ul>
    </p>
  </body>
</html>
" > /var/www/html/index.html'

# --------------------------------SETTINGS FOR EXERCISES---------------------------------------


# Edit /etc/hosts
# echo -e '\e[0;92mPro nastaveni domain-name je nutne opravneni:\e[0m'
sudo sh -c 'echo "'$IP'        '$NAME'.eduxo.lab  '$NAME'
" >> /etc/hosts'


echo -e '\n\e[0;92mContejner '$NAME' is ready.\e[0m

Container-name: '$NAME'
Domain-name: '$NAME'.eduxo.lab
IPv4 adresa: '$IP'

Login: sysadmin
Password: Netlab!23

Website: http://intraweb.eduxo.lab/\n'
