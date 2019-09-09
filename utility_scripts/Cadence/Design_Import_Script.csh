#!/bin/csh

# Check if environment is loaded
if !($?kitid) then
	echo "PDK Not Initialised, Start Cadence First"
	exit 1
endif

echo WARNING EDIT FILE TO SET RUN_PATH
exit 1

# Get the list of designs
set RUN_PATH
set IMPORT_PATH=$RUN_PATH/IMPORTED_DESIGNS
set design_list=(`find $IMPORT_PATH/* -type d -prune -exec basename \{} .po \;`)

foreach design ($design_list)

	# Clear Outputs
	rm $RUN_PATH/IMPORTED_DESIGNS/$design/OUTPUT/*

	# Load Design Files
	set LIB_NAME=$design
	set LIB_FILLNAME="$LIB_NAME""_FILL"
	set STRM_FILE=`find $IMPORT_PATH/$design/* -prune -name "*gds"`
	set NAME_FILE=`find $IMPORT_PATH/$design/* -prune -name "*topcell" -printf "%f" | sed 's/.topcell//'`
	set CELL_FILE=`find $IMPORT_PATH/$design/* -prune -name "*map"`
	set LIB_FILE=`find $IMPORT_PATH/$design/* -prune -name "*reflib"`
	set LOG_FILE=$IMPORT_PATH/$design/OUTPUT/$design.strmin.log
	set LOG_FILL_FILE=$IMPORT_PATH/$design/OUTPUT/$design.fill.strmin.log
	set RULE_FILE=$IMPORT_PATH/$design/OUTPUT/$design.rules
	echo "Loading:" $STRM_FILE " For " $NAME_FILE > $LOG_FILE.import.report

	# Clear Lib Files
	set file_list=(`find $LIB_NAME/* -type d -prune -exec basename \{} .po \;`)
	if ( "$file_list" == "" || "$file_list" == "find: No match." ) then
		echo $LIB_NAME "Is empty or does not exist! Skipping..."
	else
		foreach file ($file_list)
			echo "Clearing $RUN_PATH/"$LIB_NAME/$file
			rm -rf $RUN_PATH/$LIB_NAME/$file
		end
	endif

	# Clear Fill Lib Files
	set file_list=(`find $LIB_FILLNAME/* -type d -prune -exec basename \{} .po \;`)
	if ( "$file_list" == "" || "$file_list" == "find: No match." ) then
		echo $LIB_FILLNAME "Is empty or does not exist! Skipping..."
	else
		foreach file ($file_list)
			echo "Clearing $RUN_PATH/"$LIB_FILLNAME/$file
			rm -rf $RUN_PATH/$LIB_FILLNAME/$file
		end
	endif

	# Run Checks
	if (!( -e "$STRM_FILE" ) || !( -e "$LIB_FILE" )) then
		echo $LIB_NAME "Does not contain a GDS/LIB FILE! Skipping..."
		continue
	endif

	if !( -e "$CELL_FILE" ) then
		echo "Warning! Missing Cell/Lib Mapping for" $LIB_NAME "... Importing Design Anyway..." >> $LOG_FILE.import.report
		set cmd_str="strmin -library $LIB_NAME -strmFile $STRM_FILE -attachTechFileOfLib tsmc18 -refLibList $LIB_FILE -logFile $LOG_FILE"
	else
		echo $LIB_NAME "Importing Design ..."
		set cmd_str="strmin -library $LIB_NAME -strmFile $STRM_FILE -attachTechFileOfLib tsmc18 -cellMap $CELL_FILE -refLibList $LIB_FILE -logFile $LOG_FILE"
	endif

	# echo $cmd_str
	$cmd_str

	sed -e '/tcb018bcdgp2a\|tcb018g3d3\|tcb018gbwp7t\|tcb018rfid\|tpa018nv\|tpb018v\|tpd018bcdnv5\|tpi018nv\|tps018bcdnv5/\!d' $LOG_FILE > $LOG_FILE.report

	cat $RUN_PATH/SAMPLE_Technology_Details.txt > $LOG_FILE.usedlibs.report
	grep -oh 'tcb018bcdgp2a\|tcb018g3d3\|tcb018gbwp7t\|tcb018rfid\|tpa018nv\|tpb018v\|tpd018bcdnv5\|tpi018nv\|tps018bcdnv5' $LOG_FILE.report | sort | uniq >> $LOG_FILE.usedlibs.report

	grep 'WARNING\|ERROR' $LOG_FILE >> $LOG_FILE.import.report
	if (`grep -q "ERROR" "$LOG_FILE"`) then
		echo "Import Failed! Exiting...."
		exit 1
	endif

	# Start Merge with LEF Cells
	$MGC_HOME/bin/calibredrv $RUN_PATH/Scripts/CalibreGDSMerge.tcl $STRM_FILE $RUN_PATH/Scripts/tps018bcdnv5_5lm.gds $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.IMPORT1.gds
	$MGC_HOME/bin/calibredrv $RUN_PATH/Scripts/CalibreGDSMerge.tcl $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.IMPORT1.gds $RUN_PATH/Scripts/tpd018bcdnv5_5lm.gds $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.IMPORT2.gds
	$MGC_HOME/bin/calibredrv $RUN_PATH/Scripts/CalibreGDSMerge.tcl $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.IMPORT2.gds $RUN_PATH/Scripts/tcb018gbwp7t_5lm.gds $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.IMPORT3.gds
	$MGC_HOME/bin/calibredrv $RUN_PATH/Scripts/CalibreGDSMerge.tcl $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.IMPORT3.gds $RUN_PATH/Scripts/tpb018v_5lm.gds  $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.IMPORT4.gds

	# Generate METAL DUMMY
	echo "" > $RULE_FILE
	echo "LAYOUT SYSTEM GDSII"  >> $RULE_FILE
	echo "LAYOUT PATH "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.IMPORT4.gds"\"""  >> $RULE_FILE
	echo "LAYOUT PRIMARY "\""$NAME_FILE"\""" >> $RULE_FILE
	echo "DRC RESULTS DATABASE "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.MDMY.gds"\"" GDSII " >> $RULE_FILE
	echo "DRC SUMMARY REPORT "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.MDMY.rep"\""" >> $RULE_FILE
	echo "LAYOUT INPUT EXCEPTION SEVERITY MISSING_REFERENCE 1" >> $RULE_FILE
	echo "" >> $RULE_FILE
	cat $RUN_PATH/Scripts/Dummy_Metal_Calibre_SAMPLE.214a >> $RULE_FILE
	calibre -drc -hier $RULE_FILE

	# Generate POLY DUMMY
	echo "" > $RULE_FILE
	echo "LAYOUT SYSTEM GDSII"  >> $RULE_FILE
	echo "LAYOUT PATH "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.IMPORT4.gds"\"""  >> $RULE_FILE
	echo "LAYOUT PRIMARY "\""$NAME_FILE"\""" >> $RULE_FILE
	echo "DRC RESULTS DATABASE "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.PDMY.gds"\"" GDSII " >> $RULE_FILE
	echo "DRC SUMMARY REPORT "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.PDMY.rep"\""" >> $RULE_FILE
	echo "LAYOUT INPUT EXCEPTION SEVERITY MISSING_REFERENCE 1" >> $RULE_FILE
	echo "" >> $RULE_FILE
	cat $RUN_PATH/Scripts/Dummy_OD_PO_Calibre_SAMPLE.210a >> $RULE_FILE
	calibre -drc -hier $RULE_FILE

	# MERGE WITH DUMMY STRUCTURES
	$MGC_HOME/bin/calibredrv $RUN_PATH/Scripts/CalibreGDSMerge.tcl $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.PDMY.gds $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.MDMY.gds $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.IMPORT5.gds
	$MGC_HOME/bin/calibredrv $RUN_PATH/Scripts/CalibreGDSMerge.tcl $STRM_FILE $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.IMPORT5.gds $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.FILL.gds

	echo "Starting Design Checks:"
	echo "" > $RULE_FILE
	echo "LAYOUT SYSTEM GDSII"  >> $RULE_FILE
	echo "LAYOUT PATH "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.FILL.gds"\"""  >> $RULE_FILE
	echo "LAYOUT PRIMARY "\""$NAME_FILE"\""" >> $RULE_FILE
	echo "DRC RESULTS DATABASE "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.DRC_RES.db"\""" >> $RULE_FILE
	echo "DRC SUMMARY REPORT "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.DRC.rep"\""" >> $RULE_FILE
	echo "LAYOUT INPUT EXCEPTION SEVERITY MISSING_REFERENCE 1" >> $RULE_FILE
	cat $RUN_PATH/Scripts/SAMPLE_calibre.drc >> $RULE_FILE
	calibre -drc -hier $RULE_FILE
	grep -E 'TOTAL Result Count = [1-9][0-9]{0,7}' $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.DRC.rep > $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.DRC.summary

	echo "" > $RULE_FILE
	echo "LAYOUT SYSTEM GDSII"  >> $RULE_FILE
	echo "LAYOUT PATH "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.FILL.gds"\"""  >> $RULE_FILE
	echo "LAYOUT PRIMARY "\""$NAME_FILE"\""" >> $RULE_FILE
	echo "DRC RESULTS DATABASE "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.ANT_RES.db"\""" >> $RULE_FILE
	echo "DRC SUMMARY REPORT "\""$IMPORT_PATH/$design/OUTPUT/$NAME_FILE.ANT.rep"\""" >> $RULE_FILE
	echo "LAYOUT INPUT EXCEPTION SEVERITY MISSING_REFERENCE 1" >> $RULE_FILE
	cat $RUN_PATH/Scripts/SAMPLE_ant.drc >> $RULE_FILE
	calibre -drc -hier $RULE_FILE
	grep -E 'TOTAL Result Count = [1-9][0-9]{0,7}' $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.ANT.rep > $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.ANT.summary

	if !( -e "$CELL_FILE" ) then
		echo "Warning! Missing Cell/Lib Mapping for" $LIB_NAME "... Importing Design Anyway..." >> $LOG_FILE.import.report
		set cmd_str="strmin -library $LIB_FILLNAME -strmFile $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.FILL.gds -attachTechFileOfLib tsmc18 -refLibList $LIB_FILE -logFile $LOG_FILL_FILE"
	else
		echo $LIB_NAME "Importing Design ..."
		set cmd_str="strmin -library $LIB_FILLNAME -strmFile $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.FILL.gds -attachTechFileOfLib tsmc18 -cellMap $CELL_FILE -refLibList $LIB_FILE -logFile $LOG_FILL_FILE"
	endif

	$cmd_str

	grep 'WARNING\|ERROR' $LOG_FILL_FILE >> $LOG_FILL_FILE.import.report
	if (`grep -q "ERROR" "$LOG_FILL_FILE"`) then
		echo "Import Failed! Exiting...."
		exit 1
	endif

	echo "" > $RULE_FILE

	tar -czvf $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.tar.gz  $IMPORT_PATH/$design/submission.info $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.ANT.summary $IMPORT_PATH/$design/OUTPUT/$NAME_FILE.DRC.summary $LOG_FILE.usedlibs.report $LOG_FILE.import.report $LOG_FILL_FILE.import.report $IMPORT_PATH/$design/$NAME_FILE.topcell $LIB_FILE

end

cat $RUN_PATH/IMPORTED_DESIGNS/*/OUTPUT/*used* | sort | uniq
