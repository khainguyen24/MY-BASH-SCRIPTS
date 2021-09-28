#!/bin/bash
# Utility script that will check epic BUILD items per version
# to run script:
# ./epic_build_check.sh [ v113 | v114 | v115 | v116
#############################################################################################
#########################   CHANGE LOG   ####################################################
# create the template for the script
# add the epic Build jiras to the right sections.. and add a few checks for starters.

#GLOBAL VAR
FAILED='\e[31mFAILED_CHECK \e[0m'
PASSED='\e[32mPASSED_CHECK \e[0m'
SERVER_HOSTNAME="$(hostname)"

#------------FUNCTION SECTION - BEGIN---------------#
# CREATE_LOG_FILE <add description>
# CHECK_SERVER_MODE <add description>
# CHECK_FOLDER_OWN <add description>
# CHECK_FILE_PARAM <add description>
# CHECK_CRON <add description>
# CHECK_VER <add description>
# CHECK_VERIFY <add description>
# CHECK_MODE_CRON <add description>
# CHECK_MODE_FILE_PARAM <add description>

#------------CREATE_LOG_FILE - BEGIN-----------------#
#functions creates the log file and Header with version being checked
function CREATE_LOG_FILE () {
  mkdir -p /var/temp/
  echo -e "\e[35m******************************************************" > /var/temp/epic_build_${1}_results.log
  echo -e "EPIC BUILD CHECK VERSION ${1} ${SERVER_MODE_GLOBE}" >> /var/temp/epic_build_${1}_results.log
  # adding date and hostname to headers
  RUN_DATE="$(date)"
  echo -e "Date: $RUN_DATE" >> /var/temp/epic_build_${1}_results.log
  # SERVER_HOSTNAME="$(hostname)" ## moving it outside of this function to make it a global var
  echo -e "FQDN: $SERVER_HOSTNAME" >> /var/temp/epic_build_${1}_results.log
  echo -e "\e[35m******************************************************\e[0m" >> /var/temp/epic_build_${1}_results.log
  #add Column headers to the log file
  echo -e "JIRA#        \e[32mPASSED\e[0m|\e[31mFAILED\e[0m DESCRIPTION" >> /var/temp/epic_build_${1}_results.log
}
#------------CREATE_LOG_FILE - END-----------------#
#------------CHECK SERVER MODE START---------------#
# Check SERVER MODE SMODE or JMODE and save to varible SERVER_MODE
#
function CHECK_SERVER_MODE () {
SERVER_MODE=
  #VAR1 Getting the owner of the folder
  VAR1="$(grep network.sipr /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties)"

  if ([ $VAR1 == 'network.sipr=true' ]);
  then
    SERVER_MODE='S-MODE'
  else
    SERVER_MODE='J-MODE'
  fi
}
#------------CHECK SERVER MODE - END-----------------#
#------------CHECK_FOLDER_OWN - START----------------#
#Check if Folder exist and the ownership of the folder
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
#------------CHECK_FOLDER_OWN - END-----------------#
#------------CHECK_FILE_PARAM - START-----------------#
#Check File Parameters
function CHECK_FILE_PARAM () {
  #$1 absolute path of the file to check
  #$2 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
  #$3 JIRA Number
  #$4 JIRA Description
  #$5 Pattern 1 to check
  #$6 Pattern 2 to check
  #$7 Pattern 3 to check

# check 1 parameter
if [[ "$#" -eq 5 ]]
then
#Check for 1 param
  VAR5="$(grep -o "$5" $1 | head -1)"
  if ([ "$VAR5" = "$5" ]);
  then
    echo -e "${3} ${PASSED} ${4}" >> ${2}
    else
    echo -e "${3} ${FAILED} ${4}" >> ${2}
  fi
# check 2 parameter
elif [[ "$#" -eq 6 ]]
then
#Check for 2 param

VAR5="$(grep -o "$5" $1 | head -1)"
VAR6="$(grep -o "$6" $1 | head -1)"
  if ([ "$VAR5" == "$5" ] && [ "$VAR6" == "$6" ]);
  then
    echo -e "${3} ${PASSED} ${4}" >> ${2}
    else
    echo -e "${3} ${FAILED} ${4}" >> ${2}
  fi
# check 3 parameter

elif [[ "$#" -eq 7 ]]
then
  VAR5="$(grep -o "$5" $1 | head -1)"
  VAR6="$(grep -o "$6" $1 | head -1)"
  VAR7="$(grep -o "$7" $1 | head -1)"
  if ([ "$VAR5" == "$5" ] && [ "$VAR6" == "$6" ] && [ "$VAR7" = "$7" ]);
  then
    echo -e "${3} ${PASSED} ${4}" >> ${2}
    else
    echo -e "${3} ${FAILED} ${4}" >> ${2}
  fi
fi
}
#------------CHECK_FILE_PARAM - END-----------------#
#------------CHECK_CRON - START-----------------#
#Check param does or does not exist Crontab
#Note: should be ran as 'root' user and escape all '*' and '/' in $5 or the grep command will fail.
function CHECK_CRON () {
  #$1 JIRA Number
  #$2 JIRA DESCRIPTION
  #$3 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
  #$4 Present/Absent Present to check if there/absent to check if not there
  #$5 Cronjob command being checked
  #$6 Cronjob owner "webadmin"
  VAR1="$(crontab -l -u "$6" | grep -o "$5")"
  if [[ "$4" == "Present" ]]
  then
  	if [[ ! -z "$VAR1"  ]]
  	then
  		echo -e "${1} ${PASSED} ${2}" >> ${3}
  	else
      echo -e "${1} ${FAILED} ${2}" >> ${3}
  	fi
  elif [[ "$4" == "Absent" ]]
  then
  	if [[ -z "$VAR1" ]]
  	then
  		echo -e "${1} ${PASSED} ${2}" >> ${3}
  	else
  		echo -e "${1} ${FAILED} ${2}" >> ${3}
  	fi
  fi

}
#------------CHECK_CRON - END-----------------#
#------------CHECK_VER - START-----------------#
#Check version
function CHECK_VER () {
  #$1 JIRA Number
  #$2 JIRA DESCRIPTION
  #$3 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
  #$4 command to run Example: ls -ltr /usr/java/
  #$5 Pattern to grep on Examle: jdk1.8.0_291-amd64

  VAR1="$($4 | grep -o "$5" | head -1)"
  if ([ "$VAR1" = "$5" ]);
  then
    echo -e "${1} ${PASSED} ${2}" >> ${3}
    else
    echo -e "${1} ${FAILED} ${2}" >> ${3}
  fi
}
#------------CHECK_VER - END-----------------#
#------------CHECK_VERIFY - START-----------------#
#Check verify parameter for jiras where the value can change ie ITWOAR-15880
function CHECK_VERIFY () {
  #$1 JIRA Number
  #$2 JIRA DESCRIPTION
  #$3 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
  #$4 absolut Path to file being checked
  #$5 Pattern to check
  VAR1="$(grep "$5" "$4")"
    echo -e "\e[35m*********************************\e[0m" >> ${3}
    echo -e "\e[35mMANUAL CHECK REQUIRED\e[0m" >> ${3}
    echo -e "\e[35m*********************************\e[0m" >> ${3}
    echo -e "${1} Verify values are correct for this server:" >> ${3}
    echo -e "${VAR1}\n" >> ${3}
}
#------------CHECK_VERIFY - END-----------------#
#------CHECK_MODE_CRON - START-----------#
#****-Check Smode Jmode and run check accordingly
#Note: should be ran as 'root' user and escape all '*' and '/' in $5 or the grep command will fail.
function CHECK_MODE_CRON () {
  #$1 JIRA Number
  #$2 JIRA DESCRIPTION
  #$3 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
  #$4 Present/Absent Present to check if there/absent to check if not there
  #$5 Cronjob command being checked
  #$6 Cronjob owner "webadmin"
  #$7 Specify which network "S-MODE" or "J-MODE"
  #EXAMPLE: CHECK_MODE_CRON "ITWOAR-15744" "Setup XDom automation" ${LOG_PATH} "Present" "cd /opt/i2ar/sprocket && ./sprocket.sh tools/xdom-transmit.groovy" "webadmin" "J-MODE"
  #EXAMPLE: CHECK_MODE_CRON "ITWOAR-15744" "Setup XDom automation" ${LOG_PATH} "Absent" "cd /opt/i2ar/sprocket && ./sprocket.sh tools/xdom-transmit.groovy" "webadmin" "S-MODE"
  VAR1="$(crontab -l -u "$6" | grep -o "$5")"
  if ([ "$4" == "Present" ] && [ "$SERVER_MODE" == "$7" ]);
  then
  	if [[ ! -z "$VAR1"  ]]
  	then
  		echo -e "${1} ${PASSED} ${2}" >> ${3}
  	else
      echo -e "${1} ${FAILED} ${2}" >> ${3}
  	fi
  elif ([ "$4" == "Absent" ] && [ "$SERVER_MODE" == "$7" ]);
  then
  	if [[ -z "$VAR1" ]]
  	then
  		echo -e "${1} ${PASSED} ${2}" >> ${3}
  	else
  		echo -e "${1} ${FAILED} ${2}" >> ${3}
  	fi
  fi

}
#------CHECK_MODE_CRON - END-----------#
#--------CHECK_MODE_FILE_PARAM START-----------#
#Check File Parameters
function CHECK_MODE_FILE_PARAM () {
  #$1 absolute path of the file to check
  #$2 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
  #$3 JIRA Number
  #$4 JIRA Description
  #$5 Present/Absent Present to check if there/absent to check if not there
  #$6 Specify which network "S-MODE" or "J-MODE"
  #$7 Pattern 1 to check
  #$8 Pattern 2 to check
  #$9 Pattern 3 to check
  #$10 Pattern 4 to check
#---theses checks for "Present" still part of the CHECK_MODE_FILE_PARAM function----#
# check 1 parameter
if ([ "$#" -eq 7 ] && [ "$5" == "Present" ] && [ "$SERVER_MODE" == "$6" ]);
then
#Check for 1 param
  VAR7="$(grep -o "$7" $1)"
  if ([ "$VAR7" == "$7" ]);
  then
    echo -e "${3} ${PASSED} ${4}" >> ${2}
    else
    echo -e "${3} ${FAILED} ${4}" >> ${2}
  fi
# check 2 parameter
elif ([ "$#" -eq 8 ] && [ "$5" == "Present" ] && [ "$SERVER_MODE" == "$6" ]);
then
#Check for 2 param

VAR7="$(grep -o "$7" $1)"
VAR8="$(grep -o "$8" $1)"
  if ([ "$VAR7" == "$7" ] && [ "$VAR8" == "$8" ]);
  then
    echo -e "${3} ${PASSED} ${4}" >> ${2}
    else
    echo -e "${3} ${FAILED} ${4}" >> ${2}
  fi
# check 3 parameter

elif ([ "$#" -eq 9 ] && [ "$5" == "Present" ] && [ "$SERVER_MODE" == "$6" ]);
then
  VAR7="$(grep -o "$7" $1)"
  VAR8="$(grep -o "$8" $1)"
  VAR9="$(grep -o "$9" $1)"
  if ([ "$VAR7" == "$7" ] && [ "$VAR8" == "$8" ] && [ "$VAR9" == "$9" ]);
  then
    echo -e "${3} ${PASSED} ${4}" >> ${2}
    else
    echo -e "${3} ${FAILED} ${4}" >> ${2}
  fi

  # check 4 parameter Present

elif ([ "$#" -eq 10 ] && [ "$5" == "Present" ] && [ "$SERVER_MODE" == "$6" ]);
  then
    VAR7="$(grep -o "$7" $1)"
    VAR8="$(grep -o "$8" $1)"
    VAR9="$(grep -o "$9" $1)"
    VAR10="$(grep -o "${10}" $1)"
    if ([ "$VAR7" == "$7" ] && [ "$VAR8" == "$8" ] && [ "$VAR9" = "$9" ] && [ "$VAR10" == "${10}" ]);
    then
      echo -e "${3} ${PASSED} ${4}" >> ${2}
      else
      echo -e "${3} ${FAILED} ${4}" >> ${2}
    fi
#---theses checks for "Present" still part of the CHECK_MODE_FILE_PARAM function END----#
#---theses checks for "Absent" still part of the CHECK_MODE_FILE_PARAM function Start----#
# check 1 parameter (note: then and else is flipped for the Absent param.. if VAR7 and $7 evaluates to false then )
elif ([ "$#" -eq 7 ] && [ "$5" == "Absent" ] && [ "$SERVER_MODE" == "$6" ]);
then
#Check for 1 param
  VAR7="$(grep -o "$7" $1)"
  if ([ ${VAR7} != ${7} ]);
  then
    echo -e "${3} ${PASSED} ${4}" >> ${2}
    else
    echo -e "${3} ${FAILED} ${4}" >> ${2}
  fi
# check 2 parameter
elif ([ "$#" -eq 8 ] && [ "$5" == "Absent" ] && [ "$SERVER_MODE" == "$6" ]);
then
#Check for 2 param

VAR7="$(grep -o "$7" $1)"
VAR8="$(grep -o "$8" $1)"
  if ([ "$VAR7" != "$7" ] && [ "$VAR8" != "$8" ]);
  then
    echo -e "${3} ${PASSED} ${4}" >> ${2}
    else
    echo -e "${3} ${FAILED} ${4}" >> ${2}
  fi
# check 3 parameter

elif ([ "$#" -eq 9 ] && [ "$5" == "Absent" ] && [ "$SERVER_MODE" == "$6" ]);
then
  VAR7="$(grep -o "$7" $1)"
  VAR8="$(grep -o "$8" $1)"
  VAR9="$(grep -o "$9" $1)"
  if ([ "$VAR7" != "$7" ] && [ "$VAR8" != "$8" ] && [ "$VAR9" != "$9" ]);
  then
    echo -e "${3} ${PASSED} ${4}" >> ${2}
    else
    echo -e "${3} ${FAILED} ${4}" >> ${2}
  fi


# check 4 parameter absent NOTE: bash has issues with more then 10 params passed in so i have to use curl braces for the tenth param or bash will see "$10" as the first param +0 ie. "$1" + '0'

elif ([ "$#" -eq 10 ] && [ "$5" == "Absent" ] && [ "$SERVER_MODE" == "$6" ]);
then
  VAR7="$(grep -o "$7" $1)"
  VAR8="$(grep -o "$8" $1)"
  VAR9="$(grep -o "$9" $1)"
  VAR10="$(grep -o "${10}" $1)"
  if ([ "$VAR7" != "$7" ] && [ "$VAR8" != "$8" ] && [ "$VAR9" != "$9" ] && [ "$VAR10" != "${10}" ]);
  then
    echo -e "${3} ${PASSED} ${4}" >> ${2}
    else
    echo -e "${3} ${FAILED} ${4}" >> ${2}
  fi
fi
}
#--------CHECK_MODE_FILE_PARAM - END-----------#
#--------FUNCTION SECTION - END-----------#
#RUN STUFF#

#GLOBAL VAR (moved to the begining of the script)
# FAILED='\e[31mFAILED_CHECK \e[0m'
# PASSED='\e[32mPASSED_CHECK \e[0m'
# SERVER_HOSTNAME="$(hostname)"

if [ -z "$1" ]
then
    echo -e "\e[35mMissing parm .. use: v113 | v114 | v115 | v116\e[0m"
		sleep 1
		exit 1;
fi
####################################################################################################
############################### V113 EPIC BUILD JIRAS ##############################################
####################################################################################################
## ITWOAR-15623 done
## ITWOAR-15743 done
## ITWOAR-15744 done
## ITWOAR-15762 done
## ITWOAR-15778 done
## ITWOAR-15784 done
## ITWOAR-15797 done
## ITWOAR-15655 done
## ITWOAR-15798 done
## ITWOAR-15880 done
## ITWOAR-15890 done
#Function to check all v113 epic Build items on the server
if [ $1 = "v113" ]
then
	echo -n -e "\e[35m\nCheckikng epic BUILD items for ver. v113..\e[0m"
#  Global var for build check
LOG_PATH="/var/temp/epic_build_${1}_results.log"
CHECK_SERVER_MODE "$SERVER_MODE"
SERVER_MODE_GLOBE="${SERVER_MODE}"
CREATE_LOG_FILE 'v113'
#---- Support Functions END-----#


#################################################
###  RUN STUFF for the BUILD EPICS v113 HERE  ###
#################################################
#ITWOAR-15623: checking for 2 parameters in the /etc/yum.repos.d/i2ar.repo
CHECK_FILE_PARAM '/etc/yum.repos.d/i2ar.repo' "${LOG_PATH}" "ITWOAR-15623" "Validate the User Data and make domain agnostic" "enabled=1" "gpgcheck = 1" "gpgkey = http://i2ar-yum.i2ar.ac2sp.army.mil/repo-development/RPM-GPG-KEY"

#ITWOAR-15743: check cron job is present on both S and j servers
CHECK_CRON 'ITWOAR-15743' 'Re-work Daily Ingest Metrics crontab to make email addresses configurable and remove passwords in the clear' "${LOG_PATH}" "Present" '0 0 \* \* \* sh \/opt\/i2ar\/sprocket\/sprocket.sh \/opt\/i2ar\/sprocket\/tools\/data-ingestion-metric-report.groovy | mail -s Daily_Data_Ingestion_Metric_Report' "webadmin"

#ITWOAR-15744: check the MODE of the server and verify that cron job is on JMODE and NOT on Smode for webadmin user
CHECK_MODE_CRON "ITWOAR-15744" "Setup XDom automation" ${LOG_PATH} "Present" "cd /opt/i2ar/sprocket && ./sprocket.sh tools/xdom-transmit.groovy" "webadmin" "J-MODE"
CHECK_MODE_CRON "ITWOAR-15744" "Setup XDom automation" ${LOG_PATH} "Absent" "cd /opt/i2ar/sprocket && ./sprocket.sh tools/xdom-transmit.groovy" "webadmin" "S-MODE"

#ITWOAR-15762: check the MODE of the server and verify that cron is on SMODE and not on Jmode for webadmin user
CHECK_MODE_CRON "ITWOAR-15762" "Add void-info cron job" ${LOG_PATH} "Present" "cd /opt/i2ar/sprocket && ./sprocket.sh tools/show-void-info.groovy" "webadmin" "S-MODE"
CHECK_MODE_CRON "ITWOAR-15762" "Add void-info cron job" ${LOG_PATH} "Absent" "cd /opt/i2ar/sprocket && ./sprocket.sh tools/show-void-info.groovy" "webadmin" "J-MODE"

#ITWOAR-15778: checking for 2 parameters in /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/message.properties
CHECK_FILE_PARAM '/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/message.properties' "${LOG_PATH}" "ITWOAR-15778" "Update message.properties in biometrics module to add 4 new properties for UAMT" "# ITWOAR-13037: User Account Management Page info" "# ITWOAR-13037: Role Request Page info"

#ITWOAR-15784: check the MODE of the server and verify that xdom.property value is on J-MODE and not on S-mode for webadmin user
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/xdom.properties" ${LOG_PATH} "ITWOAR-15784" "New properties in XDom for Asyn Import" "Present" "J-MODE" "xdom.receiver.import.expiration.minutes=5" "xdom.receiver.import.run=false"
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/xdom.properties" ${LOG_PATH} "ITWOAR-15784" "New properties in XDom for Asyn Import" "Absent" "S-MODE" "xdom.receiver.import.expiration.minutes=5" "xdom.receiver.import.run=false"

#ITWOAR-15797:
CHECK_FOLDER_OWN '/opt' 'i2ar' '/opt/i2ar' 'webadmin' "${LOG_PATH}" "ITWOAR-15797" "Directory Ownership Not Webadmin"

#ITWOAR-15655: Check jdk version
CHECK_VER 'ITWOAR-15655' 'Upgrade JDK to 1.8_291' ${LOG_PATH} "ls -ltr /usr/java/" "jdk1.8.0_291-amd64"

#ITWOAR-15798: Update standalone.xml to support TLSv1.2
CHECK_FILE_PARAM '/opt/jboss/default/standalone/configuration/standalone-full-lab.xml' "${LOG_PATH}" "ITWOAR-15798" "Update standalone.xml to support TLSv1.2" '<property name="https.protocols" value="TLSv1.2"/>' '<ssl protocol="TLSv1.2">' 'enabled-protocols="TLSv1.2"'

#ITWOAR-15880: MODE Match Agent Default Classifications - this needs to be a check where the match agent matches the string value on the given MODE maybe we need to update the $7 search param whenever there is an addtional matchagent ie. bat-eft: Note: no need to escape the '/' weird! i know!
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties" ${LOG_PATH} "ITWOAR-15880" "Match Agent Default Classifications" "Present" "J-MODE" "sourceHigh.classifications={BAT:'S//NF'; BAT-CXI:'S//REL TO USA, NATO, RSMA'; ABIS:'U//FOUO'; SS:'U//FOUO'; UHN:'U//FOUO'; RIR:'U//FOUO'; TSDB:'U//FOUO'; DHS:'U'; I2D:'U//FOUO'; JJ:'U//FOUO'}"
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties" ${LOG_PATH} "ITWOAR-15880" "Match Agent Default Classifications" "Present" "S-MODE" "sourceHigh.classifications={BAT:'S//NF'; BAT-CXI:'S//REL TO USA, NATO, RSMA'; ABIS:'U//FOUO'; SS:'U//FOUO'; UHN:'U//FOUO'; RIR:'U//FOUO'; TSDB:'U//FOUO'; DHS:'U'; I2D:'U//FOUO'}"

#ITWOAR-15890: Check for temp folder in /var/i2ar/ owned by webadmin
CHECK_FOLDER_OWN '/var/i2ar' 'temp' '/var/i2ar/temp' 'webadmin' "${LOG_PATH}" "ITWOAR-15890" "Create webadmin owned temp folder in /var/i2ar"

#ITWOAR-15880: output the value
CHECK_VERIFY "ITWOAR-15880" "Match Agent Default Classifications" ${LOG_PATH} "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties" "sourceHigh.classifications="

#Add checks above this line
sleep 1
echo -e "\e[35m..done!\e[0m\n"
sleep 1
echo -e "\e[32m** Log file location: ${LOG_PATH} **\n\e[0m"
fi

##################### JUNK NOTES: AREA ###############################

#function CHECK_MODE_FILE_PARAM () {
  #$1 absolute path of the file to check
  #$2 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
  #$3 JIRA Number
  #$4 JIRA Description
  #$5 Present/Absent Present to check if there/absent to check if not there
  #$6 Specify which network "S-MODE" or "J-MODE"
  #$7 Pattern 1 to check
  #$8 Pattern 2 to check
  #$9 Pattern 3 to check


##################### JUNK NOTES: AREA ###############################
#---------v113 END---------#


####################################################################################################
############################### V114 EPIC BUILD JIRAS ##############################################
####################################################################################################
# ITWOAR-15801
## ITWOAR-15902
## ITWOAR-15904
## ITWOAR-15905
# ITWOAR-15906
# ITWOAR-15913
# ITWOAR-15917
# ITWOAR-15924
# ITWOAR-15927
# ITWOAR-15932

#Function to check all v114 epic Build items on the server
if [ $1 = "v114" ]
then
	echo -n -e "\e[35m\nCheckikng epic BUILD items for ver. v114..\e[0m"
#  Global var for build check
LOG_PATH="/var/temp/epic_build_${1}_results.log"
CHECK_SERVER_MODE "$SERVER_MODE"
SERVER_MODE_GLOBE="${SERVER_MODE}"
CREATE_LOG_FILE 'v114'
#---- Support Functions END-----#

#################################################
###  RUN STUFF for the BUILD EPICS v114 HERE  ###
#################################################
# ITWOAR-15801 Create I2AR shared broker instruction set
# ITWOAR-15902 Templatize configuration for Roles.json and Attribs.json
# ITWOAR-15904 Add monitor status properties to xdom.properties
# ITWOAR-15905 Update Finalize script to have clamd@scan service start immediately after it's enabled
# ITWOAR-15906 Add bundler status properties to xdom.properties
# ITWOAR-15913 Add missing xdomBridge to index standalone.xml
# ITWOAR-15917 Create and Add Accumulo Class for accumulo iterator package management
# ITWOAR-15924 Document the resolution of crypto-algorithm INFO spam as solved by JDK upgrade + bouncycastle extension
# ITWOAR-15927 Fix standalone-full-lab-index.xml template
# ITWOAR-15932 Update ingest-pubxml.amqUrl parameter to make it more configurable
########################
# ITWOAR-15902 Templatize configuration for Roles.json and Attribs.json | 2 checks looking for pattern that only the newer Aug 24 file has
CHECK_FILE_PARAM '/opt/jboss/jboss-eap-7.0/modules/com/leidos/login/main/Attribs.json' "${LOG_PATH}" "ITWOAR-15902" "Templatize configuration for Attribs.json" "CITIZENSHIP"
CHECK_FILE_PARAM '/opt/jboss/jboss-eap-7.0/modules/com/leidos/login/main/Roles.json' "${LOG_PATH}" "ITWOAR-15902" "Templatize configuration for Roles.json" "Operators"

#ITWOAR-15904: check the MODE of the server and verify that xdom.property value is on S-MODE and not on J-mode
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/xdom.properties" ${LOG_PATH} "ITWOAR-15904" "Add monitor status properties to xdom.properties" "Present" "S-MODE" "xdom.monitor.statusSize=10" "xdom.monitor.statusInterval=60000"
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/xdom.properties" ${LOG_PATH} "ITWOAR-15904" "Add monitor status properties to xdom.properties" "Absent" "J-MODE" "xdom.monitor.statusSize=10" "xdom.monitor.statusInterval=60000"

#ITWOAR-15905: Check Update Finalize script to have clamd@scan service start immediately after it's enabled
CHECK_VER "ITWOAR-15905" "Update Finalize script to have clamd@scan service start immediately after it's enabled" ${LOG_PATH} "systemctl status clamd@scan" "(running)"

# ITWOAR-15906 Add bundler status properties to xdom.properties
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/xdom.properties" ${LOG_PATH} "ITWOAR-15906" "Add bundler status properties to xdom.properties" "Present" "S-MODE" "xdom.serverName=${SERVER_HOSTNAME}" "xdom.bundler.statusInterval=10000" "xdom.bundler.statusMaxRecentBundles=10" "xdom.bundler.statusMaxRecentObjects=10"
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/xdom.properties" ${LOG_PATH} "ITWOAR-15906" "Add bundler status properties to xdom.properties" "Absent" "J-MODE" "xdom.serverName=${SERVER_HOSTNAME}" "xdom.bundler.statusInterval=10000" "xdom.bundler.statusMaxRecentBundles=10" "xdom.bundler.statusMaxRecentObjects=10"


#Add checks above this line
sleep 1
echo -e "\e[35m..done!\e[0m\n"
sleep 1
echo -e "\e[32m** Log file location: ${LOG_PATH} **\n\e[0m"
fi

##################### JUNK NOTES: AREA ###############################

#$1 absolute path of the file to check
#$2 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
#$3 JIRA Number
#$4 JIRA Description
#$5 Present/Absent Present to check if there/absent to check if not there
#$6 Specify which network "S-MODE" or "J-MODE"
#$7 Pattern 1 to check
#$8 Pattern 2 to check
#$9 Pattern 3 to check
#$10 Pattern 4 to check


##################### JUNK NOTES: AREA ###############################

#---------v114 END---------#


####################################################################################################
############################### V115 EPIC BUILD JIRAS ##############################################
####################################################################################################
# ITWOAR-15102
# ITWOAR-15963
# ITWOAR-15984
# ITWOAR-15993
# ITWOAR-15996
# ITWOAR-15998
# ITWOAR-16000
# ITWOAR-16003
# ITWOAR-16004
# ITWOAR-16005
# ITWOAR-16018
# ITWOAR-16031
# ITWOAR-16033
# ITWOAR-16034
# ITWOAR-16041
# ITWOAR-16044
# ITWOAR-16045
# ITWOAR-16046
# ITWOAR-16049
# ITWOAR-16059
# ITWOAR-16070

#Function to check all v115 epic Build items on the server
if [ $1 = "v115" ]
then
	echo -n -e "\e[35m\nCheckikng epic BUILD items for ver. v115..\e[0m"
#  Global var for build check
LOG_PATH="/var/temp/epic_build_${1}_results.log"
CHECK_SERVER_MODE "$SERVER_MODE"
SERVER_MODE_GLOBE="${SERVER_MODE}"
CREATE_LOG_FILE 'v115'
#---- Support Functions END-----#

#################################################
###  RUN STUFF for the BUILD EPICS v115 HERE  ###
#################################################
## equals check has been added and verified working on dev-head-s
#* means it’s procedural change in foreman or somewhere other than the server being checked
# means the check for the epic Build jira has not been create or verified
## ITWOAR-15102
## ITWOAR-15963
## ITWOAR-15984
## ITWOAR-15993
## ITWOAR-15996
## ITWOAR-15998 Add the 'intelDocs.softwareUserManual.url' property to biometrics.properties
#* ITWOAR-16000 Change Class Naming Post-Processing
#* ITWOAR-16003 Update Pupmod Directory Names in Code
## ITWOAR-16004 Update standalone XML with new wlmerge bridge settings
#* ITWOAR-16005 Update production classes by ensuring jboss is stopped before puppet is run
# ITWOAR-16018
## ITWOAR-16031
# ITWOAR-16033
# ITWOAR-16034
# ITWOAR-16041
# ITWOAR-16044
# ITWOAR-16045
# ITWOAR-16046
# ITWOAR-16049
# ITWOAR-16059
# ITWOAR-16070
########################
## ITWOAR-15996 Add s3.region to biometrics.properties
CHECK_FILE_PARAM '/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties' "${LOG_PATH}" "ITWOAR-15996" "Add s3.region to biometrics.properties" "s3.region=us-gov-west-1"

## ITWOAR-15963 Add properties to biometrics.properties Note: "S-MODE" should have "socom.enabled=false" "ingest-autorun.enabled=true"; "J-MODE" should have just "ingest-autorun.enabled=true"
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties" ${LOG_PATH} "ITWOAR-15963" "Add properties to biometrics.properties" "Present" "S-MODE" "socom.enabled=false" "ingest-autorun.enabled=true"
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties" ${LOG_PATH} "ITWOAR-15963" "Add properties to biometrics.properties" "Present" "J-MODE" "ingest-autorun.enabled=true"

## ITWOAR-15102 Implement postgresql password module (note as of testing this on v115 ac2sp and the dev-head-s server Failed it's commented out and the path is empty)
CHECK_FILE_PARAM '/var/opt/rh/rh-postgresql12/lib/pgsql/data/postgresql.conf' "${LOG_PATH}" "ITWOAR-15102" "Implement postgresql password module" "shared_preload_libraries = '/opt/rh/rh-postgresql12/root/usr/lib64/pgsql/passwordcheck' # (change requires restart)" "dynamic_library_path = '/opt/rh/rh-postgresql12/root/usr/lib64/pgsql'"

## ITWOAR-15984 Updates to servers for renaming "DEBUGGER" role as "OPERATOR"
CHECK_FILE_PARAM '/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties' "${LOG_PATH}" "ITWOAR-15996" "Add s3.region to biometrics.properties" "s3.region=us-gov-west-1"

## ITWOAR-15984 Updates to servers for renaming "DEBUGGER" role as "OPERATOR" - NOTE: multiple checks: Check: operatorWhitelist.txt ; Roles.json ; data.yaml
CHECK_VER "ITWOAR-15984" "Updates to servers for renaming "DEBUGGER" role as "OPERATOR" | Check: operatorWhitelist.txt" ${LOG_PATH} "ls -1 /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/" "operatorWhitelist.txt"
CHECK_FILE_PARAM '/opt/jboss/jboss-eap-7.0/modules/com/leidos/login/main/Roles.json' "${LOG_PATH}" "ITWOAR-15984" "Updates to servers for renaming "DEBUGGER" role as "OPERATOR" | Check: Roles.json" "Operators"
CHECK_FILE_PARAM '/etc/govport/data.yaml' "${LOG_PATH}" "ITWOAR-15984" "Updates to servers for renaming "DEBUGGER" role as "OPERATOR" | Check: data.yaml" "OPERATOR"

## ITWOAR-15993 Update message.properties and biometrics.properties with CUI classification - NOTE: multiple checks:
CHECK_FILE_PARAM '/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/message.properties' "${LOG_PATH}" "ITWOAR-15993" "Update message.properties and biometrics.properties with CUI classification | check: message.properties" "loginClassification:CUI//INTEL/OPSEC//FEDCON"
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties" ${LOG_PATH} "ITWOAR-15993" "Update message.properties and biometrics.properties with CUI classification | check: S-MODE" "Present" "S-MODE" "banner.system.high.sipr=CLASSIFICATIONS REFER TO TEST DATA ONLY; all data CUI//INTEL/OPSEC//FEDCON"
CHECK_MODE_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties" ${LOG_PATH} "ITWOAR-15993" "Update message.properties and biometrics.properties with CUI classification | check: J-MODE" "Present" "J-MODE" "banner.system.high.jwics=CLASSIFICATIONS REFER TO TEST DATA ONLY; all data CUI//INTEL/OPSEC//FEDCON"

## ITWOAR-15998 update biometrics.properties with the intelDocs.softwareUserManual.url= set to blank
CHECK_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties" ${LOG_PATH} "ITWOAR-15998" "Check biometrics.properties intelDocs.softwareUserManual.url is set to blank" 'intelDocs.softwareUserManual.url='

# ITWOAR-16004
CHECK_FILE_PARAM "/opt/jboss/default/standalone/configuration/standalone-full-lab.xml" "${LOG_PATH}" "ITWOAR-16004" "Update standalone XML with new wlmerge bridge settings" "sourceType='TSDB')"

# ITWOAR-16018

## ITWOAR-16031 Add 1 new property to sso.properties(.erb) files for user cache expiry | checking for just the property in the file: "sso.userCache.expiry=2592000000"
CHECK_FILE_PARAM "/opt/jboss/jboss-eap-7.0/modules/com/leidos/login/main/sso.properties" "${LOG_PATH}" "ITWOAR-16031" "Add 1 new property to sso.properties(.erb) files for user cache expiry" "sso.userCache.expiry=2592000000"

#Add checks above this line
sleep 1
echo -e "\e[35m..done!\e[0m\n"
sleep 1
echo -e "\e[32m** Log file location: ${LOG_PATH} **\n\e[0m"
fi

##################### JUNK NOTES: AREA ###############################

#CHECK_GREP_PER_LINE () {
  #$1 absolute path of the file to check
  #$2 absolute Path to the log file example: /var/temp/epic_build_${1}_results.logs
  #$3 JIRA Number
  #$4 JIRA Description
  #$5 Pattern to check
  #$6 What whole line should read
  #$7 What whole line should read option #2


##################### JUNK NOTES: AREA ###############################

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
