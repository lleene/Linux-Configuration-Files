#!/bin/csh -f

#EDITED LBL 2019 - SET GLOBAL SYS CONFIG HERE
if ($?kitid) then
    setenv USRDIR_TOP "XX/XX"
    # Root path for Cadence tools
    setenv CDS_TOP /usr/local/cadence
    setenv GENERIC_LIBS $CDS_TOP/kits/generic
    source "$CDS_TOP/../bin/$kitid.cshrc"
endif
