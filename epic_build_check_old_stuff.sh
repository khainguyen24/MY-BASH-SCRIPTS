#!/bin/bash
# Utility script that will check epic BUILD items per version
# to run script:
# ./epic_build_check.sh [ v113 | v114 | v115 | v116
#############################################################################################
#########################   CHANGE LOG   ####################################################
# create the template for the script
# add the epic Build jiras to the right sections.. and add a few checks for starters.


#functions creates the log file and Header with version being checked



function CREATE_LOG_FILE () {
  mkdir -p /var/temp/
  echo -e "\e[35m*********************************" > /var/temp/epic_build_${1}_results.log
  echo -e "EPIC BUILD CHECK VERSION ${1}" >> /var/temp/epic_build_${1}_results.log
  echo -e "\e[35m*********************************\e[0m" >> /var/temp/epic_build_${1}_results.log
  #add Column headers to the log file
  echo -e "JIRA#        \e[32mPASSED\e[0m|\e[31mFAILED\e[0m DESCRIPTION" >> /var/temp/epic_build_${1}_results.log
}

#1-Check Folder This Function checks if folder exists
# function CHECK_FOLDER_EXIST () {
#   #$1 absolute parent path of folder to check permission on
#   #$2 reletive path to folder from parent of file to check permission on
#   #$3 absolute path of the file
#   #$4 expected file owner
#   #$5 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
#   #$6 JIRA Number
#   #$7 JIRA Description
#   VAR1="$(ls -l $1 | grep $2 | awk '{print $4}')"
#   if ([ -d $3 ] && [ ${VAR1} == $4 ]);
#   then
#   echo -e "${6} ${PASSED} ${7}" >> ${5}
#   else
#   echo -e "${6} ${FAILED} ${7}" >> ${5}
#   fi
# }

#2-Check if Folder exist and the ownership of the folder
function CHECK_FOLDER_OWN () {
  #$1 absolute parent path of folder to check permission on
  #$2 reletive path to folder from parent of file to check permission on
  #$3 absolute path of the file
  #$4 expected file owner
  #$5 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
  #$6 JIRA Number
  #$7 JIRA Description

  #VAR1 Getting the owner of the folder
  VAR1="$(ls -l $1 | grep $2 | awk '{print $4}')"

  if ([ -d $3 ] && [ ${VAR1} == $4 ]);
  then
  echo -e "${6} ${PASSED} ${7}" >> ${5}
  else
  echo -e "${6} ${FAILED} ${7}" >> ${5}
  fi

}

#2-Check File Parameters
function CHECK_FILE_PARAM () {
  #$1 absolute path of the file to check
  #$2 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
  #$3 JIRA Number
  #$4 JIRA Description
  #$5 Pattern 1 to check
  #$6 Pattern 2 to check
  #$7 Pattern 3 to check

################# deleting ########################################
#for loop for checking parameter
for i in {$1..$#}
do
  echo $i
done
echo $6
}
################# deleting ########################################
#3-Check For file
function CHECK_FILE_EXIST () {
  Josh to do something
}

#4-Check File for param
#function CHECK_FILE_PARAM () {
#   Josh to do something
# }

#5-Check param Does not exist Crontab
function CHECK_CRON () {
  Josh to do something
}

#6-Check version
function CHECK_VER () {
  Josh to do something
}









####################################################################################################
############################### V116 EPIC BUILD JIRAS ##############################################
####################################################################################################


####################################################################################################
############################### V117 EPIC BUILD JIRAS ##############################################
####################################################################################################
#GLOBAL VAR
FAILED='\e[31mFAILED_CHECK \e[0m'
PASSED='\e[32mPASSED_CHECK \e[0m'

if [ -z "$1" ]
then
    echo -e "\e[35mMissing parm .. use: v113 | v114 | v115 | v116\e[0m"
		sleep 1
		exit 1;
fi
####################################################################################################
############################### V113 EPIC BUILD JIRAS ##############################################
####################################################################################################
## ITWOAR-15890
# ITWOAR-15623
# ITWOAR-15743
# ITWOAR-15744
# ITWOAR-15762
# ITWOAR-15778
# ITWOAR-15784
# ITWOAR-15797
## ITWOAR-15655
## ITWOAR-15798
# ITWOAR-15880
# ITWOAR-15890
#Function to check all v113 epic Build items on the server
if [ $1 = "v113" ]
then
		echo -n -e "\e[35m\nCheckikng epic BUILD items for ver. v113..\e[0m"
#  Global var for build check
LOG_PATH="/var/temp/epic_build_${1}_results.log"
CREATE_LOG_FILE 'v113'
#ITWOAR-15797:
CHECK_FOLDER_OWN '/opt' 'i2ar' '/opt/i2ar' 'webadmin' "${LOG_PATH}" "ITWOAR-15797" "Directory Ownership Not Webadmin"
#ITWOAR-15890:
CHECK_FOLDER_OWN '/var' 'temp' '/var/i2ar' 'webadmin' "${LOG_PATH}" "ITWOAR-15890" "Create webadmin owned temp folder in /var/i2ar"
#ITWOAR-15623: checking for 2 parameters in the /etc/yum.repos.d/i2ar.repo
CHECK_FILE_PARAM '/etc/yum.repos.d/i2ar.repo' "${LOG_PATH}" "ITWOAR-15623" "Validate the User Data and make domain agnostic" "enabled=1" "gpgcheck = 1"
sleep 1
echo -e "\e[35m..done!\e[0m\n"
sleep 1
echo -e "\e[32m** Log file location: ${LOG_PATH} **\n\e[0m"
fi
#---------v113 END---------#

#2-Check File Parameters
# function CHECK_FILE_PARAM () {
  #$1 absolute path of the file to check
  #$2 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
  #$3 JIRA Number
  #$4 JIRA Description
  #$5 Pattern 1 to check
  #$6 Pattern 2 to check
  #$7 Pattern 3 to check

####################################################################################################
############################### V114 EPIC BUILD JIRAS ##############################################
####################################################################################################
# ITWOAR-15801
# ITWOAR-15902
# ITWOAR-15904
# ITWOAR-15905
# ITWOAR-15906
# ITWOAR-15913
# ITWOAR-15917
# ITWOAR-15924
# ITWOAR-15927
# ITWOAR-15932
#Function to check all v114 epic Build items on the server
if [ $1 = "v114" ]
then
		echo -e "\e[35m\nCheckikng epic BUILD items for ver. V114\e[0m"
echo Placehoder for the v114 checks

fi
#---------v114 END---------#


####################################################################################################
############################### V115 EPIC BUILD JIRAS ##############################################
####################################################################################################
#list jiras here
if [ $1 = "v115" ]
then
		echo -e "\e[35m\nCheckikng epic BUILD items for ver. V115\e[0m"
echo Placehoder for the v115 checks

fi
#---------v115 END---------#

####################################################################################################
############################### V116 EPIC BUILD JIRAS ##############################################
####################################################################################################
#list jiras here
if [ $1 = "v116" ]
then
		echo -e "\e[35m\nCheckikng epic BUILD items for ver. V116\e[0m\n"
echo Placehoder for the v116 checks

fi
#---------v116 END---------#
