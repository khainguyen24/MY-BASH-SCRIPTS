#!/bin/bash
# script to count individual files that make up the a particular Major Count .ie .."attachments_photos" count

# Script takes these required inputs parameters:
#       1. (Required) patterList file
#       2. (Required) BI2R_INPUT_FILE this is from the BI2R export_lists directory
#       3. (Required) I2AR_INPUT_FILE this is from the I2AR major-counts directory
#       4. (Required) Specified OUTPUT_FILE Name to hold the results

# CHANGE LOG
# 10/22/2019 note for the matchml major count i had to change to use fgrep (due to the grep looking for range [])
# 10/28/2019 added Major_count (row_count) as the first line in the output files
# 10/29/2019 added HELP MENU Option flag -h

#function to display Optional HELP MENU
#### HELP MENU OPTION START ##############################################################################
echo
function display_help_menu() {
	echo -e "
      \nThis script takes these required inputs parameters and will search both the BI2R and
      I2AR count files passed into it using each pattern row in the patternList file:
#       1. (Required) patterList file
#       2. (Required) BI2R_INPUT_FILE this is from the BI2R export_lists directory
#       3. (Required) I2AR_INPUT_FILE this is from the I2AR major-counts directory
#       4. (Required) Specified OUTPUT_FILE Name to hold the results
#
#       How to use this script:
#          ./major_counts_compare_tool.sh <patternList.txt> <BI2R_INPUT_FILE> <I2AR_INPUT_FILE> <outputfilename.txt>
#
#       Example:
#          ./major_counts_compare_tool.sh patternList.txt ATTACHMENTS_PHOTOS.TXT attachments_photos.txt outputfilename.txt
#
#       Determine what modification are require and Creating a patternList File to use with the script:
#       1. NOTE: The BI2R and I2AR count files that map to a particular major count may use different formatting
#          for the data in the count file. This will most definitely skewed the output results if not taken into account.
#          To prevent this you must determine whether any modification of the patternList file, BI2R file and/or the I2AR
#          file is necessary before running the major_counts_compare_tool.sh.
#
#       2. Make a copy of either the BI2R or the I2AR count file to be used as the patternList file for the script.
#          Typically you would want to select the file with the greater number of rows as the patternList file.
#          You can use this command on the count file to determine the number of rows contained in the count file:
#          Example: [ cat <BIR or I2AR count file> | wc -l ]
#
#       3. Using the list below determine what/if any modification and to which file is need for the particular major count.

atp_scores_compare
├── ATP_BIDS.TXT
└── atp_scores.txt

BIR ATP_BIDS.TXT uses "-" in the "B28JM-R3J9" where I2ar does not "B28JMR3J9".
Remove the dash in the ATP_BIDS.TXT and patternFile. Example: for testing: [sed 's/-//g' ATP_BIDS_dash_removed.TXT]
for real:[sed -i 's/-//g' ATP_BIDS_dash_removed.TXT]

attachments_photos_compare
├── attachments_photos.txt
└── ATTACHMENTS_PHOTOS.TXT

attributes_compare
├── attributes.txt
└── ATTRIBUTES.TXT

batcxi_records_total_compare
├── BATCXI_GUIDS.TXT
└── batcxi_records_total.txt

bat_records_total_compare
├── BAT_GUIDS.TXT
└── bat_records_total.txt

bids_identities_compare
├── bids_identities.txt
└── BIDS.TXT

comments_compare
├── comments.txt
└── COMMENTS.TXT

event_attachments_compare
├── event_attachments.txt
└── EVENT_ATTACHMENTS.TXT

event_comments_compare
├── event_comments.txt
└── EVENT_COMMENTS.TXT

event_encounters_compare
├── event_encounters.txt
└── EVENT_ENCOUNTERS.TXT

events_compare
├── events.txt
└── EVENTS.TXT

matchml_compare
├── EXPORTED_MATCHML.TXT
└── matchml.txt

nominated_to_watchlist_compare
├── nominated_to_watchlist.txt
└── NOMINATED_WATCHLISTED_BIDS.TXT

nonsensor_rir_compare
├── NONSENSOR_RIR_TCNS.TXT
└── nonsensor_rir.txt

nonsensor_uhn_compare
├── NONSENSOR_UHN_TCNS.TXT
└── nonsensor_uhn.txt

previously_watchlisted_compare
├── previously_watchlisted.txt
└── PREVIOUS_WATCHLISTED_BIDS.TXT

products_compare
├── products.txt
└── PRODUCTS.TXT

relationships_compare
├── RELAITONSHIPS.TXT
└── relationships.txt

sensor_total_compare
├── SENSORS.TXT
└── sensor_total.txt

total_identities_compare
├── 2019-10-29-bids_primary-post.txt
└── PRIMARY_BIDS.TXT

twpdes_compare
├── TWPDES_EXP.TXT
└── twpdes.txt

usp_active_records_compare
├── ACTIVE_USP_BIDS.TXT
└── usp_active_records.txt

usp_inactive_records_compare
├── INACTIVE_USP_BIDS.TXT
└── usp_inactive_records.txt

usp_purged_compare
├── PURGED_BIDS_UNIQUE.TXT
└── usp_purged.txt

usp_quarantined_compare
├── QUARANTINED_BIDS.TXT
└── usp_quarantined.txt

usp_threats_compare
├── THREAT_BIDS.TXT
└── usp_threats.txt

watchlisted_compare
├── WATCHLISTED_BIDS.TXT
└── watchlisted.txt

"
}

HELP_MENU=$(display_help_menu)
# Getopts option menu for display the HELP MENU with "-h"
while getopts "hf:" OPTION
do
	case $OPTION in
		h)
			echo "***************************************************"
			echo "      HELP MENU: major_counts_compare_tool.sh      "
			echo "***************************************************"
			echo "$HELP_MENU"
			echo "***************************************************"
			echo "                   - END -                          "
			echo "***************************************************"
			exit
			;;
		\?)
			echo "Used -h for the help menu"
			exit
			;;
	esac
done

#### HELP MENU OPTION END ##############################################################################

#parameters check (Script calls for 4 parameters to be passed in)
if [ "$#" -ne 4 ]
then
    echo -e "\nMissing parameter...exiting."
    echo -e "\nTo display the Help Menu use -h for help"
    echo -e "\nHow to use this script:"
    echo "./major_counts_compare_tool.sh <patternList.txt> <BI2R_INPUT_FILE> <I2AR_INPUT_FILE> <outputfilename.txt>"
    echo -e "\nExample:"
    echo "./major_counts_compare_tool.sh patternList.txt ATTACHMENTS_PHOTOS.TXT attachments_photos.txt outputfilename.txt"
    echo -e "\n"
    exit 1;

else
    PATTERN_LIST=$1
    BI2R_INPUT_FILE=$2
    I2AR_INPUT_FILE=$3
    OUTPUT_FILE=$4
fi

#user messege this may take some time depending on file size
echo "Working on it.. may take some time depending on size of file.. hang tight.."

# function to grep using the pattern list (or should this funtion need to go line by line?)
function totalCount () {
        PATTERN_LIST=$1
        BI2R_INPUT_FILE=$2
        I2AR_INPUT_FILE=$3
        OUTPUT_FILE=$4
        #this is over kill.. gonna change it to just a simple cat $I2AR_INPUT_FILE | wc -l)
        #on second thought it was useful showing that matchml didn't match.. total counts using the pattern file passed in to the script.
        I2ARTotal="$(grep -Ff $PATTERN_LIST $I2AR_INPUT_FILE | wc -l)"
        BI2RTotal="$(grep -Ff $PATTERN_LIST $BI2R_INPUT_FILE | wc -l)"
        BASENAME="$(basename $3 .txt)"
        #row count variables (just a simple row count of BIR and I2AR count files)
        BI2R_ROW_COUNT_TOTAL="$(cat $BI2R_INPUT_FILE | wc -l)"
        I2AR_ROW_COUNT_TOTAL="$(cat $I2AR_INPUT_FILE | wc -l)"

        #testing awk formatting (not totally nessacary but intresting to learn)
				# formatting variables for the first column in the output file. Maybe create a variables from the length of the first row in the pattern file and set it,
				# pass the variables into awk to use as value in 50s the awk '{ printf "%-50s %-9s %-9s\n"
				#COLUMN_LENGTH=50
				#GET_COLUMN_LENGTH="$()"
        #echo "Total_Counts:${BASENAME}: BI2R:$BI2RTotal  I2AR:$I2ARTotal" | awk -F" " ' BEGIN { print "============================================================" , printf "%-45s %-9s %-9s\n" $1,$2,$3 , print "============================================================" }' >>  $OUTPUT_FILE
        # getting the row count from the count files (should correspond to the major count numbers)
        echo "MAJOR_COUNTS_(row):\"${BASENAME}\" BI2R:$BI2R_ROW_COUNT_TOTAL  I2AR:$I2AR_ROW_COUNT_TOTAL" | awk '{ printf "%-50s %-9s %-9s\n" , $1,$2,$3 }' >>  $OUTPUT_FILE

        #print the second line in output file.. formatting using awk original line below can change spacing with these values "%-45s %-9s %-9s\n"
        echo "TOTAL_COUNTS_(pattern):\"${BASENAME}\" BI2R:$BI2RTotal  I2AR:$I2ARTotal" | awk '{ printf "%-50s %-9s %-9s\n" , $1,$2,$3 }' >>  $OUTPUT_FILE


}


#function to count each pattern in the file individually
function patternCount () {
        PATTERN_LIST=$1
        BI2R_INPUT_FILE=$2
        I2AR_INPUT_FILE=$3
        OUTPUT_FILE=$4
        i=1
        COUNTER="$(cat $PATTERN_LIST | wc -l)"
        while (( i != (COUNTER+1)  ))
        do
        p="${i}p"
#Prefix count value for BI2R
        PATTERN_TYPE="$(cat $PATTERN_LIST | sed -n -e $p)"
        PATTERN_TYPE_COUNT_BI2R="$(cat $PATTERN_LIST | sed -n -e $p | xargs -i{} fgrep -i {} $BI2R_INPUT_FILE | wc -l)"

#Prefix count value for I2AR

        PATTERN_TYPE_COUNT_I2AR="$(cat $PATTERN_LIST | sed -n -e $p | xargs -i{} fgrep -i {} $I2AR_INPUT_FILE | wc -l)"
        #adding awk formatting to the output for readablity the original is commented out below:
        #echo "$PATTERN_TYPE BI2R:$PATTERN_TYPE_COUNT_BI2R  I2AR:$PATTERN_TYPE_COUNT_I2AR" >> $OUTPUT_FILE
        echo "$PATTERN_TYPE BI2R:$PATTERN_TYPE_COUNT_BI2R  I2AR:$PATTERN_TYPE_COUNT_I2AR" | awk '{ printf "%-50s %-9s %-9s\n" , $1,$2,$3 }' >> $OUTPUT_FILE
        ((i=i+1))
        # added just to test the value of echo "$i"
    done

}

# run stuff (need to figure out if i need to add these var for it to work or if it's just redundant)
totalCount $PATTERN_LIST  $BI2R_INPUT_FILE $I2AR_INPUT_FILE $OUTPUT_FILE
patternCount $PATTERN_LIST $BI2R_INPUT_FILE $I2AR_INPUT_FILE $OUTPUT_FILE

echo
echo -e "Done processing: [ $PATTERN_LIST | $BI2R_INPUT_FILE | $I2AR_INPUT_FILE ] >> $OUTPUT_FILE"
echo -e "See $OUTPUT_FILE for the results.\n"

exit 0;
