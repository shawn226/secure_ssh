#!/bin/bash

#Updating and installing ssh server
echo -e "\e[96m[SecureApp] Initialization..."
sleep 1

apt update && apt upgrade -y && apt install openssh-server -y


###Config sshd_config###
echo -e "\e[96m[SecureApp] Starting ssh configuration..."

#Disable password authentification
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

#Disable root logging
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

#Changing listen port
sed -i 's/#Port 22/Port 53120/' /etc/ssh/sshd_config

#Enable ssh Pub key authentification
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

echo 'AuthorizedKeysFile /home/backupclt/.ssh/authorized_keys' >> /etc/ssh/sshd_config

#Disable logging with empty password
sed -i 's/#PermitEmptyPassword no/PermitEmptyPassword no/' /etc/ssh/sshd_config

#Set max authentification tries
echo "MaxAuthTries 3" >> /etc/ssh/sshd_config

service sshd restart


#Fail2ban configuration
apt install fail2ban -y

systemctl enable fail2ban


echo -e "\e[92m[SecureApp] End of ssh configuration !"


###Config Clamav anti-virus###
echo -e "\e[96m[SecureApp] Starting Clamav Install..."

apt update && apt upgrade -y
apt-get install clamav clamav-daemon -y

echo -e "\e[92m[SecureApp] The installation is done!"


echo -e "\e[96m[SecureApp] Starting ClamAV configuration..."

systemctl stop clamav-freshclam
systemctl stop clamav-daemon.service

service clamav-daemon restart
#Refreshing the ClamAV database
freshclam

# initialize the ClamAV daemon.
systemctl start clamav-daemon
systemctl start clamav-freshclam

echo -e "\e[92m[SecureApp] End of ClamAV configuration !"


###Config apparmor
echo -e "\e[96m[SecureApp] Starting Clamav Install..."
apt install apparmor-utils apparmor-profiles -y

echo -e "\e[92m[SecureApp] The installation is done!"

#start profiles in complain mode
aa-complain /etc/apparmor.d/*

echo -e "\e[0"



