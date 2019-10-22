#!/bin/bash
#just adding some comments into this file from ATOM
# backing up all the files after BLK bid ingest.. ie hitting the "reset button"
#


# param
#Check to see if $1 parameter was specified the 7th column was specified as the awk pattern to use in the script"

if [ -z "$1" ]
then
    echo -e "\nMissing parameter...exiting.\n"
    echo "How to use this script:"
    echo "./reset_button_BLK_BID_SP82.sh <the 2 digit day format \"DD\"> <SP*#>"
    echo -e "\nExample:"
    echo "./reset_button_BLK_BID_SP82.sh 15 SP82"
    echo -e "\n"
    exit 1;

else

    DATE_VALUE=$1
fi

##Check to see if $2 parameter was specified. required.. ie "SP82"
if [ -z "$2" ]
then
    echo -e "\nMissing parameter...exiting.\n"
    echo "How to use this script:"
    echo "./reset_button_BLK_BID_SP82.sh <the 2 digit day format \"DD\"> <SP*#>"
    echo -e "\nExample:"
    echo "./reset_button_BLK_BID_SP82.sh 15 SP82"
    echo -e "\n"
    exit 1;

else

    BUILD_NUMBER=$2
    BACKUP_STRING='_Blk_Bid_post-processing_backup'
    BACKUP_DIR="$BUILD_NUMBER$BACKUP_STRING"
fi

date="$(date +%F)"



# move all the files created that day

function backup_BLK_BID_Post_processing () {
	DATE_VALUE=$1
	BUILD_NUMBER=$2
    BACKUP_STRING='_Blk_Bid_post-processing_backup'
    BACKUP_DIR="$BUILD_NUMBER$BACKUP_STRING"
    echo $DATE_VALUE
	echo $BUILD_NUMBER
	echo $BACKUP_STRING
	echo $BACKUP_DIR
	mkdir -p /var/webadmin/automated_Import_Scripts/$BACKUP_DIR
	#ll /var/i2ar/temp_khai/ | awk -v DATE_VALUE="$DATE_VALUE" -v BACKUP_DIR="$BACKUP_DIR" '$7=={print DATE_VALUE}{print "mv",$9,"/var/webadmin/automated_Import_Scripts/{print BACKUP_DIR}"}' | sh -x
	ls -l /var/i2ar/temp_khai/ | grep -i -Z -r -l '${DATE_VALUE}' | xargs -I{} mv {} /var/webadmin/automated_Import_Scripts/${BACKUP_DIR}
	sleep 1

}

#Run stuff
backup_BLK_BID_Post_processing $DATE_VALUE $BUILD_NUMBER
echo "all done.. BLK BID post processing files backed up to: /var/webadmin/automated_Import_Scripts/$BACKUP_DIR"

exit 0;
