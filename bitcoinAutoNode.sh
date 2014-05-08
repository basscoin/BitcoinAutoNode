#!/bin/bash
echo "########### The server will reboot when the script is complete"
echo "########### Changing to home dir"
cd ~
echo "########### Change your root password!"
passwd
echo "########### Firewall rules; allow 22,8333"
ufw allow 22/tcp
ufw allow 8333/tcp
ufw --force enable
echo "########### Updating Ubuntu"
apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install software-properties-common python-software-properties -y
echo "########### Creating Swap"
dd if=/dev/zero of=/swapfile bs=1M count=1024 ; mkswap /swapfile ; swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
echo "########### Adding ppa:cwayne18/doge and installing dogecoind"
add-apt-repository -y ppa:cwayne18/doge
apt-get update -y
mkdir ~/.dogecoin/
apt-get install dogecoind -y
echo "########### Creating config"
config=".dogecoin/dogecoin.conf"
touch $config
echo "server=1" > $config
echo "daemon=1" >> $config
echo "connections=40" >> $config
randUser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
echo "rpcuser=$randUser" >> $config
echo "rpcpassword=$randPass" >> $config
echo "########### Setting up autostart (cron)"
crontab -l > tempcron
echo "@reboot dogecoind -daemon" >> tempcron
crontab tempcron
rm tempcron
reboot
