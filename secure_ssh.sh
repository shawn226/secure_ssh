#!/bin/bash

#Updating and installing ssh server
echo "[SecureApp] Initialization..."
sleep 1

apt update && apt install openssh-server -y


###Config sshd_config###

echo "[SecureApp] Starting ssh configuration..."

#Disable password authentification
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

#Disable root logging
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

#Changing listen port
sed -i 's/#Port 22/Port 53120/' /etc/ssh/sshd_config

#Enable ssh Pub key authentification
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

echo 'AuthorizedKeysFile /home/$(ls /home)/.ssh/authorized_keys' >> /etc/ssh/sshd_config


#Set max authentification tries
echo "MaxAuthTries 3" >> /etc/ssh/sshd_config

iptables -N SSHMAXTRIES
iptables -A SSHMAXTRIES -j LOG --log-prefix "Possible SSH attack! " --log-level 7
iptables -A SSHMAXTRIES -j DROP

iptables -A INPUT -i eth0 -p tcp -m state --dport 53120 --state NEW -m recent --set
iptables -A INPUT -i eth0 -p tcp -m state --dport 53120 --state NEW -m recent --update --seconds 120 --hitcount 4 -j SSHMAXTRIES

service sshd restart

echo "[SecureApp] End of ssh configuration !"


###Config Clamav anti-virus###

echo "[SecureApp] Starting Clamav configuration..."


# Install prerequisites and dependencies

apt-get install build-essential -y # developer tools

apt-get install openssl libssl-dev libcurl4-openssl-dev zlib1g-dev libpng-dev libxml2-dev libjson-c-dev libbz2-dev libpcre3-dev ncurses-dev -y # library dependencies

apt-get install valgrind check check-devel -y # unit testing dependencies


# Download Clamav 

cd

wget https://www.clamav.net/downloads/production/clamav-0.102.3.tar.gz

tar xzf clamav-0.102.3.tar.gz

cd clamav-0.102.3


# Install config files Clamav
./configure -–sysconfdir=/etc

# Compilation
make -j2

# Checking first unit test
make check

# Install 
make install


# Setting up for the first time

cp /etc/freshclam.conf.sample /etc/freshclam.conf # copy sample file to create a freshclam config







