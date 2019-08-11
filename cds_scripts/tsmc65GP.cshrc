#!/bin/csh -f

#############################################################
#
# START UP SCRIPT TO SET ENVIRONMENT FOR CADENCE IC 6
# For TSMC PDK
# Based on PDK Release Notes 
#
# Edited by Lieuwe Leene
# 30/02/2016
#
#############################################################

setenv CDS_AUTO_64BIT ALL

# Setting IC 6.1.x 
setenv icver ic61x
# Setting other cadence tools
source $CDS_TOP/../bin/cdntools.cshrc
# Setting Calibre
source $CDS_TOP/../bin/mentortools.cshrc
# Setting Synopsys
source $CDS_TOP/../bin/synopsys.cshrc

setenv CDS_INST_DIR ${CDS_IC}

# Setting the PATH
setenv TSMC_PDK_PATH $CDS_TOP/kits/tsmc/65n_GP

