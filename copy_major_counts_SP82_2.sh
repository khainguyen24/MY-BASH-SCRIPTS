#!/bin/bash
#
# This is a supportive script that collects the BIR export_lists; I2AR major-counts; downloads the prefix_count_compare_tool_SP82.sh from either AC2SP or GovCloud S3.
# Stages all the files in /var/compare_major-counts_<SP##_YYYY-MM-DD>
# Creats directories to hold BIR and I2AR count files..
# Maybe in the future add function to locate the files automatically.. the count files from both BIR and I2AR
# "Finding ATTACHMENT_PHOTOS.TXT and attachment_photos.txt" and put it in the proper directories
# Check to see if $1 parameter was specified. required.. ie "SP82"

# change Log
# 10/22/19 updated the S3 locations the script on GovCloud and ac2sp
# added function to locate/create compare directories to hold the I2AR and BIR count files.
# TODO: note: there is one file that makes up the "total_identites" Major count that is not in the "major-counts" folder:
# <YYYY-MM-DD>-bids_primary-post.txt .. this needs to be backed up to the compare_major-counts folder as well.
# 10/23/2019 - changing the /var/compare_major-counts to /var/compare_major-counts (note 18 instances of this path in the script.)
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

function COPY_MAJOR_COUNTS () {
	# make a compare directory
	# date="$(date +%F)"
	#build_number_date="${1}_$date"
	#var_i2ar_dir=/var/i2ar/
	#count_dir="$(/var/compare_major-counts ${build_number_date})"
	#echo $build_number_date
	echo
	echo "Setting up the server with the supporting files for comparing major counts.."
	sleep 1
	echo "Creating compare_major-counts directory"
	sleep 1
	mkdir --parent /var/compare_major-counts
	#compare_dir="$(mv compare_major-counts compare_major-counts_$build_number_date)"


	#find the BIR export list and the I2AR major count files and copy it to the compare directory
	# find: ‘/proc/497’: No such file or directory is a common error
	# changing the find command to look just in the /var/webadmin/automated_Import_Scripts
	echo "Locating the export_list and major-count"
	find /var/webadmin/automated_Import_Scripts -type d -name "export_lists" -exec cp -rp {} /var/compare_major-counts \;
	find /var/webadmin/automated_Import_Scripts -type d -name "major-counts" -exec cp -rp {} /var/compare_major-counts \;

}


function CHECK_S3_GET_SCRIPT () {
	CHECK_VALUE=1
	HOSTNAME_VALUE="$(hostname | grep -o ac2sp | wc -l)"
	echo "Locating the script on S3:"
	sleep 1
	if [ $CHECK_VALUE -eq $HOSTNAME_VALUE ]
	then
		echo "AC2SP"
		#echo $HOSTNAME_VALUE
		aws s3 cp s3://i2ar-testteam-uac2sp/major_counts_compare_tool_SP82.sh /var/compare_major-counts
	else
		echo "GovCloud"
		#echo $HOSTNAME_VALUE
		aws s3 cp s3://testteam/Khai/Scripts/major_counts_compare_tool_SP82.sh /var/compare_major-counts
	fi
}

#could add the array script here
function CREAT_DIR () {
	#need to confirm path to the major-count directory to build the array

	ARRAY_1=($(ls /var/compare_major-counts/major-counts | xargs -n 1 basename | cut -d '.' -f1 | sed 's/$/_compare/'))
	###:ARRAY_1=($(ls /home/khai/DV-53-majorCount/major-counts-Oct-15-2019 | xargs -n 1 basename | cut -d '.' -f1 | sed 's/$/_compare/'))

	echo "Creating all the *_compare directories to hold BIR and I2AR count files.."

	#printf '%s\n' "${ARRAY_1[@]}"
	#create directory to hold the other directories
	#from the copy_major_count_SP82_1.sh /var/compare_major-counts
	#uncomment the line below to add the path

		### dont need this: already made by other function mkdir /var/compare_major-counts
		####mkdir /home/khai/My-SCIRPTS/Test_dir/

	for i in ${ARRAY_1[@]}
	do
		#note need to update the path of the output directory for it to work
		#currently the copy_major-counts script is coping everything over to /var/compare_major-counts

		mkdir /var/compare_major-counts/${i}
		###mkdir /home/khai/My-SCIRPTS/Test_dir/${i}
		echo "$i"
		#could add some cp or mv commands to get the count file from each of the BIR and I2AR export_list and major-counts dir
	done
}

function CHOWN_CHMOD_DIR () {
	echo "setting ownwership and permissions.."
	sleep 1
	chown -R webadmin:webadmin /var/compare_major-counts
	chmod -R 740 /var/compare_major-counts
	chmod -R 640 /var/compare_major-counts/export_lists/*
	chmod -R 640 /var/compare_major-counts/major-counts/*
	echo "done."
}

function RENAME_DIR () {
	echo "renaming directory.."
	sleep 1
	mv /var/compare_major-counts /var/compare_major-counts_${build_number_date}_${date}
	echo "done."
}


COPY_MAJOR_COUNTS
CHECK_S3_GET_SCRIPT
CREAT_DIR
CHOWN_CHMOD_DIR
RENAME_DIR
echo "Complete! check the compare_major-counts directory for the BI2R and I2AR count files"
exit 0;
