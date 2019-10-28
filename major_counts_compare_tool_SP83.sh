#!/bin/bash
# script to count individual files that make up the a particular Major Count .ie .."attachments_photos" count

# Script takes these required inputs parameters:
#       1. (Required) patterList file
#       2. (Required) BI2R_INPUT_FILE this is from the BI2R export_lists directory
#       3. (Required) I2AR_INPUT_FILE this is from the I2AR major-counts directory
#       4. (Required) Specified OUTPUT_FILE Name to hold the results

#note for the matchml major count i had to change to use fgrep (due to the grep looking for range [])

#parameters check (Script calls for 4 parameters to be passed in)
if [ "$#" -ne 4 ]
then
    echo -e "\nMissing parameter...exiting.\n"
    echo "How to use this script:"
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
        #echo "Total_Counts:${BASENAME}: BI2R:$BI2RTotal  I2AR:$I2ARTotal" | awk -F" " ' BEGIN { print "============================================================" , printf "%-45s %-9s %-9s\n" $1,$2,$3 , print "============================================================" }' >>  $OUTPUT_FILE
        # getting the row count from the count files (should correspond to the major count numbers)
        echo "Major_Counts_(row_count):\"${BASENAME}\" BI2R:$BI2R_ROW_COUNT_TOTAL  I2AR:$I2AR_ROW_COUNT_TOTAL" | awk '{ printf "%-50s %-9s %-9s\n" , $1,$2,$3 }' >>  $OUTPUT_FILE

        #print the second line in output file.. formatting using awk original line below can change spacing with these values "%-45s %-9s %-9s\n"
        echo "Total_Counts_(pattern_count):\"${BASENAME}\" BI2R:$BI2RTotal  I2AR:$I2ARTotal" | awk '{ printf "%-50s %-9s %-9s\n" , $1,$2,$3 }' >>  $OUTPUT_FILE


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
