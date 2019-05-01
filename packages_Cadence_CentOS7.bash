#!/bin/bash
# Notes for Install/Resolve Packages for Cadence 6.1.7 on Centos 7.x
# Please export CDS_TOP path to env

if (( $EUID != 0 )); then
  echo "You do not have root privileges. Skipping package install.";
else
  echo "Preparing to install packages... "
  logname=/tmp/yum.install.`date "+%F"`.log
  # Install cadence dependencies
  yum -y install kernel-devel kernel-headers libXp glibc-devel.x86_64 glibc-devel.i686 gcc gdbm elfutils elfutils-libelf libXtst p7zip compat-libtermcap csh xorg-x11-fonts* ksh libcxx glibc.i686 openssl098e-0.9.8e-29.el7.centos.3 mesa-libGLU-9.0.0-4.el7 redhat-lsb-core libXp.i686 motif.x86_64 motif.i686 redhat-lsb.x86_64 redhat-lsb.i686 libXScrnSaver >> $logname
  echo "Done! See /tmp/$output_file for results"
  # Show any errors / warnings
  grep -e "error" -e "warning" -e "fail" $logname
fi

if [ -z "${CDS_TOP+x}" ]; then
  echo "To run cdsCheckList set CDS_TOP to point to Cadence tool root directory (e.g. /usr/local/cadence)";
  exit 1;
else
  echo "Preparing to run checks for IC tools ... "
  # Set Output Location
  output_file="/tmp/cdsCheckList_"`date "+%F"`
  # Process All Valid Directories
  for DIR_NAME in $(find $CDS_TOP/* -maxdepth 1 -type d -prune -printf "%f\n")
  do
    if [ -f $CDS_TOP/$DIR_NAME/tools/bin/checkSysConf ]; then
      echo "Checking: $DIR_NAME"
      tool_name=`$CDS_TOP/$DIR_NAME/tools/bin/checkSysConf -r | grep "Valid" -A 2 | awk 'FNR == 2 {print $1}'`
      $CDS_TOP/$DIR_NAME/tools/bin/checkSysConf $tool_name >> $output_file
    else
      echo "$DIR_NAME has no valid checks"
    fi
  done
  echo "Done! See $output_file for results"
fi
