# Notes for Install/Resolve Packages for Cadence 6.1.7 on Fedora29



### Cadence OS version checking Fix
Need to patch tools/bin/checkSysConf since (-f /etc/os-build) will be falsely interpreted as ubuntu platform. Some changes are obvious. Simply include fedora in the white list but the above condition must be elaborated to: (-f "/etc/os-release" && `grep "ubuntu" /etc/os-release > /dev/null`).

```bash
$IC_TOP/tools/bin/checkSysConf
$IC_TOP/tools/bin/cdsVncserver
```

### Mentor OS version checking Fix
Need to patch calibre_host_info to whitelist fedora as a valid operating platform. Some changes are obvious. Simply include fedora in the white list but it is better to mask the vendor is with (egrep -iq 'fedora' 2>/dev/null && OS_VENDOR=redhat).

```bash
$MGC_HOME/pkgs/icv_calenv/pvt/calibre_host_info
```

### Cadence Font Path Fix


```csh
if (-e "/opt/local/fonts") {
$cmd .= " -fp /opt/local/fonts/,/opt/local/fonts/misc/,/opt/local/fonts/75dpi/,/opt/local/fonts/100dpi/";
} elsif ( -e "/usr/share/X11/fonts" ) {
```
