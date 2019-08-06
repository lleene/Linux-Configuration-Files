#!/bin/csh -f

#############################################################
##
## OUT DATED USE MENTOR TOOLS INSTEAD
## Calibre Configuration
## Last Edited by: Lieuwe Leene 10-04-2018
##
#############################################################

# This will always load the latest calibre version unless the calibre version is preset

if ($?CAL_VERSION) then
	if (-d /usr/local/mentor/aoi_cal_$CAL_VERSION) then
		setenv MGC_HOME /usr/local/mentor/aoi_cal_$CAL_VERSION
	endif
else
	setenv MGC_HOME `find /usr/local/mentor -maxdepth 1 -type d -name "aoi_cal*" -printf "%f\n" | sort -r | awk '{print $1;exit}'`
	setenv MGC_HOME /usr/local/mentor/$MGC_HOME
endif

setenv MGLS_LICENSE_FILE
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
