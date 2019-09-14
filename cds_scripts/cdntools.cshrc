#!/bin/csh -f

#############################################################
#
# START UP SCRIPT TO SET ENVIRONMENT FOR ALL CADENCE TOOLS
#
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
setenv LM_LICENSE_FILE $LM_LICENSE_HOST

# License server for Cadence tools
setenv CDS_LIC_FILE $CDS_LICENSE_HOST

if (! $?icver) then
	echo 'Please run pdk first before loading this script'
	exit 1
endif

# echo "loading backend tools"

##############################################################################
##
##   PVS before Assura
##   EXT before Assura
##
##############################################################################

eval `CheckCDSToolVersion "PVS_VERSION" "CDS_PVS" "PVS_*"`

if ($?CDS_PVS) then
	setenv CDS_PVS $CDS_TOP/$CDS_PVS
	setenv PATH "${PATH}:${CDS_PVS}/bin"
	#setenv PATH "${PATH}:${CDS_PVS}/tools/bin"
endif

eval `CheckCDSToolVersion "EXT_VERSION" "CDS_EXT"`

if ($?CDS_EXT) then
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

eval `CheckCDSToolVersion "MVS_VERSION" "CDS_MVS" "MVS_*"`

if ($?CDS_MVS) then
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

eval `CheckCDSToolVersion "CONFRML_VERSION" "CDS_CONFRML" "CONFRML_*"`

if ($?CDS_CONFRML) then
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

eval `CheckCDSToolVersion "INNOVUS_VERSION" "CDS_INNOVUS" "INNOVUS_*"`

if ($?CDS_INNOVUS) then
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

eval `CheckCDSToolVersion "SSV_VERSION" "CDS_SSV" "SSV_*"`

if ($?CDS_SSV) then
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

eval `CheckCDSToolVersion "MMSIM_VERSION" "CDS_MMSIM" "MMSIM_*"`

if ($?CDS_MMSIM) then
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

eval `CheckCDSToolVersion "GENUS_VERSION" "CDS_GENUS" "GENUS_*"`

if ($?CDS_GENUS) then
	setenv CDS_GENUS $CDS_TOP/$CDS_GENUS
	setenv PATH "${PATH}:${CDS_GENUS}/bin"
	alias help_cds_genus '$RC_PATH/tools/bin/cdnshelp &'
endif

##############################################################
##
## MODUS
##
##############################################################

eval `CheckCDSToolVersion "MODUS_VERSION" "CDS_MODUS" "MODUS_*"`

if ($?CDS_MODUS) then
	setenv CDS_MODUS $CDS_TOP/$CDS_MODUS
	setenv PATH "${PATH}:${CDS_MODUS}/bin"
	alias help_cds_modus  '$CDS_MODUS/bin/cdnshelp &'
endif

##############################################################
##
## INDAGO
##
##############################################################

eval `CheckCDSToolVersion "INDAGO_VERSION" "CDS_INDAGO" "INDAGO_*"`

if ($?CDS_INDAGO) then
	setenv CDS_INDAGO $CDS_TOP/$CDS_INDAGO
	setenv PATH "${PATH}:${CDS_INDAGO}/bin"
	alias help_cds_indago '$CDS_INDAGO/bin/cdnshelp &'
endif

###############################################################
###
### INCISIVE
###
###############################################################

eval `CheckCDSToolVersion "INCISIVE_VERSION" "CDS_INCV" "INCISIVE_*"`

if ($?CDS_INCV) then
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

eval `CheckCDSToolVersion "VIPCAT_VERSION" "CDS_VIPCAT" "VIPCAT_*UVM*"`

if ($?CDS_VIPCAT) then
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
