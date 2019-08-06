#!/bin/csh -f

############################################################
#
# START UP SCRIPT TO SET ENVIRONMENT FOR ALL CADENCE TOOLS
# For TSMC PDK
# Based on TSMC Release Notes
#
# Edited by Lieuwe Leene
# 30/04/2019
#
#############################################################

# Copy of cds.lib, display.drf

if ( !( -e cds.lib ) && ( `echo $PWD | awk '{split($0,a,"/"); print a[2] "/" a[3]}'` == "ibe/users") ) then
	cp $TSMC_PDK_PATH/cds.lib cds.lib
endif

if ( !( -e display.drf ) && ( `echo $PWD | awk '{split($0,a,"/"); print a[2] "/" a[3]}'` == "ibe/users") ) then
	cp $TSMC_PDK_PATH/display.drf display.drf
endif
