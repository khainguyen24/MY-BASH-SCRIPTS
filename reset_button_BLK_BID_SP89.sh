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

function backup_BLK_BID_Post_processing () {
	  BUILD_NUMBER=$2
    BACKUP_STRING='Blk_Bid_post-processing_backup_'
    BACKUP_DIR="$BACKUP_STRING${BUILD_NUMBER}_${date}"
    AUTOMATED_SCRIPT_DIR=/var/webadmin/automated_Import_Scripts/ #update to the correct path for automated_Import_Scripts dir
    MODULES_MAIN_DIR=/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/
# creating backup dir(update with the correct path to the post-processing files) with appeded build and date
  echo "Creating the backup directory.."
  sleep 1
  mkdir -p /var/$BACKUP_DIR #update to the correct backup path dir
  FULL_PATH_DIR="$BASE_DIR${BACKUP_DIR}/"
	# testing various ways to move the backup files.. didn't work so commented it out for now
  #ll /var/i2ar/temp_khai/ | awk -v DATE_VALUE="$DATE_VALUE" -v BACKUP_DIR="$BACKUP_DIR" '$7=={print DATE_VALUE}{print "mv",$9,"/var/webadmin/automated_Import_Scripts/{print BACKUP_DIR}"}' | sh -x
	#ls -l /var/i2ar/temp_khai/ | grep -i -Z -r -l '${DATE_VALUE}' | xargs -I{} mv {} /var/webadmin/automated_Import_Scripts/${BACKUP_DIR}
  # ll | awk '$7==15{print "cp -rp" , $9 , "/root/my_fedora_folder/post-processing-bak"}' (this worked on the command line.. need to add the | sh -x to make it stick)
  # ls -l /var/i2ar/temp_khai/ | grep -i -Z -r -l '${DATE_VALUE}' | xargs -I{} mv {} /var/webadmin/automated_Import_Scripts/${BACKUP_DIR}
  # worked! ls -l /root/my_fedora_folder/DV-53-majorCount/* | awk '$7==15{print "cp" , $9 , "/root/my_fedora_folder/Blk_Bid_post-processing_backup_SP82_2019-10-25"}' | sh -x
  #ls -l "/root/my_fedora_folder/DV-53-majorCount/"* | awk -v DATE_VALUE="$DATE_VALUE" -v BASE_DIR="$BASE_DIR" -v FULL_PATH_DIR="$FULL_PATH_DIR" -v BACKUP_DIR="$BACKUP_DIR" '$7==DATE_VALUE{ print  "cp -rp", $9 ,FULL_PATH_DIR}' | sh -x
  echo "Moving all the BLK BID post processing files now.."
  sleep 2
  # command to move the BLKBID_FOLDER TO THE backup dir.
  mv ${AUTOMATED_SCRIPT_DIR}${BLKBID_FOLDER} ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}*bid_export_counts.txt ${FULL_PATH_DIR}
  # mv ${AUTOMATED_SCRIPT_DIR}*bid_mappings-primary_bids.txt ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}*bids_primary-post.txt ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}*entityIndex.txt ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}*error.summary.txt ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}*export.results ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}*export.results.raw ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}*final_primary-bids.txt ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}*scanKeys.txt ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}*scanned-bids.txt ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}i2ar-results.csv ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}*ingest-export-debug.log ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}*ingest-export.log ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}major-counts* ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}nohup.out ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}reindexer.log ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}reindexer-profiling.csv ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}reindexer-profiling.html ${FULL_PATH_DIR}
  mv ${AUTOMATED_SCRIPT_DIR}logs ${FULL_PATH_DIR}
  sleep 1
  # command to backup the properties files in ~/modules/main directory MODULES_MAIN_DIR
  echo "Moving all the properties files from ~/biometrics/resources/main directory.."
  mv ${MODULES_MAIN_DIR}agencyOriMap.xml.15* ${FULL_PATH_DIR}
  mv ${MODULES_MAIN_DIR}data-source-normalization.xml.15* ${FULL_PATH_DIR}
  mv ${MODULES_MAIN_DIR}masking-rules.xml.15* ${FULL_PATH_DIR}
  mv ${MODULES_MAIN_DIR}usp-rules.xml.15* ${FULL_PATH_DIR}

  sleep 1

}

#Run stuff
backup_BLK_BID_Post_processing $BLKBID_FOLDER $BUILD_NUMBER
echo "all done.. BLK BID post processing files backed up to: /var/$BACKUP_DIR"

exit 0;
