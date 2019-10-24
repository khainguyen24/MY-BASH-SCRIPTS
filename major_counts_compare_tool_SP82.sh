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
    PREFIX_LIST=$1
    BI2R_INPUT_FILE=$2
    I2AR_INPUT_FILE=$3
    OUTPUT_FILE=$4
fi

#user message this may take some time depending on file size
echo "Working on it..may take some time depending on size of file.. hang tight.."

# function to grep using the prefix list (or should this funtion need to go line by line?)
function totalCount () {
        PREFIX_LIST=$1
        BI2R_INPUT_FILE=$2
        I2AR_INPUT_FILE=$3
        OUTPUT_FILE=$4
        #this is over kill.. gonna change it to just a simple cat $I2AR_INPUT_FILE | wc -l)
        #on second thought it was useful showing that matchml didn't match
        I2ARTotal="$(grep -Ff $PREFIX_LIST $I2AR_INPUT_FILE | wc -l)"
        BI2RTotal="$(grep -Ff $PREFIX_LIST $BI2R_INPUT_FILE | wc -l)"
        BASENAME="$(basename $3 .txt)"

        #testing awk formatting (not totally nessacary but intresting to learn)
        #echo "Total_Counts:${BASENAME}: BI2R:$BI2RTotal  I2AR:$I2ARTotal" | awk -F" " ' BEGIN { print "============================================================" , printf "%-45s %-9s %-9s\n" $1,$2,$3 , print "============================================================" }' >>  $OUTPUT_FILE

        #print the first line in output file.. formatting using awk original line below
        echo "Total_Counts:\"${BASENAME}\" BI2R:$BI2RTotal  I2AR:$I2ARTotal" | awk '{ printf "%-45s %-9s %-9s\n" , $1,$2,$3 }' >>  $OUTPUT_FILE


}


#function to count each prefix in the file individually
function prefixCount () {
        PREFIX_LIST=$1
        BI2R_INPUT_FILE=$2
        I2AR_INPUT_FILE=$3
        OUTPUT_FILE=$4
        i=1
        COUNTER="$(cat $PREFIX_LIST | wc -l)"
        while (( i != (COUNTER+1)  ))
        do
        p="${i}p"
#Prefix count value for BI2R
        PREFIX_TYPE="$(cat $PREFIX_LIST | sed -n -e $p)"
        PREFIX_TYPE_COUNT_BI2R="$(cat $PREFIX_LIST | sed -n -e $p | xargs -i{} fgrep -i {} $BI2R_INPUT_FILE | wc -l)"

#Prefix count value for I2AR

        PREFIX_TYPE_COUNT_I2AR="$(cat $PREFIX_LIST | sed -n -e $p | xargs -i{} fgrep -i {} $I2AR_INPUT_FILE | wc -l)"
        #adding awk formatting to the output for readablity the original is commented out below:
        #echo "$PREFIX_TYPE BI2R:$PREFIX_TYPE_COUNT_BI2R  I2AR:$PREFIX_TYPE_COUNT_I2AR" >> $OUTPUT_FILE
        echo "$PREFIX_TYPE BI2R:$PREFIX_TYPE_COUNT_BI2R  I2AR:$PREFIX_TYPE_COUNT_I2AR" | awk '{ printf "%-45s %-9s %-9s\n" , $1,$2,$3 }' >> $OUTPUT_FILE
        ((i=i+1))
        # added just to test the value of echo "$i"
    done

}

# run stuff (need to figure out if i need to add these var for it to work or if it's just redundant)
totalCount $PREFIX_LIST  $BI2R_INPUT_FILE $I2AR_INPUT_FILE $OUTPUT_FILE
prefixCount $PREFIX_LIST $BI2R_INPUT_FILE $I2AR_INPUT_FILE $OUTPUT_FILE

echo
echo -e "Done processing: [ $PREFIX_LIST | $BI2R_INPUT_FILE | $I2AR_INPUT_FILE ] >> $OUTPUT_FILE"
echo -e "See $OUTPUT_FILE for the results.\n"

exit 0;
