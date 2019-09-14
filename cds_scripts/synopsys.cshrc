#!/bin/csh

##############################################################################
#
#   Work in progress
#   Cadence 2019 Synopsys tools setup script
#   START UP SCRIPT TO SET ENVIRONMENT
#   Edited by Lieuwe Leene,
#   28/4/2019
#
##############################################################################

setenv SYN_DIR $CDS_TOP/../synopsys
setenv PATH "${PATH}:$SYN_DIR/syn/bin:$SYN_DIR/tetramax/bin:$SYN_DIR/formality/bin:$SYN_DIR/primetime/bin"
setenv SNPSLMD_LICENSE_FILE $SYN_LIC_HOST
