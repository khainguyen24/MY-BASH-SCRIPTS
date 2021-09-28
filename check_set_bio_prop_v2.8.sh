#!/bin/bash
# Utility script that will check, or set bio.props for BI2R or I2AR ingest
# to run script:
# ./check_set_bio_prop.sh [ check | bi2r | i2ar | reindex-bids-107.1 | reindex-bids-108.1 | reindex-tsdb-sensors | trans ]
# change logs
# 04/13/2021 - adding new switch reindex-tsdb-sensors
# Modified to test v108.1 TSDB and Sensor testing
# added switch trans for Transactional setup on the ingest server
# removed wl-hits.enabled= it's not the correct property name and was doing nothing replacing with ingest-wlhits.enabled
# removed wl-export.enabled= not the correct property name. replacing with ingest-wlexport.enabled=
# 7-13-2021 added more properties to check for post-processing
# stripping all flags except 'check'
# adding function to grab the list of rpms

#create arrays of properties to check
  ARRAY_1=(
  syphon.originalImporter=
  ingest.originalImporter=
  smtp.enabled=
  ingest-sg-events.enabled=
  ingest-atp.enabled=
  ingest-orphan.runDailyCheck=
  ingest-orphan.enabled=
  ingest-pubxml.enabled=
  scanner.enabled=
  ingest-solr.enabled=
  syphon.enabled=
  ingest-twpdes.enabled=
  ingest-twpdes.bypass=
  twpdes-merge.bypass=
  ingest-wlhits.enabled=
  ingest-wlexport.createWatchml=
  ingest-wlexport.enabled=
  ingest-wlexport.publishWatchml=
  ingest-wlexport.disseminationEnabled=
  ingest-wlexport.fileWriteEnabled=
  wl-merge.bypass=
  wl-merge.enabled=
  xdom.receiver.import.run=
  ingest.clamd.enabled=
  # other properties not on the J-Mode list for Post-processing
  ingest-purge.enabled=
  ingest-autorun.enabled=
  socom.enabled=
  wl-config-updater.enabled=
  xdom.enabled
  # some other ones
  ingest.systemMode=
  iafis.ingestNoMatch=
  ingest-wlhits.useBridgeQueue=
  #fake or doesn't do anything
  twpdes-merge.enabled=
  autorun.data-masking.enabled=
  autorun.ori-ignore.enabled=
  # adding other properties that should be overwritten in Foreman
  sourceHigh.classifications=
  default.ori.classifications=
  lov.config.initialIdSeed=
  )
#USAGE_MESSAGE="$(echo 'run the script agian use: check')"

#Check enabled bridges in the standalone-full-lab.xml
function CHECK_STANDALONE_BRIDGES () {
  echo -e "\e[35m********************************************************************"
  echo -e "        Current enabled 'bridges' in standalone-full-lab.xml        "
  echo -e "********************************************************************\e[0m"
  grep bridge /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
  echo -e "\n"
  sleep 1
}

#File in jboss deployments dir check
function CHECK_DEPLOYMENTS () {
  echo -e "\e[35m********************************************************************"
  echo -e "      Current deployed wars in the standalone/deployement dir       "
  echo -e "********************************************************************\e[0m"
  echo -e "\n     *** Verify that ONLY the desired wars are present ***\n"
  ls -1 /opt/jboss/default/standalone/deployments
  echo -e "\n"
  sleep 1
}

#I2AR rpm check
function CHECK_I2AR_RPM () {
  echo -e "\e[35m********************************************************************"
  echo -e "                  Current installed I2AR rpms       "
  echo -e "********************************************************************\e[0m"
  echo -e "\n     *** Verify that ONLY the desired rpm and version were installed according to the type of server ie.. "BULK Ingest" "Ingest" "Index" "Transactional"  ***\n"
  rpm -qa | grep i2ar
  echo -e "\n"
  sleep 1
}

#Server's Hardware
function CHECK_HARDWARE () {
  echo -e "\e[35m********************************************************************"
  echo -e "                  Current Server's Hardware       "
  echo -e "********************************************************************\e[0m"
  lshw -short
  echo -e "\n"
  sleep 1
}

#Server's Ulimit
function CHECK_ULIMIT () {
  echo -e "\e[35m********************************************************************"
  echo -e "                  Current Server's Ulimit       "
  echo -e "********************************************************************\e[0m"
  ulimit -Hn -Sn
  echo -e "\n"
  sleep 1
}

#Server's Ulimit
function CHECK_JBOSS_MEM () {
  echo -e "\e[35m********************************************************************"
  echo -e "              Current Server's Jboss Memory Allocation      "
  echo -e "********************************************************************\e[0m"
  ps -ef | grep jboss | egrep 'Xms|Xmx|XX:MetaspaceSize|XX:MaxMetaspaceSize'
  echo -e "\n"
  sleep 1
}

#Server's xdom.properties
function CHECK_XDOM_PROP () {
  echo -e "\e[35m********************************************************************"
  echo -e "              Current Server's xdom.properties values      "
  echo -e "********************************************************************\e[0m"
  echo -e "\n*** Verify that values are properly set for Low side and High side  ***\n"
  grep 'xdom\.' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/xdom.properties
  echo -e "\n"
  sleep 1
}

#1-Check bio.prop configs
		function CHECK_BIO_PROP () {
    echo -e "\e[35m********************************************************************"
    echo -e "                   Current Bio.prop settings                        "
    echo -e "********************************************************************\e[0m"
    grep ${ARRAY_1[0]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		grep ${ARRAY_1[1]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		grep ${ARRAY_1[2]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		grep ${ARRAY_1[3]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		grep ${ARRAY_1[4]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[5]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[6]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[7]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[8]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[9]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[10]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[11]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[12]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[13]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[14]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[15]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		grep ${ARRAY_1[16]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		grep ${ARRAY_1[17]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		grep ${ARRAY_1[18]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		grep ${ARRAY_1[19]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[20]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[21]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[22]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[23]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[24]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
#added more for post-processing
    grep ${ARRAY_1[25]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[26]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[27]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[28]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[29]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[30]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[31]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[32]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[33]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[34]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[35]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[36]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[37]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties

		sleep 1
    echo -e "\n"

    #Check enabled bridges in the standalone-full-lab.xml
    CHECK_STANDALONE_BRIDGES
    CHECK_DEPLOYMENTS
    CHECK_I2AR_RPM
    CHECK_HARDWARE
    CHECK_ULIMIT
    CHECK_JBOSS_MEM
    CHECK_XDOM_PROP
    #echo ${USAGE_MESSAGE}
    echo -e "\e[35m********************************************************************"
    echo -e "                                  End                                   "
    echo -e "********************************************************************\e[0m"
		}


if [ -z "$1" ]
then
    echo -e "\e[35mMissing parm .. use: check\e[0m\n"
		sleep 1
		exit 1;
fi
#---------------------------
#the check flag
if [ $1 = "check" ]
then
		echo -e "\e[35m\nCheckikng bio.prop, standalone-full-lab.xml, rpm and deployemnts..\e[0m\n"
CHECK_BIO_PROP

fi
#---------------------------
