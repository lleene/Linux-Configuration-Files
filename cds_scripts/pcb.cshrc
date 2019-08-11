#!/bin/csh -f

#############################################################
#
# START UP SCRIPT TO SET ENVIRONMENT FOR CADENCE IC 6
# For Cadence Allegro PCB Design
# Based on IC6 Release Notes
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
source $CDS_TOP/../bin/calibre.cshrc
# Setting Synopsys
source $CDS_TOP/../bin/synopsys.cshrc
