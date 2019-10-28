#!/bin/bash
# Some Notes
# Function to find the files in export_list and major-counts list and copy it over to the corresponding compare_major-counts/* folder.
# Create arrays to hold all the files to copy over
# Copy the txt files to the appropriate destination folder .. Ie *_compare folder
# Setting the variables for the script.
BIR_counts_path=/root/my_fedora_folder/DV-53-majorCount/2019-10-15/export_lists/
I2AR_counts_path=/root/my_fedora_folder/DV-53-majorCount/major-counts-Oct-15-2019/
Create_compare_major_counts_dir="$(mkdir /root/my_fedora_folder/compare_major-counts-test)"
FULL_PATH_COMPARE_DIR=/root/my_fedora_folder/compare_major-counts-test/
CREATE_TOTAL_IDENTITIES_DIR="$(mkdir /root/my_fedora_folder/compare_major-counts-test/total_identities_compare)"
TOTAL_IDENTITIES_DIR=/root/my_fedora_folder/compare_major-counts-test/total_identities_compare
#####################################
<<COMMENT
# just a cheatsheet of whats in the array
# BI2R: these are the array positions for the elements in the "ARRAY_BIR_COUNT_FILES" array
[0]ATP_BIDS.TXT
[1]ATTACHMENTS_PHOTOS.TXT
[2]ATTRIBUTES.TXT
[3]BAT_GUIDS.TXT
[4]BATCXI_GUIDS.TXT
[5]BIDS.TXT
[6]COMMENTS.TXT
[7]EVENT_ATTACHMENTS.TXT
[8]EVENT_COMMENTS.TXT
[9]EVENT_ENCOUNTERS.TXT
[10]EVENTS.TXT
[11]EXPORTED_MATCHML.TXT
[12]INACTIVE_USP_BIDS.TXT
[13]MATCHML.TXT
[14]NOMINATED_WATCHLISTED_BIDS.TXT
[15]NONSENSOR_RIR_TCNS.TXT
[16]NONSENSOR_UHN_TCNS.TXT
[17]PREVIOUS_WATCHLISTED_BIDS.TXT
[18]PRIMARY_BIDS.TXT
[19]PRODUCTS.TXT
[20]PURGED_ALL_BIDS.TXT
[21]PURGED_BIDS_UNIQUE.TXT
[22]QUARANTINED_BIDS.TXT
[23]RELATIONSHIP.TXT
[24]SENSORS.TXT
[25]THREAT_BIDS.TXT
[26]TPWDES.TXT
[27]TWPDES_EXP.TXT
[28]WATCHLISTED_BIDS.TXT
# I2AR: these are the array positions for the elements in the "ARRAY_I2AR_COUNT_FILES" array
[0]atp_scores.txt
[1]attachments_photos.txt
[2]attributes.txt
[3]bat_records_total.txt
[4]batcxi_records_total.txt
[5]bids_identities.txt
[6]comments.txt
[7]event_attachments.txt
[8]event_comments.txt
[9]event_encounters.txt
[10]events.txt
[11]matchml.txt
[12]nominated_to_watchlist.txt
[13]nonsensor_rir.txt
[14]nonsensor_uhn.txt
[15]previously_watchlisted.txt
[16]products.txt
[17]relationships.txt
[18]sensor_total.txt
[19]twpdes.txt
[20]usp_active_records.txt
[21]usp_inactive_records.txt
[22]usp_purged.txt
[23]usp_quarantined.txt
[24]usp_threats.txt
[25]watchlisted.txt
# array for the compare_major-counts_YYYY-MM-DD-SP## directories (created when the copy_major_count_SP82_2.sp script is ran)
[0]atp_scores_compare
[1]attachments_photos_compare
[2]attributes_compare
[3]bat_records_total_compare
[4]batcxi_records_total_compare
[5]bids_identities_compare
[6]comments_compare
[7]event_attachments_compare
[8]event_comments_compare
[9]event_encounters_compare
[10]events_compare
[11]matchml_compare
[12]nominated_to_watchlist_compare
[13]nonsensor_rir_compare
[14]nonsensor_uhn_compare
[15]previously_watchlisted_compare
[16]products_compare
[17]relationships_compare
[18]sensor_total_compare
[19]total_identities_compare
[20]twpdes_compare
[21]usp_active_records_compare
[22]usp_inactive_records_compare
[23]usp_purged_compare
[24]usp_quarantined_compare
[25]usp_threats_compare
[26]watchlisted_compare
COMMENT
####################################################################
# making the compare directories Temp local.. note this is already done with the copy_major_count_SP82_2.sh Scripts
# remove this as it will no longer be needed after testing
function CREATE_DIR () {
ARRAY_6=($(ls ${I2AR_counts_path} | xargs -n 1 basename | cut -d '.' -f1 | sed 's/$/_compare/'))
echo "Creating all the *_compare directories to hold BIR and I2AR count files.."
  sleep 2
echo $FULL_PATH_COMPARE_DIR
for i in ${ARRAY_6[@]}
	do
		#note need to update the path of the output directory for it to work
		#currently the copy_major-counts script is coping everything over to /var/compare_major-counts
mkdir $FULL_PATH_COMPARE_DIR/${i}
		###mkdir /home/khai/My-SCIRPTS/Test_dir/${i}
		echo "$i"
		#could add some cp or mv commands to get the count file from each of the BIR and I2AR export_list and major-counts dir
	done
    echo "Done.. Moving on.."
    sleep 1
}
########################################################
# Function to create the BIR I2AR and compare-counts directories ARRAYS
function create_arrays () {
ARRAY_BIR_COUNT_FILES=(
  ATP_BIDS.TXT
  ATTACHMENTS_PHOTOS.TXT
  ATTRIBUTES.TXT
  BAT_GUIDS.TXT
  BATCXI_GUIDS.TXT
  BIDS.TXT
  COMMENTS.TXT
  EVENT_ATTACHMENTS.TXT
  EVENT_COMMENTS.TXT
  EVENT_ENCOUNTERS.TXT
  EVENTS.TXT
  EXPORTED_MATCHML.TXT
  INACTIVE_USP_BIDS.TXT
  MATCHML.TXT
  NOMINATED_WATCHLISTED_BIDS.TXT
  NONSENSOR_RIR_TCNS.TXT
  NONSENSOR_UHN_TCNS.TXT
  PREVIOUS_WATCHLISTED_BIDS.TXT
  PRIMARY_BIDS.TXT
  PRODUCTS.TXT
  PURGED_ALL_BIDS.TXT
  PURGED_BIDS_UNIQUE.TXT
  QUARANTINED_BIDS.TXT
  RELATIONSHIP.TXT
  SENSORS.TXT
  THREAT_BIDS.TXT
  TPWDES.TXT
  TWPDES_EXP.TXT
  WATCHLISTED_BIDS.TXT
  )
# ARRAY_I2AR_COUNT_FILES
ARRAY_I2AR_COUNT_FILES=(
atp_scores.txt
attachments_photos.txt
attributes.txt
bat_records_total.txt
batcxi_records_total.txt
bids_identities.txt
comments.txt
event_attachments.txt
event_comments.txt
event_encounters.txt
events.txt
matchml.txt
nominated_to_watchlist.txt
nonsensor_rir.txt
nonsensor_uhn.txt
previously_watchlisted.txt
products.txt
relationships.txt
sensor_total.txt
twpdes.txt
usp_active_records.txt
usp_inactive_records.txt
usp_purged.txt
usp_quarantined.txt
usp_threats.txt
watchlisted.txt
)
# ARRAY_COMPARE_DIR (the directory that will hold the BIR and I2AR count files)
	### Sample:ARRAY_1=($(ls /home/khai/DV-53-majorCount/major-counts-Oct-15-2019 | xargs -n 1 basename | cut -d '.' -f1 | sed 's/$/_compare/'))
ARRAY_COMPARE_DIR=(
atp_scores_compare
attachments_photos_compare
attributes_compare
bat_records_total_compare
batcxi_records_total_compare
bids_identities_compare
comments_compare
event_attachments_compare
event_comments_compare
event_encounters_compare
events_compare
matchml_compare
nominated_to_watchlist_compare
nonsensor_rir_compare
nonsensor_uhn_compare
previously_watchlisted_compare
products_compare
relationships_compare
sensor_total_compare
total_identities_compare
twpdes_compare
usp_active_records_compare
usp_inactive_records_compare
usp_purged_compare
usp_quarantined_compare
usp_threats_compare
watchlisted_compare
)
}
#######################################################
# Function to copy the BIR count files to the correct compare_major-counts/*
  function copy_bir_counts_2_dir () {
    echo "Copying the BI2R export_lists count files to the correct compare_major-counts/* directory..."
    find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[0]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[0]} \;
    find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[1]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[1]} \;
    find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[2]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[2]} \;
    echo "Complete.. moving on.."
}
# Function to copy the I2AR count files to the correct compare_major-counts/*
  function copy_i2ar_counts_2_dir () {
    echo "Copying the I2AR export_lists count files to the correct compare_major-counts/* directory..."
    find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[0]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[0]} \;
    find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[1]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[1]} \;
    find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[2]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[2]} \;
    echo "All done!"
}
####### Do stuff ##########
CREATE_DIR
sleep 2
create_arrays
sleep 2
copy_bir_counts_2_dir
sleep 1
copy_i2ar_counts_2_dir
exit 0;
