#!/bin/bash
# script to count the BI2R pre-split data type file .ie .."attachments" and a file count for I2AR post-split

# Script takes these required inputs parameters:
#       1. (Required) filename for BI2R pre-split data type
#       2. (Required) directory name that holds the post-split individual files for the data type


#parameters check (Script calls for 2 parameters to be passed in)
if [ "$#" -ne 2 ]
then
    echo -e "\nMissing parameter...exiting.\n"
    echo "How to use this script:"
    echo "./split_file_count.sh <BI2R pre-split data type file> <I2AR directory containing the post-split files>"
    echo -e "\nExample:"
    echo "./split_file_count.sh identity_attribute_export.xml attributes"
    echo -e "\n"
    exit 1;

else
    BI2R_EXPORT=$1
    I2AR_IMPORT=$2
    sleep 1
    echo "$BI2R_EXPORT"
    echo "$I2AR_IMPORT"

fi


#funtion to get the counts

function GET_SPLIT_COUNTS () {
  BI2R_EXPORT=$1
  I2AR_IMPORT=$2
  #set the BIR path to files
  echo
  echo "************************ RESULTS: BI2R pre-split vs. I2AR post-split *********************************"
  echo "*****************************************************************************************************"
  BI2R_EXPORT_SPLIT_FILE_PATH="$(find /var/ -type f -name $BI2R_EXPORT)"
  BIR_PRE_SPLIT_COUNT="$(grep I2AR:begin $BI2R_EXPORT_SPLIT_FILE_PATH | wc -l)"
  echo "BI2R pre-split  Count: [$BIR_PRE_SPLIT_COUNT] for \"$BI2R_EXPORT_SPLIT_FILE_PATH\""
  #set the I2AR path to the directory
  I2AR_IMPORT_POST_SPLIT_DIR_PATH="$(find /var/i2ar/archive/ -type d -name $I2AR_IMPORT)"
  I2AR_POST_SPLIT_FILE_COUNT="$(find $I2AR_IMPORT_POST_SPLIT_DIR_PATH -type f | wc -l)"
  echo "I2AR post-split Count: [$I2AR_POST_SPLIT_FILE_COUNT] for \"$I2AR_IMPORT_POST_SPLIT_DIR_PATH\""
}

# Run STUFF

GET_SPLIT_COUNTS $BI2R_EXPORT $I2AR_IMPORT
echo "All done! if the counts are off check the error or duplicate directories."
