#!/bin/csh -f

#############################################################
##
## START UP SCRIPT TO SET ENVIRONMENT FOR ALL CADENCE TOOLS
## Edited by Michal Maslik 09/03/2017
##
##############################################################

#############################################################
##
## Configuration for AMS HIT-KIT
## 4.14
##
#############################################################

## Setting IC 6.1.x, cndtools, calibre, synopsys

setenv icver ic61x
source $CDS_TOP/../bin/cdntools.cshrc
source $CDS_TOP/../bin/mentortools.cshrc
source $CDS_TOP/../bin/synopsys.cshrc

## Setting the Hit-Kit

setenv AMS_DIR $CDS_TOP/kits/ams/4.14
setenv PATH "${PATH}:${AMS_DIR}/cds/bin:${AMS_DIR}/programs/bin"
# For using AMS_Designer set the following environment variable
setenv CDS_BIND_TMP_DD true
setenv IUSDIR $CDS_INCV

## Setting custom configuration

if (! -e display.drf && ( `echo $PWD | awk '{split($0,a,"/"); print a[2] "/" a[3]}'` == $USRDIR_TOP ) ) then
	cp $AMS_DIR/cds/HK_ALL/env/display.drf display.drf
endif

setenv USR_DIR `id --user --name`
