#!/bin/csh -f

##############################################################################
#
#   Cadence 2019 Mentor tools setup script
#   START UP SCRIPT TO SET ENVIRONMENT
#   Edited by Lieuwe Leene,
#   28/4/2019
#
##############################################################################

#############################################################
##
## Calibre Configuration
##
#############################################################

if ($?CAL_VERSION) then
	if (-d $CDS_TOP/../mentor/aoi_cal_$CAL_VERSION) then
		setenv MGC_HOME $CDS_TOP/../mentor/aoi_cal_$CAL_VERSION
	endif
else
	setenv MGC_HOME `find $CDS_TOP/../mentor -maxdepth 1 -type d -name "aoi_cal*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $MGC_HOME == "" ) then
	setenv MGC_HOME $CDS_TOP/../mentor/$MGC_HOME
	setenv MGLS_LICENSE_FILE 1717@ib-artemis.ib.ic.ac.uk
	setenv PATH "${PATH}:${MGC_HOME}/bin"
	# 2018 CALIBRE USES NEW PATH
	setenv CALIBRE_HOME $MGC_HOME
	alias help_mg_cal '${CALIBRE_HOME}/bin/mgcdocs'
	# Use 64bit Calibre instead of 32bit default
	setenv USE_CALIBRE_64 YES
	setenv MGC_DOC_PATH $MGC_HOME/docs
	setenv MGC_HTML_BROWSER firefox
	setenv MGC_PDF_READER evince
	setenv MGC_CALIBRE_PRESERVE_MENU_TRIGGER YES
endif

###############################################################################
##   
##    Questa core prime 
##
###############################################################################

if ($?MTI_VERSION) then
	if (-d $CDS_TOP/../mentor/$MTI_VERSION) then
		setenv MTI_HOME $CDS_TOP/../mentor/$MTI_VERSION
	else
		echo "Could not find" $MTI_VERSION
	endif
else
	setenv MTI_HOME `find $CDS_TOP/../mentor -maxdepth 1 -type d -name "QUESTA-CORE*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $MTI_HOME == "" ) then
	setenv MTI_HOME $CDS_TOP/../mentor/$MTI_HOME
	setenv PATH "${PATH}:${MTI_HOME}"
	setenv MODEL_TECH "${MTI_HOME}"
	# vsim
endif

##############################################################################
##
##    Questa cdc fml 
##
##############################################################################

if ($?OIN_VERSION) then
	if (-d $CDS_TOP/../mentor/$OIN_VERSION) then
		setenv HOME_0IN $CDS_TOP/../mentor/$OIN_VERSION
	else
		echo "Could not find" $OIN_VERSION
	endif
else
	setenv HOME_0IN `find $CDS_TOP/../mentor -maxdepth 1 -type d -name "QUESTA-CDC*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $HOME_0IN == "" ) then
	setenv HOME_0IN $CDS_TOP/../mentor/$HOME_0IN
	setenv PATH $PATH":$HOME_0IN/bin"
	#setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH":$HOME_0IN/lib"
	# qcdc
	# Note: Questa Formal is in the "Full Suite" bundle only
	#   qformal, qautocheck
endif

##############################################################################
##
##    Questa infact 
##
##############################################################################

if ($?INFACT_VERSION) then
	if (-d $CDS_TOP/../mentor/$INFACT_VERSION) then
		setenv INFACT_HOME $CDS_TOP/../mentor/$INFACT_VERSION
	else
		echo "Could not find" $INFACT_VERSION
	endif
else
	setenv INFACT_HOME `find $CDS_TOP/../mentor -maxdepth 1 -type d -name "QUESTA-INFACT_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $INFACT_HOME == "" ) then
	setenv INFACT_HOME $CDS_TOP/../mentor/$INFACT_HOME
	setenv INFACT_CXX gcc_4.5.0
	#setenv INFACT_CXX gcc_4.7.4
	#setenv INFACT_CXX gcc_5.3.0
	setenv PATH "${PATH}:${INFACT_HOME}/linux_x86_64/${INFACT_CXX}/bin"
	#source ${INFACT_HOME}/etc/infact_setup.csh
	# infact
endif

##############################################################################
##
##    Questa vip 
##
##############################################################################

if ($?QVIP_VERSION) then
	if (-d $CDS_TOP/../mentor/$QVIP_VERSION) then
		setenv QVIP_HOME $CDS_TOP/../mentor/$QVIP_VERSION
	else
		echo "Could not find" $QVIP_VERSION
	endif
else
	setenv QVIP_HOME `find $CDS_TOP/../mentor -maxdepth 1 -type d -name "QUESTA-VIP_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $QVIP_HOME == "" ) then
	setenv QVIP_HOME $CDS_TOP/../mentor/$QVIP_HOME
	setenv PATH "${PATH}:${QVIP_HOME}/bin"
endif


