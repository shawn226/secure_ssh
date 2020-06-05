#!/bin/bash

#Updating and installing ssh server
apt update && apt install openssh-server -y


###Config sshd_config###

#Disable password authentification
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

#Disable root logging
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

#Changing listen port
sed -i 's/#Port 22/Port 53120/' /etc/ssh/sshd_config

#Set max authentification tries
echo "MaxAuthTries 3" >> /etc/ssh/sshd_config

iptables -N SSHTRIES
iptables -A SSHTRIES -j LOG --log-prefix "Possible SSH attack! " --log-level 7
iptables -A SSHTRIES -j DROP

iptables -A INPUT -i eth0 -p tcp -m state --dport 53120 --state NEW -m recent --set
iptables -A INPUT -i eth0 -p tcp -m state --dport 53120 --state NEW -m recent --update --seconds 120 --hitcount 4 -j SSHATTACK

service sshd restart


