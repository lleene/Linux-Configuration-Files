#!/bin/csh -f

#############################################################
#
# START UP SCRIPT TO SET ENVIRONMENT FOR ALL CADENCE TOOLS
#
# !!!!!!!!!!For tools that is not IC version dependent!!!!!!!
# !!!!!! Load after loading IC version dependent tools !!!!!!
#
# Edited by Lieuwe Leene,
# 30/04/2019
# with reference to orignial script released by EuroPractice
#
# Customised for CBiT & EEE, Imperial College London
#
#
# !!! Needs to update for every update of Cadence tools  !!!
# !Please update the comments to correct software oversions!
#
#############################################################

# Generic LIC server link
setenv LM_LICENSE_FILE

# License server for Cadence tools
setenv CDS_LIC_FILE

if (! $?icver) then
	echo 'Please run pdk first before loading this script'
	exit 1
endif

##############################################################################
##
##   PVS before Assura
##   EXT before Assura
##
##############################################################################

if ($?PVS_VERSION) then
	if (-d $CDS_TOP/$PVS_VERSION) then
		setenv CDS_PVS $CDS_TOP/$PVS_VERSION
	else
		echo "Could not find" $PVS_VERSION
	endif
else
	setenv CDS_PVS `find $CDS_TOP -maxdepth 1 -type d -name "PVS_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_PVS == "" ) then
	setenv CDS_PVS $CDS_TOP/$CDS_PVS
	setenv PATH "${PATH}:${CDS_PVS}/bin"
	#setenv PATH "${PATH}:${CDS_PVS}/tools/bin"
endif

if ($?EXT_VERSION) then
	if (-d $CDS_TOP/$EXT_VERSION) then
		setenv CDS_EXT $CDS_TOP/$EXT_VERSION
	else
		echo "Could not find" $EXT_VERSION
	endif
else
	setenv CDS_EXT `find $CDS_TOP -maxdepth 1 -type d -name "EXT_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_EXT == "" ) then
	setenv CDS_EXT $CDS_TOP/$CDS_EXT
	setenv QRC_HOME $CDS_EXT
	setenv PATH "${PATH}:${CDS_EXT}/bin"
	#setenv PATH "${PATH}:${CDS_EXT}/tools/bin"
endif

#############################################################
##
## MVS
##
#############################################################

if ($?MVS_VERSION) then
	if (-d $CDS_TOP/$MVS_VERSION) then
		setenv CDS_MVS $CDS_TOP/$MVS_VERSION
	else
		echo "Could not find" $MVS_VERSION
	endif
else
	setenv CDS_MVS `find $CDS_TOP -maxdepth 1 -type d -name "MVS_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_MVS == "" ) then
	setenv CDS_MVS $CDS_TOP/$CDS_MVS
	setenv DFMHOME $CDS_MVS
	setenv RETHOME $DFMHOME
	setenv PATH "${PATH}:${CDS_MVS}/tools/bin"
	alias help_cds_mvs '$CDS_MVS/tools/bin/cdsnhelp &'
endif

#############################################################
##
## Conformal
##
#############################################################

if ($?CONFRML_VERSION) then
	if (-d $CDS_TOP/$CONFRML_VERSION) then
		setenv CDS_CONFRML $CDS_TOP/$CONFRML_VERSION
	else
		echo "Could not find" $CONFRML_VERSION
	endif
else
	setenv CDS_CONFRML `find $CDS_TOP -maxdepth 1 -type d -name "CONFRML_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_CONFRML == "" ) then
	setenv CDS_CONFRML $CDS_TOP/$CDS_CONFRML
	setenv PATH "${PATH}:${CDS_CONFRML}/bin"
	alias help_cds_conformal  '$CDS_CONFRML/bin/cdnshelp &'
endif

#############################################################
##
## Encounter Digital Implementation INNOVUS
##
#############################################################

#if ($?OLD_FLAG) then
#	setenv CDS_EDI `find $CDS_TOP -maxdepth 1 -type d -name "EDI_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
#	setenv PATH "${PATH}:${CDS_EDI}/bin"
#	alias help_cds_edi  '$CDS_EDI/tools/bin/cdnshelp &'
#	setenv MANPATH "${MANPATH}:${CDS_EDI}/share/fe/man"
#endif

if ($?INNOVUS_VERSION) then
	if (-d $CDS_TOP/$INNOVUS_VERSION) then
		setenv CDS_INNOVUS $CDS_TOP/$INNOVUS_VERSION
	else
		echo "Could not find" $INNOVUS_VERSION
	endif
else
	setenv CDS_INNOVUS `find $CDS_TOP -maxdepth 1 -type d -name "INNOVUS_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_INNOVUS == "" ) then
	setenv CDS_INNOVUS $CDS_TOP/$CDS_INNOVUS
	setenv PATH "${PATH}:${CDS_INNOVUS}/bin"
	alias help_cds_innovus  '$CDS_INNOVUS/tools/bin/cdnshelp &'
	setenv MANPATH "${MANPATH}:${CDS_INNOVUS}/share/fe/man"
endif

#############################################################
##
## SSV Voltus IC Power Integrity
##
#############################################################

if ($?SSV_VERSION) then
	if (-d $CDS_TOP/$SSV_VERSION) then
		setenv CDS_SSV $CDS_TOP/$SSV_VERSION
	else
		echo "Could not find" $SSV_VERSION
	endif
else
	setenv CDS_SSV `find $CDS_TOP -maxdepth 1 -type d -name "SSV_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_SSV == "" ) then
	setenv CDS_SSV $CDS_TOP/$CDS_SSV
	setenv PATH "${PATH}:${CDS_SSV}/bin"
	alias help_cds_ets  '$CDS_SSV/bin/cdnshelp &'
	# tempus, voltus
endif

#############################################################
##
## MMSIM Multimode Simulator
##
#############################################################

if ($?MMSIM_VERSION) then
	if (-d $CDS_TOP/$MMSIM_VERSION) then
		setenv CDS_MMSIM $CDS_TOP/$MMSIM_VERSION
	else
		echo "Could not find" $MMSIM_VERSION
	endif
else
	setenv CDS_MMSIM `find $CDS_TOP -maxdepth 1 -type d -name "MMSIM_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_MMSIM == "" ) then
	setenv CDS_MMSIM $CDS_TOP/$CDS_MMSIM
	setenv PATH "${PATH}:${CDS_MMSIM}/bin"
	alias help_cds_mmsim  '$CDS_MMSIM/tools/bin/cdnshelp &'
endif

#############################################################
##
## RTL Compiler GENUS
##
#############################################################

#if ($?OLD_FLAG) then
#	setenv CDS_RC `find $CDS_TOP -maxdepth 1 -type d -name "RC_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
#	setenv PATH "${PATH}:${CDS_RC}/bin"
#	setenv PATH "${PATH}:${CDS_RC}/tools/bin"
#	alias help_cds_rc '$CDS_RC/tools/bin/cdnshelp &'
#endif


if ($?GENUS_VERSION) then
	if (-d $CDS_TOP/$GENUS_VERSION) then
		setenv CDS_GENUS $CDS_TOP/$GENUS_VERSION
	else
		echo "Could not find" $GENUS_VERSION
	endif
else
	setenv CDS_GENUS `find $CDS_TOP -maxdepth 1 -type d -name "GENUS_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_GENUS == "" ) then
	setenv CDS_GENUS $CDS_TOP/$CDS_GENUS
	setenv PATH "${PATH}:${CDS_GENUS}/bin"
	alias help_cds_genus '$RC_PATH/tools/bin/cdnshelp &'
endif

##############################################################
##
## MODUS
##
##############################################################

if ($?MODUS_VERSION) then
	if (-d $CDS_TOP/$MODUS_VERSION) then
		setenv CDS_MODUS $CDS_TOP/$MODUS_VERSION
	else
		echo "Could not find" $MODUS_VERSION
	endif
else
	setenv CDS_MODUS `find $CDS_TOP -maxdepth 1 -type d -name "MODUS_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_MODUS == "" ) then
	setenv CDS_MODUS $CDS_TOP/$CDS_MODUS
	setenv PATH "${PATH}:${CDS_MODUS}/bin"
	alias help_cds_modus  '$CDS_MODUS/bin/cdnshelp &'
endif

##############################################################
##
## INDAGO
##
##############################################################

if ($?INDAGO_VERSION) then
	if (-d $CDS_TOP/$INDAGO_VERSION) then
		setenv CDS_INDAGO $CDS_TOP/$INDAGO_VERSION
	else
		echo "Could not find" $INDAGO_VERSION
	endif
else
	setenv CDS_INDAGO `find $CDS_TOP -maxdepth 1 -type d -name "INDAGO_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_INDAGO == "" ) then
	setenv CDS_INDAGO $CDS_TOP/$CDS_INDAGO
	setenv PATH "${PATH}:${CDS_INDAGO}/bin"
	alias help_cds_indago '$CDS_INDAGO/bin/cdnshelp &'
endif

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
	setenv CDS_INCV `find $CDS_TOP -maxdepth 1 -type d -name "INCISIVE_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_INCV == "" ) then
	setenv CDS_INCV $CDS_TOP/$CDS_INCV
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
endif

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
	setenv CDS_VIPCAT `find $CDS_TOP -maxdepth 1 -type d -name "VIPCAT_*UVM*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_VIPCAT == "" ) then
	setenv CDS_VIPCAT $CDS_TOP/$CDS_VIPCAT
	setenv PATH "${PATH}:${CDS_VIPCAT}/tools/bin"
	if ( $?SPECMAN_PATH == 0) then
		setenv SPECMAN_PATH "${CDS_VIPCAT}/utils:${CDS_VIPCAT}/packages"
	else
		setenv SPECMAN_PATH "${CDS_VIPCAT}/utils:${CDS_VIPCAT}/packages:${SPECMAN_PATH}"
	endif
	alias help_cds_vipcat  '$CDS_VIPCAT/tools/bin/cdnshelp &'
endif

##############################################################
##
## IC -DFWII / VIRTUOSO
##
#############################################################

# Set CDS log file (CDS.log) to increment sequentially
setenv CDS_LOG_VERSION sequential
source "$CDS_TOP/../bin/ic61x.cshrc"

# order dependencies - rc before EDI
# order dependencies - mvs before IC
# order dependencies - ext before assura, assura after ic
