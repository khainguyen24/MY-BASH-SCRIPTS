#!/bin/bash
#just adding some comments into this file from ATOM
# backing up all the files after BLK bid ingest.. ie hitting the "reset button"
#


# param
#Check to see if $1 parameter was specified extracted BLKBID_FOLDER example 2019-12-04"
if [ -z "$1" ]
then
    echo -e "\nMissing parameter...exiting.\n"
    echo "How to use this script:"
    echo "./reset_button_BLK_BID_SP85.sh <BLKBID_FOLDER> <SP##>"
    echo -e "\nExample:"
    echo "./reset_button_BLK_BID_SP85.sh 2019-12-04 SP85"
    echo -e "\n"
    exit 1;

else

    BLKBID_FOLDER=$1
fi

##Check to see if $2 parameter was specified. required.. ie "SP85"
if [ -z "$2" ]
then
    echo -e "\nMissing parameter...exiting.\n"
    echo "How to use this script:"
    echo "./reset_button_BLK_BID_SP85.sh <BLKBID_FOLDER> <SP##>"
    echo -e "\nExample:"
    echo "./reset_button_BLK_BID_SP85.sh 2019-12-04 SP85"
    echo -e "\n"
    exit 1;

else

    BUILD_NUMBER=$2
    BACKUP_STRING='_Blk_Bid_post-processing_backup'
    BACKUP_DIR="$BACKUP_STRING"
    BASE_DIR=/var/ #change this to where you want the backup directory to be
fi

date="$(date +%F)"



# move all the files created that day

function BULK-INGEST_Backup () {
