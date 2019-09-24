#!/bin/bash

yum clean all
yum update -y

subscription-manager repos --enable=rhel-8-server-extras-rpms
subscription-manager repos --enable=rhel-8-server-optional-rpms
yum install -y cockpit cockpit-dashboard libcxx libcxxabi cmake w3m libnsl ncdu clang llvm npm 
yum install -y libc6-dev gcc g++ make build-essential certbot epel-release fuse ntfs-3g 
firewall-cmd --add-port=9090/tcp
firewall-cmd --permanent --add-port=9090/tcp
systemctl enable cockpit.socket
systemctl start cockpit.socket

# ssh-keygen 
# default: /root/.ssh/id_rsa
# passwd: root_passwd

yum install -y nginx openssl
wget https://downloads.plex.tv/plex-media-server-new/1.17.0.1709-982421575/redhat/plexmediaserver-1.17.0.1709-982421575.x86_64.rpm
yum local install plexmediaserver-1.17.0.1709-982421575.x86_64.rpm
systemctl enable plexmediaserver.service
systemctl start plexmediaserver.service
firewall-cmd --add-port=32400/tcp
firewall-cmd --permanent --add-port=32400/tcp

systemctl enable nginx
systemctl start nginx
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --reload

# Prevent Root login on SSH / Cockpit

reboot now  

# Stop here before optionals
exit 

######
###### OTHER
######

## HAPPYPANDAX
wget https://github.com/happypandax/happypandax/releases/download/v0.11.2/happypandax0.11.2.linux.tar.gz
tar -xzf happypandax0.11.2.linux.tar.gz
./happypandax --gen-config

## ADDED TO FSTAB
mkdir /mnt/backup_root
mkdir /mnt/backup_home
/dev/centos00/home /mnt/backup_home        auto     ro,defaults        0 0
/dev/centos00/root /mnt/backup_root        auto     ro,defaults        0 0
