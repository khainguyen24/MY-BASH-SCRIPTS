#!/bin/bash
###############
# This is a supportive script that collects the BIR export_lists; I2AR major-counts; downloads the prefix_count_compare_tool_SP82.sh from either AC2SP or GovCloud S3.
# Stages all the files in /var/i2ar/compare_major-counts_<SP##_YYYY-MM-DD>

#Check to see if $1 parameter was specified. required.. ie "SP82"
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
	#count_dir="$(/var/i2ar/compare_major-counts ${build_number_date})"
	#echo $build_number_date
	echo
	echo "Setting up the server with the supporting files for comparing major counts.."
	sleep 1
	echo "Creating compare_major-counts directory"
	sleep 1
	mkdir --parent /var/i2ar/compare_major-counts
	#compare_dir="$(mv compare_major-counts compare_major-counts_$build_number_date)"
	

	#find the BIR export list and the I2AR major count files and copy it to the compare directory
	# find: ‘/proc/497’: No such file or directory is a common error
	# changing the find command to look just in the /var/webadmin/automated_Import_Scripts
	echo "Locating the export_list and major-count"
	find /var/webadmin/automated_Import_Scripts -type d -name "export_lists" -exec cp -rp {} /var/i2ar/compare_major-counts \;
	find /var/webadmin/automated_Import_Scripts -type d -name "major-counts" -exec cp -rp {} /var/i2ar/compare_major-counts \;

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
		aws s3 cp s3://i2ar-testteam-uac2sp/prefix_count_compare_tool_SP82.sh /var/i2ar/compare_major-counts
	else
		echo "GovCloud"
		#echo $HOSTNAME_VALUE
		aws s3 cp s3://testteam/Khai/Scripts/prefix_count_compare_tool_SP82.sh /var/i2ar/compare_major-counts
	fi
}

#could add the array script here

function CHOWN_CHMOD_DIR () {
	echo "setting ownwership and permissions.."
	sleep 1
	chown -R webadmin:webadmin /var/i2ar/compare_major-counts
	chmod -R 740 /var/i2ar/compare_major-counts
	chmod -R 640 /var/i2ar/compare_major-counts/export_lists/*
	chmod -R 640 /var/i2ar/compare_major-counts/major-counts/*
	echo "done."
}

function RENAME_DIR () {
	echo "renaming directory.."
	sleep 1
	mv /var/i2ar/compare_major-counts /var/i2ar/compare_major-counts_${build_number_date}_${date}
	echo "done."
}


COPY_MAJOR_COUNTS
CHECK_S3_GET_SCRIPT
CHOWN_CHMOD_DIR 
RENAME_DIR
echo "Complete! check the compare_major-counts directory for the BI2R and I2AR count files"
exit 0;