#!/bin/csh

##############################################################################
#
#   Cadence 2016-17 SYSTEMS tools setup script
#   START UP SCRIPT TO SET ENVIRONMENT FOR SYSTEM PCB TOOLS
#
#   Edited by Lieuwe Leene,
#   7/2/2017
#
##############################################################################

###############################################################
###
### INCISIVE
###
###############################################################

if ($?INCISIVE_VERSION) then
	if (-d $CDS_TOP/$INCISIVE_VERSION) then
		setenv CDS_INCV $CDS_TOP/$INCISIVE_VERSION
	else
		echo "Could not find" $INCISIVE_VERSION
	endif
else
	setenv CDS_INCV $CDS_TOP/`find $CDS_TOP -maxdepth 1 -type d -name "INCISIVE_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

setenv PATH "${PATH}:${CDS_INCV}/bin"
setenv PATH "${PATH}:${CDS_INCV}/tools/bin"
setenv PATH "${PATH}:${CDS_INCV}/tools/systemc/gcc/bin"
setenv SOCV_KIT_HOME $CDS_INCV/kits/VerificationKit
setenv PATH "${PATH}:${CDS_INCV}/kits/VerificationKit/bin"
source $SOCV_KIT_HOME/env.csh
alias help_cds_incisiv '$CDS_INCV/bin/cdnshelp &'
# irun, eplanner, emanager/vmanager, imc, simvision, simcompare, viewWaveform
# nclaunch, ncvhdl, ncvlog, ncsc, ncelab, ncsim, ncls, nchelp, hal, iev, ifv, specman,
# start_kit start_nav

###############################################################
###
### VIPCAP Verification IP Catalog
###
###############################################################

if ($?VIPCAT_VERSION) then
	if (-d $CDS_TOP/$VIPCAT_VERSION) then
		setenv CDS_VIPCAT $CDS_TOP/$VIPCAT_VERSION
	else
		echo "Could not find" $VIPCAT_VERSION
	endif
else
	setenv CDS_VIPCAT $CDS_TOP/`find $CDS_TOP -maxdepth 1 -type d -name "VIPCAT_*UVM*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

setenv PATH "${PATH}:${CDS_VIPCAT}/tools/bin"
if ( $?SPECMAN_PATH == 0) then
  setenv SPECMAN_PATH "${CDS_VIPCAT}/utils:${CDS_VIPCAT}/packages"
else
  setenv SPECMAN_PATH "${CDS_VIPCAT}/utils:${CDS_VIPCAT}/packages:${SPECMAN_PATH}"
endif
alias help_cds_vipcat  '$CDS_VIPCAT/tools/bin/cdnshelp &'
#

###############################################################
###
### Allegro PCB Design
### with Signal Integrety Integration SIG
###
###############################################################

if ($?SPB_VERSION) then
	if (-d $CDS_TOP/$SPB_VERSION) then
		setenv CDS_SPB $CDS_TOP/$SPB_VERSION
	else
		echo "Could not find" $SPB_VERSION
	endif
else
	setenv CDS_SPB $CDS_TOP/`find $CDS_TOP -maxdepth 1 -type d -name "SPB_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

## first path entry required for RF SIP tools rfwb (RF workbench)
setenv PATH "${PATH}:${CDS_SPB}/tools/dfII/bin"
setenv PATH "${PATH}:${CDS_SPB}/tools/pcb/bin"  #ALGROPATH
setenv PATH "${PATH}:${CDS_SPB}/tools/specctra/bin" #SPECTTRAPATH
setenv PATH "${PATH}:${CDS_SPB}/tools/bin" #TOOLSBIN
setenv PATH "${PATH}:${CDS_SPB}/tools/fet/bin" #FETPATH

alias help_cds_spb '$CDS_SPB/tools/bin/cdnshelp &'
# allegro, sip_free_viewer
# rfwb  (Require IC6)


if ($?SIG_VERSION) then
	if (-d $CDS_TOP/$SIG_VERSION) then
		setenv CDS_SIG $CDS_TOP/$SIG_VERSION
	else
		echo "Could not find" $SIG_VERSION
	endif
else
	setenv CDS_SIG $CDS_TOP/`find $CDS_TOP -maxdepth 1 -type d -name "SIG_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

# for Sigrity Integration with SPB
set SIGRITY_EDA_DIR = ${CDS_SIG}
set SIGRITYPATH = ($SIGRITY_EDA_DIR/Translators/bin $SIGRITY_EDA_DIR/SpeedXP/bin)
setenv PATH "${PATH}:${SIGRITY_EDA_DIR}/Translators/bin ${SIGRITY_EDA_DIR}/SpeedXP/bin"

setenv PATH "${PATH}:${CDS_SIG}/tools/pcb/bin"
setenv PATH "${PATH}:${CDS_SIG}/tools/bin"
source $CDS_SPB/tools/pcb/bin/cshrc
alias help_cds_asi '$CDS_SPB/tools/bin/cdnshelp &'
# sigritysuitemanager, systemsi, xcitepi, xtractim, powersi, powerdc
