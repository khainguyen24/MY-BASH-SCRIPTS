#!/bin/bash
# Utility script that will check epic BUILD items per version
# to run script:
# ./epic_build_check.sh [ v113 | v114 | v115 | v116
#############################################################################################
#########################   CHANGE LOG   ####################################################
# create the template for the script
# add the epic Build jiras to the right sections.. and add a few checks for starters.




####################################################################################################
############################### V113 EPIC BUILD JIRAS ##############################################
####################################################################################################
## ITWOAR-15890
## ITWOAR-15623
## ITWOAR-15743
# ITWOAR-15744
# ITWOAR-15762
# ITWOAR-15778
# ITWOAR-15784
# ITWOAR-15797
## ITWOAR-15655
## ITWOAR-15798
# ITWOAR-15880
# ITWOAR-15890

function ITWOAR-15890 () {
  echo -e "\e[35m********************************************************************"
  echo -e "                             ITWOAR-15890                                "
  echo -e "     *** Create webadmin owned temp folder in /var/i2ar ***"
  echo -e "********************************************************************\e[0m"
  echo -e "\n     *** Create webadmin owned temp folder in /var/i2ar ***\n"
  echo ll /var/i2ar/ | grep temp | grep 'webadmin webadmin' || echo FAILED CHECK - [No /var/i2ar/temp dir found or not owned by webadmin]
  echo -e "\n"
  sleep 1
}

#ITWOAR-15798
# function ITWOAR-15798 () {
#   echo -e "\e[35m********************************************************************"
#   echo -e "                             ITWOAR-15798                                "
#   echo -e "         *** Update standalone.xml to support TLSv1.2 ***"
#   echo -e "********************************************************************\e[0m"
#   v1="$(grep '<property name="https.protocols"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml)"
#   v2="$(grep '<ssl protocol="TLS.*">' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml)"
#   v3="$(grep '<https-listener name="https" secure="true"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml)"
#   v1boo= [ "$v1" == '<property name="https.protocols" value="TLSv1.2"/>' ];
#   v2boo= [ "$v2" == '<ssl protocol="TLSv1.2">' ];
#   v3boo= [ "$v3" == '<https-listener name="https" secure="true" enabled-protocols="TLSv1.2" enabled-cipher-suites="TLS_RSA_WITH_3DES_EDE_CBC_SHA,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA" verify-client="REQUIRED" security-realm="UndertowRealm" socket-binding="https" max-post-size="52428800"/>' ];
#   echo $v3boo
  # if [[ $v1boo,$v2boo,$v3boo == 'true' ]];
  # then
  # echo -e "PASSED CHECK - $v1\n $v2\n $v3"
  # else
  # echo -e "FAILED CHECK - $v1\n $v2\n $v3"
  # fi
  # echo -e "\n"
  # sleep 1
# }

#ITWOAR-15655
function ITWOAR-15655 () {
  echo -e "\e[35m********************************************************************"
  echo -e "                             ITWOAR-15655                               "
  echo -e "                   *** Upgrade JDK to 1.8_291 ***"
  echo -e "********************************************************************\e[0m"
  java -version
  echo -e "\n"
  sleep 1
}

#ITWOAR-15623
function ITWOAR-15623 () {
  echo -e "\e[35m********************************************************************"
  echo -e "                             ITWOAR-15623                               "
  echo -e "     *** Validate the User Data and make domain agnostic ***"
  echo -e "********************************************************************\e[0m"
  echo -e "\n"
  sleep 1
}

#ITWOAR-15798
function ITWOAR-15798 () {
  FILE_PATH='/opt/jboss/default/standalone/configuration/standalone-full-lab.xml'
  GREP_PATTERN_1="'<property name=\"https.protocols\"'"
  GREP_PATTERN_2="'<ssl protocol=\"TLS.*\">'"
  GREP_PATTERN_3="'<https-listener name="https" secure=\"true\"'"
  echo -e "\e[35m********************************************************************"
  echo -e "                             ITWOAR-15798                               "
  echo -e "           *** Update standalone.xml to support TLSv1.2 ***                "
  echo -e "********************************************************************\e[0m"
  #echo ${GREP_PATTERN_1} ${FILE_PATH}
  echo ${GREP_PATTERN_1} ${FILE_PATH}
  echo ${GREP_PATTERN_2} ${FILE_PATH}
  echo ${GREP_PATTERN_3} ${FILE_PATH}
  echo -e "\n"
  sleep 1
}



##############test###################

#parameters check (Script calls for 4 parameters to be passed in)
# if [ "$#" -ne 4 ]
# then
#     echo -e "\nMissing parameter...exiting.\n"
#     echo "How to use this script:"
#     echo "./major_counts_compare_tool.sh <patternList.txt> <BI2R_INPUT_FILE> <I2AR_INPUT_FILE> <outputfilename.txt>"
#     echo -e "\nExample:"
#     echo "./major_counts_compare_tool.sh patternList.txt ATTACHMENTS_PHOTOS.TXT attachments_photos.txt outputfilename.txt"
#     echo -e "\n"
#     exit 1;
#
# else
#     PREFIX_LIST=$1
#     BI2R_INPUT_FILE=$2
#     I2AR_INPUT_FILE=$3
#     OUTPUT_FILE=$4
# fi

##############test###################





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


####################################################################################################
############################### V115 EPIC BUILD JIRAS ##############################################
####################################################################################################


####################################################################################################
############################### V116 EPIC BUILD JIRAS ##############################################
####################################################################################################


####################################################################################################
############################### V117 EPIC BUILD JIRAS ##############################################
####################################################################################################

if [ -z "$1" ]
then
    echo -e "\e[35mMissing parm .. use: v113 | v114 | v115 | v116\e[0m\n"
		sleep 1
		exit 1;
fi
#--------------------------#
# v113 epic BUILD Checks   #
#--------------------------#
if [ $1 = "v113" ]
then
		echo -e "\e[35m\nCheckikng epic BUILD items for ver. V113\e[0m\n"
ITWOAR-15890
ITWOAR-15798
ITWOAR-15655
fi
#---------v113 END---------#

#--------------------------#
# v114 epic BUILD Checks   #
#--------------------------#
if [ $1 = "v114" ]
then
		echo -e "\e[35m\nCheckikng epic BUILD items for ver. V114\e[0m\n"
echo Placehoder for the v114 checks

fi
#---------v114 END---------#

#--------------------------#
# v115 epic BUILD Checks   #
#--------------------------#
if [ $1 = "v115" ]
then
		echo -e "\e[35m\nCheckikng epic BUILD items for ver. V115\e[0m\n"
echo Placehoder for the v115 checks

fi
#---------v115 END---------#

#--------------------------#
# v116 epic BUILD Checks   #
#--------------------------#
if [ $1 = "v116" ]
then
		echo -e "\e[35m\nCheckikng epic BUILD items for ver. V116\e[0m\n"
echo Placehoder for the v116 checks

fi
#---------v116 END---------#
