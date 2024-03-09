#!/bin/bash

# TESTOVANO:
# Ubuntu 22.04

# ZDROJE:
# https://ubuntu.com/server/docs/containers-lxd

# Stop containers
echo -e '\n\e[0;92mZastavuji kontejnery...\e[0m'
lxc stop servera
lxc stop serverb
sleep 2

# Delete containers
echo -e '\e[0;92mMazu kontejnery...\e[0m'
lxc delete servera
lxc delete serverb
sleep 2

echo -e '\n\e[0;92mHOTOVO\e[0m'
