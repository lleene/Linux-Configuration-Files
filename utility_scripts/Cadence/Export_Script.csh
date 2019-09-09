#!/bin/csh

# Check if environment is loaded
if !($?kitid) then
	echo "PDK Not Initialised, Start Cadence First"
	exit 1
endif

echo WARNING EDIT FILE TO SET RUN_PATH
exit 1

	set $RUN_PATH
	set LOG_OUTFILE=$RUN_PATH/Scripts/SAMPLE.strmout.log
	set LOG_INFILE=$RUN_PATH/Scripts/SAMPLE.strmin.log
	set LIB_NAME=SAMPLE_IMPORT
	rm $RUN_PATH/Scripts/SAMPLE.strmout.log
	rm $RUN_PATH/Scripts/SAMPLE.strmin.log
	rm $RUN_PATH/Scripts/xStrmOut_cellMap.txt

	cd $RUN_PATH
	echo "Streaming Out SAMPLE Reticle..."

	set cmd_strout="strmout -library SAMPLE_RETICLE_2019 -strmFile $RUN_PATH/SAMPLE_EXPORT.gds -techLib tsmc18 -topCell RETICLE_TOP -view layout -layerMap $RUN_PATH/Scripts/SAMPLE_2019_ER.map -refLibList $RUN_PATH/Scripts/reflib.liblist -logFile $LOG_OUTFILE"

	set cmd_strin="strmin -library $LIB_NAME -strmFile $RUN_PATH/SAMPLE_EXPORT.gds -attachTechFileOfLib tsmc18 -cellMap $RUN_PATH/Scripts/SAMPLE_Cellmap.map -refLibList $RUN_PATH/Scripts/reflib.liblist -logFile $LOG_INFILE"

	rm SAMPLE_EXPORT.tar.gz
	rm SAMPLE_EXPORT.tar.gz.gpg
	rm SAMPLE_EXPORT.gds

	# Clear Lib Files
	set file_list=(`find $LIB_NAME/* -type d -prune -exec basename \{} .po \;`)
	if ( "$file_list" == "" || "$file_list" == "find: No match." ) then
		echo $LIB_NAME "Is empty or does not exist! Skipping..."
	else
		foreach file ($file_list)
			echo "Clearing /ibe/users/lbl11/SAMPLE/"$LIB_NAME/$file
			rm -rf /ibe/users/lbl11/SAMPLE/$LIB_NAME/$file
		end
	endif

	$cmd_strout
	mv xStrmOut_cellMap.txt $RUN_PATH/Scripts/xStrmOut_cellMap.txt

	sed -e '/tcb018bcdgp2a\|tcb018g3d3\|tcb018gbwp7t\|tcb018rfid\|tpa018nv\|tpb018v\|tpd018bcdnv5\|tpi018nv\|tps018bcdnv5/\!d' Scripts/xStrmOut_cellMap.txt > $RUN_PATH/Scripts/SAMPLE_Cellmap.map

	echo "Streaming In Export Reticle..."
	$cmd_strin

	sed -e '/tcb018bcdgp2a\|tcb018g3d3\|tcb018gbwp7t\|tcb018rfid\|tpa018nv\|tpb018v\|tpd018bcdnv5\|tpi018nv\|tps018bcdnv5/\!d' $LOG_INFILE  | grep -oh 'tcb018bcdgp2a\|tcb018g3d3\|tcb018gbwp7t\|tcb018rfid\|tpa018nv\|tpb018v\|tpd018bcdnv5\|tpi018nv\|tps018bcdnv5' | sort | uniq > SAMPLE2019.usedlibs.report

	tar -czvf SAMPLE_EXPORT.tar.gz SAMPLE_EXPORT.gds Scripts/SAMPLE_Cellmap.map Scripts/reflib.liblist Scripts/SAMPLE_Technology_Details.txt
	gpg -r $gpg_id -e SAMPLE_EXPORT.tar.gz

	echo "Export was a Success!"
