# Notes for Install/Resolve Packages for Cadence 6.1.7 on Fedora29
Need to patch tools/bin/checkSysConf since (-f /etc/os-build) will be falsely interpreted as ubuntu platform. Some changes are obvious to but to include fedora in the white list but the above condition must be elaborated to: (-f "/etc/os-release" && `grep "ubuntu" /etc/os-release > /dev/null`).
