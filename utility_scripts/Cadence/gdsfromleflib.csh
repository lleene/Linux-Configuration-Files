#!/bin/csh

if (!("$#" == 2) || !( -d "$1" ) || !( -e "$2" ))then
  echo "Usage: $0 DIRECTORY LAYERMAP.map"
  exit 1
endif

set lef_list=(`find $1/*.lef -type f -prune -exec basename \{} .po \;`)
foreach lef_file ($lef_list)
  echo $lef_file
  fdi2gds -system LEFDEF -lef $1/$lef_file -layermap $2 -outFile $1/$lef_file.gds
end
