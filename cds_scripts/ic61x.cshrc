#!/bin/csh -f

#############################################################
#
# START UP SCRIPT TO SET ENVIRONMENT FOR ALL CADENCE TOOLS
#
# Edited by Lieuwe Leene  30/4/2019
# with reference to orignial script released by EuroPractice
#
# Customised for CBiT & EEE, Imperial College London
#
# TO FIND LAUNCH COMMANDS FOR ANY TOOL, USE TO_LAUNCH_CDS_<TOOL>
# E.G. TO_LAUNCH_CDS_EDI
#
#
#############################################################

##############################################################
##
## IC
##
##############################################################

if ($?CDS_IC_VERSION) then
	if (-d $CDS_TOP/$CDS_IC_VERSION) then
		setenv CDS_IC $CDS_TOP/$CDS_IC_VERSION
	else
		echo "Could not find" $CDS_IC_VERSION
	endif
else
	setenv CDS_IC `find $CDS_TOP -maxdepth 1 -type d -name "IC_6*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_IC == "" ) then
	setenv CDS_IC $CDS_TOP/$CDS_IC
	#some use CDSDIR, some CDS_DIR
	setenv CDSDIR $CDS_IC
	setenv CDS_DIR $CDS_IC
	# When using ADE set netlisting mode to analog ("dfIIconfig.pdf"), p16.
	setenv CDS_Netlisting_Mode Analog
	# Required for tutorial material and cadence libraries (eg analogLib)
	setenv CDSHOME $CDS_IC
	setenv CDS_USE_PALETTE
	setenv PATH "${PATH}:${CDS_IC}/tools/bin"
	setenv PATH "${PATH}:${CDS_IC}/tools/dfII/bin"
	alias help_cds_ic  '$CDS_IC/tools/bin/cdnshelp &'
endif

#############################################################
##
## ASSURA
##
#############################################################

if ($?ASSURA_VERSION) then
	if (-d $CDS_TOP/$ASSURA_VERSION) then
		setenv CDS_ASSURA $CDS_TOP/$ASSURA_VERSION
	else
		echo "Could not find" $ASSURA_VERSION
	endif
else
	setenv CDS_ASSURA `find $CDS_TOP -maxdepth 1 -type d -name "ASSURA_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_ASSURA == "" ) then
	setenv CDS_ASSURA $CDS_TOP/$CDS_ASSURA
	setenv ASSURAHOME $CDS_ASSURA
	#the following line might be completely redundant
	setenv SUBSTRATESTORMHOME $ASSURAHOME		# For Assura-RF
	setenv LANG C
	setenv PATH "${PATH}:${CDS_ASSURA}/tools/bin"
	setenv PATH "${PATH}:${CDS_ASSURA}/tools/assura/bin"
	setenv PATH "${PATH}:${SUBSTRATESTORMHOME}/bin"
	setenv ASSURA_AUTO_64BIT ALL
	alias help_cds_assura  '$CDS_ASSURA/tools/bin/cdnshelp &'
endif

#############################################################
##
## SPECTRE
##
#############################################################

if ($?SPECTRE_VERSION) then
	if (-d $CDS_TOP/$SPECTRE_VERSION) then
		setenv CDS_SPECTRE $CDS_TOP/$SPECTRE_VERSION
	else
		echo "Could not find" $SPECTRE_VERSION
	endif
else
	setenv CDS_SPECTRE `find $CDS_TOP -maxdepth 1 -type d -name "SPECTRE_*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
endif

if !( $CDS_SPECTRE == "" ) then
	setenv CDS_SPECTRE $CDS_TOP/$CDS_SPECTRE
	setenv PATH "${PATH}:${CDS_SPECTRE}/bin"
	alias help_cds_spectre '$CDS_SPECTRE/tools/bin/cdnshelp &'
endif

###########################################################
##
## NOTE EXPLICITLY For constraint Driven Flow
##
###########################################################

# order dependencies - rc before EDI
# order dependencies - mvs before IC
# order dependencies - ext before assura, assura after ic
