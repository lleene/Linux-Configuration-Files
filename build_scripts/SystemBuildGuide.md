# System Build Outline based on CentOS 7.4+ Minimum Install
Last Edited by Lieuwe Leene on 10/8/19

## Preparing packages
After setting up the minimum/net install base with at least 500GB on the root partition, we can proceed with installing the required packages given that the network has also been set up.

```bash
logname=yum.install.`date "+%F"`.log
echo "Preparing to install packages... 1/3"
yum -y groupinstall $group_install_list > $logname
echo "Preparing to install packages... 2/3"
yum -y install epel-release >> $logname
echo "Preparing to install packages... 3/3"
yum -y install $package_install_list >> $logname
# Show any errors / warnings
grep (error|warning|fail) $logname
read -n 1 -s -r -p "Press any key to continue build configuration..."
```

## 
