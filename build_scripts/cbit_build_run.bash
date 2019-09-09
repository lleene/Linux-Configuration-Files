#!/bin/bash
# Configuration Script for CentOS 7.4 CBIT Cadence Minimum Install BUILD
# EDITED BY LIEUWE LEENE on 5/1/18

logname=yum.install.`date "+%F"`.log

# Install base groups
echo "Preparing to install packages... 1/4"
yum -y groupinstall "GNOME Desktop" "Development Tools" "Graphical Administration Tools" > $logname
# Include
echo "Preparing to install packages... 2/4"
yum -y install epel-release >> $logname

# Install cadence dependencies
echo "Preparing to install packages... 3/4"
yum -y install  pciutils kernel-devel kernel-headers libXp glibc-devel.x86_64 glibc-devel.i686 gcc gdbm elfutils elfutils-libelf libXtst p7zip compat-libtermcap wget csh xorg-x11-fonts* ksh xterm libcxx glibc.i686 openssl098e-0.9.8e-29.el7.centos.3 mesa-libGLU-9.0.0-4.el7 redhat-lsb-core libXp.i686 motif.x86_64 motif.i686 redhat-lsb.x86_64 redhat-lsb.i686 libXScrnSaver >> $logname

# Install sysadmin tools
echo "Preparing to install packages... 4/4"
yum -y install logwatch fail2ban >> $logname

# Show any errors / warnings 
grep grep (error|warning|fail) $logname

read -n 1 -s -r -p "Press any key to continue build configuration..."

# Set email aliases
echo "root:michal.maslik12@imperial.ac.uk,l.leene@imperial.ac.uk" >> /etc/aliases
sed "s/.*SMART_HOST.*/define(\`SMART_HOST\', \`smarthost.cc.ic.ac.uk\')/" /etc/mail/sendmail.mc > /etc/mail/sendmail.mc
/etc/mail/make

# No root access over ssh
sed "s_PermitRootLogin yes_PermitRootLogin no_" /etc/ssh/sshd_config > /etc/ssh/sshd_config

# Add cdsadmin user
adduser -u 2003 cdsadmin

# Prepare CBIT NFS directories
mkdir /ibe
mkdir /ibe/users
mkdir /ibe/local
mkdir /ibe/shares

# Prepare CBIT CDN directories
rm -rf /usr/local/bin
ln -s /ibe/local/bin /usr/local/.
ln -s /ibe/local/cadence/kits /usr/local/cadence/.
mkdir /usr/local/mentor 
mkdir /usr/local/cadence
chown cdsadmin:cdsadmin /usr/local/cadence /usr/local/mentor

echo "# Created by CBIT_BUILD.run script on" `date` >> /etc/fstab
echo "ib-hermes:/volume1/users   /ibe/users              nfs     defaults        0 0" >> /etc/fstab
echo "ib-hermes:/volume1/local   /ibe/local              nfs     defaults        0 0" >> /etc/fstab

# IF mount is availble
mount /ibe/users
ln -s /ibe/local/bin/server_logs/get_updates.cron /etc/cron.monthly/.
ln -s /ibe/local/bin/server_logs/get_serverstat.cron /etc/cron.hourly/.
ln -s /ibe/local/bin/server_logs/pid_mailer.cron /etc/cron.daily/.

# Configure weekly logwatch updates
echo "Range = between -7 days and -1 days" >> /etc/logwatch/conf/logwatch.conf
mv /etc/cron.daily/0logwatch /etc/cron.weekly/.

# Configure LDAP authentication
AUTHSERVERS=icads-krb5-1.ic.ac.uk:88,icads-krb5-2.ic.ac.uk:88,icads-krb5-3.ic.ac.uk:88,icads-krb5-4.ic.ac.uk:88,icads-krb5-5.ic.ac.uk:88
authconfig --useshadow --passalgo=sha512 --disablemd5 --disablefingerprint --enableldap --ldapserver unixldap.cc.ic.ac.uk --ldapbasedn ou=eecbit,dc=ic,dc=ac,dc=uk --enablekrb5 --krb5realm IC.AC.UK --krb5kdc $AUTHSERVERS --krb5adminserver $ADSERVERS  --enablecache --enablemkhomedir --updateall

# Configure firewall-cmd
firewall-cmd --zone=public --permanent --add-service={http,https,ssh,nfs}
firewall-cmd --permanent --zone=public --add-port=1-24/tcp
firewall-cmd --permanent --zone=public --add-port=1-24/udp
firewall-cmd --permanent --zone=public --add-source=`host ib-hermes.ib.ic.ac.uk | awk '{ print $4 }'`
firewall-cmd --permanent --zone=public --add-source=`host ib-poseidon.ib.ic.ac.uk | awk '{ print $4 }'`
firewall-cmd --permanent --zone=public --add-source=`host ib-zeus.ib.ic.ac.uk | awk '{ print $4 }'`
firewall-cmd --permanent --zone=public --add-source=`host ib-pegasus.ib.ic.ac.uk | awk '{ print $4 }'`
firewall-cmd --permanent --zone=public --add-source=`host ib-theia.ib.ic.ac.uk | awk '{ print $4 }'`
firewall-cmd --permanent --zone=public --add-source=`host ib-hyperion.ib.ic.ac.uk | awk '{ print $4 }'`
firewall-cmd --permanent --zone=public --add-source=`host ib-aphrodite.ib.ic.ac.uk | awk '{ print $4 }'`
firewall-cmd --permanent --zone=public --add-source=`host ib-artemis.ib.ic.ac.uk | awk '{ print $4 }'`
firewall-cmd --reload

read -n 1 -s -r -p "Press any key to restart services..."

service sssd restart
service sshd restart
service fail2ban restart
service sendmail restart

yum clean all
yum update -y

read -n 1 -s -r -p "Press any key to start Cadence Rsync..."

# Get 2019 Toolset from IB-HYPERION
rsync -avz -e ssh cdsadmin@ib-hyperion.ib.ic.ac.uk:/usr/local/cadence/JLS_18.10.000 :/usr/local/cadence/SPECTRE_18.10.077 :/usr/local/cadence/MDV_18.03.005 :/usr/local/cadence/IC_6.1.8.000 :/usr/local/cadence/MVS_18.10.000 :/usr/local/cadence/GENUS_18.10.000 :/usr/local/cadence/CONFRML_18.10.200 :/usr/local/cadence/VIPCAT_11.30.057_UVM :/usr/local/cadence/LIBERATE_18.10.293 :/usr/local/cadence/INNOVUS_18.10.000 :/usr/local/cadence/INDAGO_18.03.001 :/usr/local/cadence/MODUS_18.10.000 :/usr/local/cadence/EXT_18.12.000 :/usr/local/cadence/PVS_16.12.000 :/usr/local/cadence/INCISIVE_15.20.058 :/usr/local/cadence/ASSURA_04.15.115 :/usr/local/cadence/SSV_18.10.000 :/usr/local/cadence/SIG_18.00.000 :/usr/local/cadence/SPB_17.20.045 /usr/local/cadence/.

read -n 1 -s -r -p "Press any key to start Mentor Rsync..."

rsync -avz -e ssh cdsadmin@ib-hyperion.ib.ic.ac.uk:/usr/local/mentor/AMS_17.1.1 :/usr/local/mentor/aoi_cal_2018.4_17.10 :/usr/local/mentor/aoi_nxdat_2018.4_17.10 :/usr/local/mentor/docs_cal_2018.4_17.10 :/usr/local/mentor/QUESTA-CORE-PRIME_10.7c /usr/local/mentor/.

echo "After reboot please set password for cdsadmin"
echo "Also initiate a reboot to finish the installation process..."

