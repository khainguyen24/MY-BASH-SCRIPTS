#!/bin/bash
#
# This is a supportive script that collects the BIR export_lists; I2AR major-counts; downloads the prefix_count_compare_tool_SP82.sh from either AC2SP or GovCloud S3.
# Stages all the files in /var/compare_major-counts_<SP##_YYYY-MM-DD>
# Creats directories to hold BIR and I2AR count files..


# CHANGE LOG
# 10/22/19 updated the S3 locations the script on GovCloud and ac2sp
# 10/23/2019 - changing the /var/compare_major-counts to /var/compare_major-counts (note 18 instances of this path in the script.)
# added function to locate/create compare directories to hold the I2AR and BIR count files.
# 10/29/2019 - added functions to copy all the BIR and I2AR count files pairs (according to what major count they map to) to their respetive directories
# TODO: note: there is one file that makes up the "total_identites" Major count that is not in the "major-counts" folder:
# <YYYY-MM-DD>-bids_primary-post.txt .. this needs to be backed up to the compare_major-counts folder as well.
# 10/29/2019 - added commands to create the total_identities_compare and populate with the matching count pairs
# 10/28/2019 rearanged the BIR array to match I2AR count files and the compare directory and just use the array positions to do the copy since the bir and i2ar count files don't always have the same file names.
# update the compare array as well to match


# 1 ################################################
# Check to see if $1 parameter was specified. required.. ie "SP82"
if [ -z "$1" ]
then
    echo -e "\nMissing parameter...exiting.\n"
    echo "How to use this script:"
    echo "./copy_major_counts_BIR_I2AR.sh <sprint#>"
    echo -e "\nExample:"
    echo "./copy_major_counts_BIR_I2AR.sh SP82"
    echo -e "\n"
    exit 1;

else

    build_number_date=$1
fi

date="$(date +%F)"


# 2 ###############################################

# Setting the global variables and creating dir for the script.
BIR_counts_path="$(find /var/webadmin/automated_Import_Scripts -type d -name "export_lists")"
I2AR_counts_path="$(find /var/webadmin/automated_Import_Scripts -type d -name "major-counts")"
echo "Setting up the server with the supporting files for comparing major counts.."
sleep 1
echo "Creating compare_major-counts directory"
sleep 1
Create_compare_major_counts_dir="$(mkdir --parent /var/compare_major-counts)"
FULL_PATH_COMPARE_DIR=/var/compare_major-counts/
CREATE_TOTAL_IDENTITIES_DIR="$(mkdir ${FULL_PATH_COMPARE_DIR}total_identities_compare)"
TOTAL_IDENTITIES_DIR=/var/compare_major-counts/total_identities_compare

# 3 #################################################

function CHECK_S3_GET_SCRIPT () {
	CHECK_VALUE=1
	HOSTNAME_VALUE="$(hostname | grep -o ac2sp | wc -l)"
	echo "Locating the script on S3:"
	sleep 1
	if [ $CHECK_VALUE -eq $HOSTNAME_VALUE ]
	then
		echo "AC2SP"
		#echo $HOSTNAME_VALUE
    # old: aws s3 cp s3://i2ar-testteam-uac2sp/major_counts_compare_tool_SP82.sh /var/compare_major-counts
    aws s3 cp s3://i2ar-testteam-uac2sp/ /var/compare_major-counts --recursive --exclude "*" --include "major_counts_compare_tool_SP*"
	else
		echo "GovCloud"
		#echo $HOSTNAME_VALUE
    # old: aws s3 cp s3://testteam/Khai/Scripts/major_counts_compare_tool_SP82.sh /var/compare_major-counts
    aws s3 cp s3://testteam/Khai/Scripts/ /var/compare_major-counts --recursive --exclude "*" --include "major_counts_compare_tool_SP*"
	fi
}

# 4 ####################################################

function COPY_MAJOR_COUNTS () {

	#find the BIR export list and the I2AR major count files and copy it to the compare directory
	# find: ‘/proc/497’: No such file or directory is a common error
	echo "Locating the BI2R export_list and I2AR major-counts.."
	find /var/webadmin/automated_Import_Scripts -type d -name "export_lists" -exec cp -rp {} /var/compare_major-counts \;
	find /var/webadmin/automated_Import_Scripts -type d -name "major-counts" -exec cp -rp {} /var/compare_major-counts \;
  echo "copying to the /var/compare_major-counts directory."
}




# 5 ########################################################
# 10/29/2019 - added funtions to create the compare count dir and populate it with the matching BIR I2AR count pairs.


<<COMMENT
# Just a cheatsheet of whats in the array (gonna use these arrays with with a find and copy commands)
# BI2R: these are the array positions for the elements in the "ARRAY_BIR_COUNT_FILES" array
# 10/28/2019 rearanged the order to match the *_compare directorys
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
[12]NOMINATED_WATCHLISTED_BIDS.TXT
[13]NONSENSOR_RIR_TCNS.TXT
[14]NONSENSOR_UHN_TCNS.TXT
[15]PREVIOUS_WATCHLISTED_BIDS.TXT
[16]PRODUCTS.TXT
[17]RELATIONSHIP.TXT
[18]SENSORS.TXT
[19]TWPDES_EXP.TXT
[20]ACTIVE_USP_BIDS.TXT
[21]INACTIVE_USP_BIDS.TXT
[22]PURGED_BIDS_UNIQUE.TXT
[23]QUARANTINED_BIDS.TXT
[24]THREAT_BIDS.TXT
[25]WATCHLISTED_BIDS.TXT
[26]PRIMARY_BIDS.TXT
# note currently these are exported from BIR but do not map to any I2AR count files and are not on the major-counts
# (im still gonna include them in the bir array for future use if needed)
[]MATCHML.TXT
[]PURGED_ALL_BIDS.TXT
[]TPWDES.TXT

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
# end of cheatsheet

# 6 ###################################################################
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

		mkdir $FULL_PATH_COMPARE_DIR${i}
		###mkdir /home/khai/My-SCIRPTS/Test_dir/${i}
		echo "$i"
		#could add some cp or mv commands to get the count file from each of the BIR and I2AR export_list and major-counts dir
	done
    echo "total_identities_compare"
    echo "Done!.. Moving on.."
    sleep 1
}

# 7 #######################################################

# Function to create the BIR I2AR and compare-counts directories ARRAYS
# (note i rearanged the order to match I2AR count files and the compare directories should make for easier find copy commands down the road)
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
	NOMINATED_WATCHLISTED_BIDS.TXT
	NONSENSOR_RIR_TCNS.TXT
	NONSENSOR_UHN_TCNS.TXT
	PREVIOUS_WATCHLISTED_BIDS.TXT
	PRODUCTS.TXT
	RELAITONSHIPS.TXT
	SENSORS.TXT
	TWPDES_EXP.TXT
	ACTIVE_USP_BIDS.TXT
	INACTIVE_USP_BIDS.TXT
	PURGED_BIDS_UNIQUE.TXT
	QUARANTINED_BIDS.TXT
	THREAT_BIDS.TXT
	WATCHLISTED_BIDS.TXT
	PRIMARY_BIDS.TXT
	MATCHML.TXT
	PURGED_ALL_BIDS.TXT
	TPWDES.TXT
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
# added total_identities_compare directory to the end of the array (this was created maually)
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
twpdes_compare
usp_active_records_compare
usp_inactive_records_compare
usp_purged_compare
usp_quarantined_compare
usp_threats_compare
watchlisted_compare
total_identities_compare
)
}

# 8 ######################################################
# Function to copy the BIR count files to the correct compare_major-counts/*
# could wrap this in a loop but will keep it as is (for readablity) for now just in case i need to change what files map to what.
  function copy_bir_counts_2_dir () {
    echo "Copying the BI2R export_lists count files to the correct compare_major-counts/* directory..."
    find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[0]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[0]} \;
    find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[1]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[1]} \;
    find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[2]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[2]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[3]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[3]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[4]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[4]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[5]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[5]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[6]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[6]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[7]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[7]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[8]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[8]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[9]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[9]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[10]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[10]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[11]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[11]} \;
# From here on the BIR count file order was rearanged to match I2AR and the compare count directories
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[12]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[12]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[13]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[13]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[14]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[14]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[15]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[15]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[16]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[16]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[17]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[17]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[18]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[18]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[19]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[19]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[20]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[20]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[21]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[21]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[22]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[22]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[23]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[23]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[24]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[24]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[25]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[25]} \;
		find $BIR_counts_path -type f -name ${ARRAY_BIR_COUNT_FILES[26]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[26]} \;
    echo "Done!.. moving on.."
}



# Function to copy the I2AR count files to the correct compare_major-counts/*
  function copy_i2ar_counts_2_dir () {
    echo "Copying the I2AR export_lists count files to the correct compare_major-counts/* directory..."
    find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[0]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[0]} \;
    find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[1]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[1]} \;
    find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[2]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[2]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[3]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[3]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[4]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[4]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[5]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[5]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[6]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[6]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[7]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[7]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[8]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[8]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[9]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[9]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[10]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[10]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[11]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[11]} \;
# From here on the BIR count file order was rearanged to match I2AR and the compare count directories
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[12]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[12]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[13]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[13]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[14]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[14]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[15]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[15]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[16]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[16]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[17]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[17]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[18]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[18]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[19]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[19]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[20]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[20]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[21]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[21]} \;

		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[22]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[22]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[23]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[23]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[24]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[24]} \;
		find $I2AR_counts_path -type f -name ${ARRAY_I2AR_COUNT_FILES[25]} -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[25]} \;

			# for [26] need to get creative to find the <date of export>-bids_primary-post.txt it's outside of the major-counts directory
			# add the directory for the <date of export>-bids_primary-post.txt : change the search pattern to "*-bids_primary-post.txt" and it should work.
			# update the paths according to the TEST SERVER'S paths.
		find /var/webadmin/automated_Import_Scripts -type f -name "*-bids_primary-post.txt" -exec cp {} ${FULL_PATH_COMPARE_DIR}${ARRAY_COMPARE_DIR[26]} \;




    echo "Done.. moving on.."
		sleep 1



}


# 9 ####################################################################

function CHOWN_CHMOD_DIR () {
	echo "setting ownwership and permissions.."
	sleep 1
	chown -R webadmin:webadmin /var/compare_major-counts
	chmod -R 640 /var/compare_major-counts
	chmod -R 740 /var/compare_major-counts/major_counts_compare_tool_SP*

	echo "Done.. moving on.."
}

function RENAME_DIR () {
	echo "renaming directory.."
	sleep 1
	mv /var/compare_major-counts /var/compare_major-counts_${build_number_date}_${date}
	echo "All..Done!"
}


# DO STUFF
CHECK_S3_GET_SCRIPT
sleep 2
COPY_MAJOR_COUNTS
sleep 2
CREATE_DIR
sleep 2
create_arrays
sleep 2
copy_bir_counts_2_dir
sleep 2
copy_i2ar_counts_2_dir
sleep 2
CHOWN_CHMOD_DIR
sleep 2
RENAME_DIR
sleep 3
echo "Complete! BI2R and I2AR count file pairs copied to their corresponding: /var/compare_major-counts/* directories."
exit 0;
