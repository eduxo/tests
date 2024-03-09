pct create 101 /var/lib/vz/template/cache/debian-12-standard_12.2-1_amd64.tar.zst \
    -arch amd64 \
    -ostype debian \
    -hostname test \
    -cores 1 \
    -memory 512 \
    -swap 512 \
    -storage local-lvm \
    -password \
    -net0 name=eth0,bridge=vmbr1,gw=10.20.30.1,ip=10.20.30.100,type=veth  &&\
pct start 101 &&\
sleep 10 &&\
#pct resize <id> rootfs <storage(ex: +4G)> &&\
pct exec 101 -- bash -c "apt update -y &&\
    apt install -y openssh-server &&\
    systemctl start sshd &&\
    useradd -mU sysadmin &&\
    echo "Netlab!23" | passwd --stdin sysadmin"