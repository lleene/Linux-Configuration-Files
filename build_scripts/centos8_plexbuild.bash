#!/bin/bash

dnf clean all
dnf update -y

## Try to install preferred package list (Some packages have not valid)
# subscription-manager repos --enable=rhel-8-server-extras-rpms
# subscription-manager repos --enable=rhel-8-server-optional-rpms
# dnf install -y libcxx libcxxabi cmake w3m libnsl ncdu clang llvm npm
# dnf install -y libc6-dev gcc g++ make build-essential certbot epel-release fuse ntfs-3g

dnf install -y fuse cmake libnsl clang llvm npm epel-release make gcc cmake ncdu
dnf install -y cockpit cockpit-dashboard
firewall-cmd --add-port=9090/tcp
firewall-cmd --permanent --add-port=9090/tcp
systemctl enable cockpit.socket
systemctl start cockpit.socket

# ssh-keygen
# default: /root/.ssh/id_rsa
# passwd: root_passwd

dnf install -y nginx openssl chrony
wget https://downloads.plex.tv/plex-media-server-new/1.17.0.1709-982421575/redhat/plexmediaserver-1.17.0.1709-982421575.x86_64.rpm
dnf local install plexmediaserver-1.17.0.1709-982421575.x86_64.rpm
systemctl enable plexmediaserver.service
systemctl start plexmediaserver.service
firewall-cmd --add-port=32400/tcp
firewall-cmd --permanent --add-port=32400/tcp
firewall-cmd --permanent --zone=public --add-service=plex

# Load default services
systemctl enable chrony
systemctl start chrony
systemctl enable nginx
systemctl start nginx

firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --reload

exit

## ADDED TO FSTAB for automated mount
mkdir /mnt/backup_root
mkdir /mnt/backup_home
/dev/centos00/home /mnt/backup_home        auto     ro,defaults        0 0
/dev/centos00/root /mnt/backup_root        auto     ro,defaults        0 0

# Prepare to mount hachiwari over nfs (must setup nfs and shared folder penny-nfs before this step)
firewall-cmd --permanent --zone=public --add-service=nfs
## ADDED TO FSTAB for automated mount  ( ? specify port number here )
192.168.2.120:/volume1/penny-nfs /mnt/hachiwari auto defaults 0 0

## Then run to mount now
mount $NFS_SYNOLOGY_IP:/volume1/penny-nfs /mnt/hachiwari

##
## Finish up sys config
##

# /etc/ssh/sshd_config
# PermitRootLogin no
# /etc/pam.d/cockpit
# auth requisite pam_succeed_if.so uid >= 1000

##
## OTHERS
##

# get graphical utility support and some other stuff
dnf install ncdu gedit xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps python3

## Run installer for anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh
sudo bash Anaconda3-4.1.1-Linux-x86_64.sh
# Do you approve the license terms? [yes|no] yes
# [/root/anaconda3] >>> /opt/anaconda3
# to PATH in your /root/.bashrc ? [yes|no] no

## Setup ENV to load anaconda
sudo cp /etc/profile /etc/profile_backup
echo 'export PATH=/opt/anaconda3/bin:$PATH' | sudo tee -a /etc/profile
source /etc/profile
echo $PATH

## Config jupyter in penny home directory
jupyter notebook --generate-config
python
# >>> from notebook.auth import passwd
# >>> passwd()
# Enter password:<your-password>
# Verify password:<your-password>
# 'sha1:<your-sha1-hash-value>'
# >>> Ctrl+Z

generate sha1 hash key and save it in .keys dir
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout jkey.key -out jcert.pem

c.NotebookApp.certfile = '/home/penny/.keys/jcert.pem'
c.NotebookApp.keyfile = '/home/penny/.keys/jkey.key'
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.password = 'sha1:<your-sha1-hash-value>'
c.NotebookApp.port = 7088

sudo firewall-cmd --zone=public --add-port=7088/tcp --permanent
sudo systemctl restart firewalld.service

# as root prepare systemd service for jupyter

[Unit]
Description=Jupyter Notebook
Documentation=
Wants=network.target
After=network.target

[Service]
Type=simple
User=penny
Group=penny
Nice=5
WorkingDirectory=/home/penny/jupyter/
ExecStart=/bin/bash -c '/opt/anaconda3/bin/jupyter-notebook --config=/home/penny/.jupyter/jupyter_notebook_config.py'
ProtectSystem=full
NoNewPrivileges=true
PrivateTmp=true
InaccessibleDirectories=/root /sys

[Install]
WantedBy=multi-user.target

# setup happypanda runs on 7008
# add user uid:happypanda pwd:pandax1337
# login as happypanda to continue

wget https://github.com/happypandax/happypandax/releases/download/v0.11.2/happypandax0.11.2.linux.tar.gz
tar -xzf happypandax0.11.2.linux.tar.gz
./happypandax --gen-config

firewall-cmd --add-port=7008/tcp
firewall-cmd --permanent --add-port=7008/tcp

# as root prepare happypanda systemd service with parameters as below:

[Unit]
Description=HappyPanda Server
Documentation=
Wants=network.target
After=network.target

[Service]
Type=simple
User=happypanda
Group=happypanda
Nice=5
ExecStart=/bin/bash -c '/home/happypanda/happypandax/happypandax'
WorkingDirectory=/home/happypanda/

ProtectSystem=full
NoNewPrivileges=true
PrivateTmp=true
InaccessibleDirectories=/root /sys 


[Install]
WantedBy=multi-user.target

## Update services
systemctl deamon-reload
