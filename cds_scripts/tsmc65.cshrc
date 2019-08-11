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
setenv TSMC_PDK_PATH $CDS_TOP/kits/tsmc/65n_LP

setenv TSMC_PDK_PycellStudio_64 $TSMC_PDK_PATH/PycellStudio/lnx_64

setenv CNI_ROOT	 $CDS_TOP/kits/tsmc/65n_LP/PycellStudio/lnx_64
setenv OA_COMPILER		gcc44x
set CNI_PLAT_ROOT=${CNI_ROOT}/plat_linux_gcc44x_64
setenv CNI_LOG_DEFAULT	/dev/null
setenv PYTHONHOME ${CNI_PLAT_ROOT}/3rd

if ($?PYTHONPATH) then 
  setenv PYTHONPATH ${CNI_ROOT}/pylib:${CNI_PLAT_ROOT}/pyext:${CNI_PLAT_ROOT}/lib:.:${PYTHONPATH}
else
  setenv PYTHONPATH ${CNI_ROOT}/pylib:${CNI_PLAT_ROOT}/pyext:${CNI_PLAT_ROOT}/lib:.
endif
if ($?LD_LIBRARY_PATH) then 
  setenv LD_LIBRARY_PATH ${CNI_PLAT_ROOT}/3rd/lib:${CNI_PLAT_ROOT}/3rd/oa/lib/linux_rhel40_gcc44x_64/opt:${CNI_PLAT_ROOT}/lib:${LD_LIBRARY_PATH}
else
  setenv LD_LIBRARY_PATH ${CNI_PLAT_ROOT}/3rd/lib:${CNI_PLAT_ROOT}/3rd/oa/lib/linux_rhel40_gcc44x_64/opt:${CNI_PLAT_ROOT}/lib
endif
  setenv PATH ${CNI_PLAT_ROOT}/3rd/bin:${CNI_PLAT_ROOT}/3rd/oa/bin/linux_rhel40_gcc44x_64/opt:${CNI_PLAT_ROOT}/bin:${CNI_ROOT}/bin:${PATH}

if ($?OA_PLUGIN_PATH) then 
  setenv OA_PLUGIN_PATH ${CNI_PLAT_ROOT}/3rd/oa/data/plugins:${CNI_ROOT}/quickstart:${OA_PLUGIN_PATH}
else
  setenv OA_PLUGIN_PATH ${CNI_PLAT_ROOT}/3rd/oa/data/plugins:${CNI_ROOT}/quickstart
endif
