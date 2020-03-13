#!/bin/bash
# script to count the BI2R pre-split data type file .ie .."attachments" and a file count for I2AR post-split

# Script takes these required inputs parameters:
#       1. (Required) filename for BI2R pre-split data type
#       2. (Required) directory name that holds the post-split individual files for the data type.

# Change log
# 3/12/2020 - updated the APENDIX A and B (added new data type that are now exported and ingested) Updated the help menu with a TIP.

#### HELP MENU OPTION START ##############################################################################
echo
function display_help_menu() {
	echo -e "
      \nThis script takes these required inputs parameters and will count the pre-split BI2R Export file and the post-split
      I2AR Import directory passed into it.
#       1. (Required) BI2R pre-split filename (check Appendix A)
#       2. (Required) I2AR post-split root directory containing the post-split files (check Appendix B)
#
#      How to use this script:
       ./split_file_count.sh <BI2R pre-split data type file - Appendix A> <I2AR directory containing the post-split files - Appendix B>

       Example:
      ./split_file_count.sh identity_attribute_export.xml attributes

			TIP: to display just the pre-split files and the post-split subdirectories
			./split_file_count.sh -h | grep \*

			NOTE: For data types that are directly ingested (do not require splitting)... Use the "direct_export_import_count.sh"
#      Using the Appendix below to locate the pre-split data type file within the Export.
#      Locate the root Import directory containing the post-split files and directories
#      Note: files that require split is denoted with an asterisk *

\e[32m*****************************************************
**** APENDIX A - BI2R Export Directory Structure ****
*****************************************************
├── aims
│   ├── AIM1
│   └── IMG1
├── aims_additional_data
│   └── aims_additional_data_export.xml *
├── atpDetails
│   └── identity_atp_score_export.xml *
├── attachments
│   └── IMG1
├── attributes
│   └── identity_attribute_export.xml *
├── bat_attachments
│   └── ATT_2_1
├── batcxi_attachments
│   └── ATT_JOB3_1
├── batcxi_photos
│   └── IMG_JOB3_1
├── batcxiRptAnalystNotes
│   └── batcxi_rpt_analystnotes_export.xml * (not ready for ingest)
├── batcxi_rr_attachments
│   └── attachments
│       ├── ACT1
│       ├── EVT1
│       ├── FAC1
│       ├── INTR1
│       ├── ORG1
│       ├── PROJ1
│       ├── RFI1
│       ├── RPT1
│       ├── RQT1
│       ├── TACT1
│       ├── TECH1
│       └── TPORT1
├── batcxi_rr_photos
│   └── COMM1
├── batcxi_xml
│   ├── DB1
│   ├── TH_JOB0_1
│   └── UP1
├── bat_photos
│   └── IMG_1_1
├── batRptAnalystNotes
│   └── bat_rpt_analystnotes_export.xml * (not ready for ingest)
├── bat_rr_attachments
│   └── attachments
│       ├── ACT1
│       ├── EVT1
│       ├── FAC1
│       ├── INTR1
│       ├── ORG1
│       ├── PROJ1
│       ├── TACT1
│       ├── TECH1
│       └── TPORT1
├── bat_rr_photos
│   └── INTR1
├── bat_xml
│   ├── DB1
│   ├── TH_JOB0_1
│   └── UP1
├── bewl
│   └── bewl_export_data.xml *
├──  bewl_cr
│   └── bewl_cr_export_data.xml *
├──  bewl_cr_history
│   └── bewl_cr_history_export_data.xml *
├── bewl_history
│   ├── bewl_history.xml *
│   └── bewl_delete_history_record.xml *
├── bi2r-j (by default contains ‘MatchML by Bids’)
│   ├── bi2r-sensors
│   │   ├── MF1
│   │   └── UA1
│   ├── I2D-sensors
│   └── ss-sensors
├── bi2r-s (by default contains ‘MatchML by Bids’)
│   ├── abis-attachments
│   │   └── IMG_JOB1_1
│   ├── abis-sensors
│   │   └── MF1
│   ├── bi2r-attachments
│   │   └── IMG_JOB1_1
│   ├── bi2r-sensors
│   │   ├── MF1
│   │   └── UA1
│   ├── I2D-attachments
│   │   └── IMG_JOB1_1
│   ├── I2D-sensors
│   │   └── MF1
│   ├── ss-attachments
│   │   └── IMG_JOB1_1
│   └── ss-sensors
│       └── MF1
├── bids
├── datamasking_rules
├── deconflict_attachments
│   ├── attachments
│   │   └── IMG1
│   └── drivers
│       └── IMG1
├── deconfliction_trackers
│   └── deconfliction_tracker_export.xml * (ready for ingest as of SP90)
├── efts_attachments
│   └── ATT_4_1
├── encounters
│   └── UA1
├── events
│   ├── attachments
│   │   └── ATT1
│   ├── comments
│   │   └── COM1
│   ├── encounters
│   │   └── ENC1
│   └── EVT1
├── export_lists (contains BIR count files)
├── harmony
│   └── harmony_links_data_export.xml *
├── identityCrosslinks
├── identityHistory
│   └── identity_history_export.xml * (ready for ingest as of SP90)
├── identityMasks
│   └── identity_mask_data_export.xml *
├── identityMerges
│   └── identity_link_export.xml *
├── identityRelationships
│   └── identity_relationship_export.xml *
├── idml
│   └── IDML1
├── link_transactions
├── lov
│   ├── agency_data
│   ├── attribute
│   ├── bewl
│   └── deconflict_analyst
├── misc
├── mml-archive (contains 'Normal' matchML not ready as of SP90)
│   ├── bi2r-j
│   │   ├── I2D-sensors
│   │   └── ss-sensors
│   └── bi2r-s
│       ├── abis-sensors
│       │   └── MF1
│       ├── I2D-sensors
│       │   └── MF1
│       └── ss-sensors
│           └── MF1
├── nonsensor_matchml
│   ├── rir
│   │   └── RIR1
│   └── uhn
│       └── UHN1
├── photos
│   └── IMG1
├── primaryName
│   └── identity_primary_name_export.xml *
├── primaryPhoto
│   └── identity_primary_photo_export.xml *
├── product
│   └── PROD1
├── product_attachments
│   └── PRODATT1
├── related_reports
│   ├── AC1
│   ├── CE1
│   ├── COM1
│   ├── EV1
│   ├── FAC1
│   ├── INTN1
│   ├── INTR1
│   ├── ORG1
│   ├── PROD1
│   ├── PROJ1
│   ├── REQ1
│   ├── RFI1
│   ├── RPT1
│   ├── TECH1
│   ├── TRNS1
│   └── TRNSP1
├── socom
│   └── socom_export.xml *
├── sourceComments
│   └── identity_comments_data_export.xml *
├── twpdes
│   └── TWP1
├── twpdes_deletes
├── usp_rules
└── uspTrackerData
    └── us_person_data.xml *
 \e[0m

\e[35m*****************************************************
**** APENDIX B - I2AR Import Directory Structure ****
*****************************************************
├── aims
│   ├── attachments
│   │   ├── AIM1
│   │   └── IMG1
│   └── drivers
│       ├── AIM1
│       └── IMG1
├── aims_additional_data *
│   └── <files within subdirectories>
├── atpDetails *
│   └── <files within subdirectories>
├── attributes *
│   └──  <files within subdirectories>
├── bat_attachments
│   ├── attachments
│   │   └── ATT_2_1
│   └── drivers
│       └── ATT_2_1
├── batcxi_attachments
│   ├── attachments
│   │   └── ATT_JOB3_1
│   └── drivers
│       └── ATT_JOB3_1
├── batcxi_photos
│   ├── attachments
│   │   └── IMG_JOB3_1
│   └── drivers
│       └── IMG_JOB3_1
├── batcxi_rr_attachments
│   ├── attachments
│   │   ├── ACT1
│   │   ├── EVT1
│   │   ├── FAC1
│   │   ├── INTR1
│   │   ├── ORG1
│   │   ├── PROJ1
│   │   ├── RFI1
│   │   ├── RPT1
│   │   ├── RQT1
│   │   ├── TACT1
│   │   ├── TECH1
│   │   └── TPORT1
│   └── drivers
│       ├── ACT1
│       ├── EVT1
│       ├── FAC1
│       ├── INTR1
│       ├── ORG1
│       ├── PROJ1
│       ├── RFI1
│       ├── RPT1
│       ├── RQT1
│       ├── TACT1
│       ├── TECH1
│       └── TPORT1
├── batcxi_rr_photos
│   ├── attachments
│   │   └── COMM1
│   └── drivers
│       └── COMM1
├── batcxi_xml
│   ├── DB1
│   ├── TH_JOB0_1
│   └── UP1
├── bat_photos
│   ├── attachments
│   │   └── IMG_1_1
│   └── drivers
│       └── IMG_1_1
├── bat_rr_attachments
│   ├── attachments
│   │   ├── ACT1
│   │   ├── EVT1
│   │   ├── FAC1
│   │   ├── INTR1
│   │   ├── ORG1
│   │   ├── PROJ1
│   │   ├── TACT1
│   │   ├── TECH1
│   │   └── TPORT1
│   └── drivers
│       ├── ACT1
│       ├── EVT1
│       ├── FAC1
│       ├── INTR1
│       ├── ORG1
│       ├── PROJ1
│       ├── TACT1
│       ├── TECH1
│       └── TPORT1
├── bat_rr_photos
│   ├── attachments
│   │   └── INTR1
│   └── drivers
│       └── INTR1
├── bat_xml
│   ├── DB1
│   ├── TH_JOB0_1
│   └── UP1
├── bi2r-j (by default contains ‘MatchML by Bids’)
│   └── bi2r-sensors
│       ├── MF1
│       └── UA1
├── bi2r-s (by default contains ‘MatchML by Bids’)
│   ├── abis-attachments
│   │   └── IMG_JOB1_1
│   ├── abis-sensors
│   │   └── MF1
│   ├── bi2r-attachments
│   │   └── IMG_JOB1_1
│   ├── bi2r-sensors
│   │   ├── MF1
│   │   └── UA1
│   ├── I2D-attachments
│   │   └── IMG_JOB1_1
│   ├── I2D-sensors
│   │   └── MF1
│   ├── ss-attachments
│   │   └── IMG_JOB1_1
│   └── ss-sensors
│       └── MF1
├── deconflict_attachments (currently not ready)
├── deconfliction_trackers *
│   └──  <files within subdirectories>
├── efts_attachments
│   ├── attachments
│   │   └── ATT_4_1
│   └── drivers
│       └── ATT_4_1
├── encounters
│   └── UA1
├── eventAttachments
│   ├── attachments
│   │   └── ATT1
│   └── drivers
│       └── ATT1
├── eventComments
│   └── COM1
├── eventEncounters
│   └── ENC1
├── events
│   └── EVT1
├── harmony *
│   └── <files within subdirectories>
├── identity_comments *
│   └── <files within subdirectories>
├── identityCrosslinks
│   └── <files within subdirectories>
├── identityEdits-identity_merge *
│   └── <files within subdirectories>
├── identityEdits-identity_relationships *
│   └── <files within subdirectories>
├── identityHistory *
│   └── <files within subdirectories>
├── identityMasks *
│   └── <files within subdirectories>
├── identitySetPrimary-name *
│   └── <files within subdirectories>
├── identitySetPrimary-photo *
│   └── <files within subdirectories>
├── link_transactions
├── product
│   ├── attachments
│   │   └── PROD1
│   └── drivers
│       └── PROD1
├── product_attachments
│   ├── attachments
│   │   └── PRODATT1
│   └── drivers
│       └── PRODATT1
├── related_reports
│   ├── AC1
│   ├── CE1
│   ├── COM1
│   ├── EV1
│   ├── FAC1
│   ├── INTN1
│   ├── INTR1
│   ├── ORG1
│   ├── PROD1
│   ├── PROJ1
│   ├── REQ1
│   ├── RFI1
│   ├── TECH1
│   ├── TRNS1
│   └── TRNSP1
├── rir
│   └── RIR1
├── socom *
│   └── <files within subdirectories>
├── twpdes
│   └── TWP1
├── twpdes_deletes
├── uhn
│   └── UHN1
├── userAddedAttachments
│   ├── attachments
│   │   └── IMG1
│   └── drivers
│       └── IMG1
├── userAddedPhotos
│   ├── attachments
│   │   └── IMG1
│   └── drivers
│       └── IMG1
├── uspTrackerData *
│   └── <files within subdirectories>
├── watchlist-changeRequests *
│   └── <files within subdirectories>
├── watchlist-changeRequests_history *
│   └── <files within subdirectories>
├── watchlistEntries-bewl *
│   └── <files within subdirectories>
├── watchlistEntries-bewl_history *
│   └── <files within subdirectories>
└── watchlistEntries-bewl_history-deletes *
    └── <files within subdirectories>
\e[0m
"
}

HELP_MENU=$(display_help_menu)
# Getopts option menu for display the HELP MENU with "-h"
while getopts "hf:" OPTION
do
	case $OPTION in
		h)
			echo "***************************************************"
			echo "      HELP MENU: split_file_count.sh      "
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


#parameters check (Script calls for 2 parameters to be passed in)
if [ "$#" -ne 2 ]
then
    echo -e "\nMissing parameter...exiting. NOTE: Use the -h flag to see the help menu and Appendix A and B\n"
    echo "How to use this script:"
    echo "./split_file_count.sh <BI2R pre-split data type file> <I2AR directory containing the post-split files>"
    echo -e "\nExample:"
    echo "./split_file_count.sh identity_attribute_export.xml attributes"
    echo -e "\n"
		echo -e "TIP: to display just the pre-split files and the post-split subdirectories"
		echo -e "./split_file_count.sh -h | grep \*"
		echo -e "\n"
		echo -e "NOTE: For data types that are directly ingested (do not require splitting)... Use the \"direct_export_import_count.sh\""
		echo -e "\n"
    exit 1;

else
    BI2R_EXPORT=$1
    I2AR_IMPORT=$2
    sleep 1
    #echo "$BI2R_EXPORT"
    #echo "$I2AR_IMPORT"

fi


#funtion to get the counts

function GET_SPLIT_COUNTS () {
  BI2R_EXPORT=$1
  I2AR_IMPORT=$2
  #set the BIR path to files
  echo
  echo -e "************************ \e[35mRESULTS: BI2R pre-split vs. I2AR post-split\e[0m *********************************"
  echo "******************************************************************************************************"
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
