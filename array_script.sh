#!/bin/bash

# create array from stdin

#OUTPUT=$(ls /home/khai/DV-53-majorCount/major-counts-Oct-15-2019 | xargs -n 1 basename | cut -d '.' -f1 | sed 's/$/_compare/')
#ARRAY_1=($OUTPUT)


#ARRAY_1=($(ls /home/khai/DV-53-majorCount/major-counts-Oct-15-2019 | xargs -n 1 basename | cut -d '.' -f1 | sed 's/$/_compare/'))
#printf '%s\n' "${ARRAY_1[@]}"

#param #1
<<COMMENT1
if [ -z "$1" ]
then
    echo -e "\nMissing parameter...exiting.\n"
    echo "How to use this script:"
    echo "./array_srcript.sh <array_name>"
    echo -e "\nExample:"
    echo "./array_srcript.sh <array_name>"
    echo -e "\n"
    exit 1;

else
    ARRAY_NAME=$1

fi
COMMENT1

function CREAT_DIR () {

	ARRAY_1=($(ls /home/khai/DV-53-majorCount/major-counts-Oct-15-2019 | xargs -n 1 basename | cut -d '.' -f1 | sed 's/$/_compare/'))

	echo "Creating all the *_compare directories to hold BIR and I2AR count files.."

	#printf '%s\n' "${ARRAY_1[@]}"
	#create directory to hold the other directories
	#from the copy_major_count_SP82_1.sh /var/i2ar/compare_major-counts
	#uncomment the line below to add the path

		####mkdir /var/i2ar/compare_major-counts
		mkdir /home/khai/My-SCIRPTS/Test_dir/

	for i in ${ARRAY_1[@]}
	do
		#note need to update the path of the output directory for it to work
		#currently the copy_major-counts script is coping everything over to /var/i2ar/compare_major-counts

		###mkdir /var/i2ar/compare_major-counts/${i}
		mkdir /home/khai/My-SCIRPTS/Test_dir/${i}
		echo "$i"
		#could add some cp or mv commands to get the count file from each of the BIR and I2AR export_list and major-counts dir
	done
}

CREAT_DIR #$ARRAY_NAME
echo "all.. done!"
