#!/bin/bash
# Utility script that will check, or set bio.props for BI2R or I2AR ingest
# to run script:
# ./check_set_bio_prop.sh [ check | bi2r | i2ar | reindex-bids | reindex-tsdb-sensors | reindex-bids-108.1]
# change logs
# 04/13/2021 - adding new switch reindex-tsdb-sensors
# Modified to test v108.1 TSDB and Sensor testing

#create arrays of properties to check
  ARRAY_1=(
  iafis.ingestNoMatch=
  wl-merge.bypass=
  syphon.originalImporter=
  ingest.originalImporter=
  ingest.systemMode=
  ingest-twpdes.bypass=
  ingest.clamd.enabled=
  #adding properties called out in Pauls rig for reindexing.. Note the "enable ones i've moved to the bottom to match v108.1 bio.prop""
  ingest-orphan.runDailyCheck=
  wl-hits.enabled=
  ingest-wlhits.useBridgeQueue=
  wl-export.enabled=
  ingest-wlexport.createWatchml=
  #adding more of the v108.1 enable Properties
  autorun.data-masking.enabled=
  autorun.ori-ignore.enabled=
  ingest-atp.enabled=
  ingest-orphan.enabled=
  ingest-pubxml.enabled=
  ingest-purge.enabled=
  ingest-sg-events.enabled=
  ingest-solr.enabled=
  ingest-twpdes.enabled=
  ingest-wlexport.enabled=
  ingest-wlhits.enabled=
  scanner.enabled=
  syphon.enabled=
  twpdes-merge.enabled=
  wl-merge.enabled=
  )
USAGE_MESSAGE="$(echo 'To set bio.prop values for BI2R or I2AR... run the script agian use: check | bi2r | i2ar | reindex-bids | reindex-tsdb-sensors | reindex-bids-108.1')"

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


#add properties to bio.prop
function ADD_PROPERTIES () {
  echo -e "\e[35m********************************************************************"
  echo -e "            Adding Properties to the biometrics.properties file           "
  echo -e "********************************************************************\e[0m"
  echo -e "\n*** The following properties were appended to the biometircs.properties file ***\n"
  echo "### added by check_set_bio_prop_v2.4.sh ###
ingest-orphan.enabled=false
ingest-twpdes.enabled=false
ingest.originalImporter=I2AR
wl-merge.enabled=false
wl-hits.enabled=false
wl-export.enabled=false" | tee -a /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
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
    grep ${ARRAY_1[25]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
    grep ${ARRAY_1[26]} /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties

		sleep 1
    echo -e "\n"
    #echo 'To set bio.prop values for BI2R or I2AR... run the script agian use: check | bi2r | i2ar | reindex-bids'

    #Check enabled bridges in the standalone-full-lab.xml
    CHECK_STANDALONE_BRIDGES
    CHECK_DEPLOYMENTS
    echo ${USAGE_MESSAGE}
		}


if [ -z "$1" ]
then
    echo -e "\e[35mMissing parm .. use: check | bi2r | i2ar | reindex-bids | reindex-tsdb-sensors | reindex-bids-108.1\e[0m"
		sleep 1
		exit 1;
fi
#---------------------------
#the check flag
if [ $1 = "check" ]
then
		echo -e "\e[35m\nCheckikng bio.prop, standalone-full-lab.xml and deployemnts..\e[0m\n"
CHECK_BIO_PROP

fi
#---------------------------

#2-Set bio.prop to BI2R
if [ $1 = "bi2r" ]
then
    echo -e "\e[35m\nSetting bio.prop values, standalone-full-lab.xml and deployemnts for bi2r ingest...\e[0m\n"

		function set_properties_BI2R () {
		sed -i -e 's/^iafis.ingestNoMatch=.*/iafis.ingestNoMatch=true/g' -e 's/^wl-merge.bypass=.*/wl-merge.bypass=true/g' -e 's/^syphon.originalImporter=.*/syphon.originalImporter=BI2R/g' -e 's/^ingest.systemMode=.*/ingest.systemMode=BulkIngest/g' -e 's/^ingest-twpdes.bypass=.*/ingest-twpdes.bypass=true/g' -e 's/^ingest.clamd.enabled=.*/ingest.clamd.enabled=false/g' -e 's/^ingest.originalImporter=.*/ingest.originalImporter=BI2R/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		}
		set_properties_BI2R
		sleep 1

#Check bio.prop configs
		CHECK_BIO_PROP
		sleep 1
		exit 0;

fi

#---------------------------

#3-Set bio.prop to I2AR
if [ $1 = "i2ar" ]
then
    echo -e "\e[35m\nSetting bio.prop values, standalone-full-lab.xml and deployemnts for i2ar ingest...\e[0m\n"

		function set_properties_I2AR () {
      sed -i -e 's/^iafis.ingestNoMatch=.*/iafis.ingestNoMatch=false/g' -e 's/^wl-merge.bypass=.*/wl-merge.bypass=false/g' -e 's/^syphon.originalImporter=.*/syphon.originalImporter=I2AR/g' -e 's/^ingest.systemMode=.*/ingest.systemMode=Normal/g' -e 's/^ingest-twpdes.bypass=.*/ingest-twpdes.bypass=false/g' -e 's/^ingest.clamd.enabled=.*/ingest.clamd.enabled=true/g' -e 's/^ingest.originalImporter=.*/ingest.originalImporter=I2AR/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		}
		set_properties_I2AR
		sleep 1

#Check bio.prop configs
		CHECK_BIO_PROP
		sleep 1
		exit 0;
fi
#---------------------------


#4-Set bio.prop for BI2R  "reindex-bids"
if [ $1 = "reindex-bids" ]
then
    #add properties to bio.prop
    ADD_PROPERTIES

    #1a Prep for full BID reindexing #SZ - running main.pl (2nd ingest) will remove all bridges from the file /opt/jboss/default/standalone/configuration/standalone-full-lab.xml.  You should restore the original "standalone-full-lab.xml.original" back to the standalone-full-lab.xml
    function RESTORE_STANDALONE_FULL_LAB_ORIG () {
      echo -e "\e[35mRestoring standalone-full-lab.xml from backup standalone-full-lab.xml.original..\e[0m"
      rm -vf /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      cp -vrp /opt/jboss/default/standalone/configuration/standalone-full-lab.xml.original /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    function RESTORE_DEPLOYMENTS_BAK () {
      echo -e "\e[35mRestoring deployments.bak -> standalone/deployments dir...\e[0m"
      cp -vrp /opt/jboss/default/standalone/deployments.bak/* /opt/jboss/default/standalone/deployments
      echo -e "\e[35m...done!\e[0m\n"
    }

      #0a) make sure that the XDOM -S bridge queue is re-removed
    function REMOVE_XDOM-S_BRIDGE () {
      echo -e "\e[35mMaking sure that the XDOM -S bridge queue is re-removed from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="xdomBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="xdomBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #a) refClients: unsubscribe the idml clientId before we process BIDs -SZ IMPORTANT NOTE: if the server is restarted then refClient is automatically  starts up and resubscribes
    function DISABLING_REFCLIENT_IDML () {
      echo -e "\e[35mDisabling the IDML Refclient..\e[0m\n"
      echo -e "\e[35mStopping the idml refclient..\e[0m"
      systemctl stop idml
      sleep 5
      echo -e "\e[35mVerifying idml has stopped.. should see "Active: failed"\e[0m"
      sleep 1
      systemctl status idml
      echo -e "\e[35m...done!\e[0m\n"
      echo -e "\e[35mUnsubscribe to the idml clientID..\e[0m"
      cd /opt/BirEsbReferenceClient; /usr/bin/java -Xms256m -Xmx512m -jar /opt/BirEsbReferenceClient/referenceClient.jar -p /opt/BirEsbReferenceClient/subscriber_idml.properties -a unsubscribe
      sleep 2
      echo -e "\e[35mMake sure you see unsubscribe message in log file ie.. cat /var/i2ar/esb/idml/client.log\e[0m"
      echo -e "\e[35mShould see:  “Info - Client exeJar_jps_referenceClient_idml has successfully unsubscribed from  ssl://localhost:61616…”\e[0m"
      tail -n 11 /var/i2ar/esb/idml/client.log
      echo -e "\e[35m...done!\e[0m\n"
}
#---------------------
#---------------------
    #b) disable ingest-twpdes) "Removing twpdesBridge from standalone-full-lab.xml.."
    function REMOVE_TWPDES_BRIDGES () {
      echo -e "\e[35mRemoving twpdesBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="twpdesBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="twpdesBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #b) disable ingest-twpdes) "Removing twpdesMergeBridge from standalone-full-lab.xml.."
    function REMOVE_TWPDESMERGE_BRIDGES () {
      echo -e "\e[35mRemoving twpdesMergeBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="twpdesMergeBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="twpdesMergeBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #Undeploy ingest-twpdes.war"
    function UNDEPLOY_INGEST-TWPDES-WAR () {
      echo -e "\e[35mBacking up and Undeploying the ingest-twpdes.war ..\e[0m"
      mkdir -v /opt/jboss/default/standalone/deployments.backup_Reindexing
      mv -v /opt/jboss/default/standalone/deployments/ingest-twpdes.war* /opt/jboss/default/standalone/deployments.backup_Reindexing
      echo -e "\e[35m...done!\e[0m\n"
    #Setting bio.prop ingest-twpdes.enabled=False
      echo -e "\e[35mSetting bio.prop ingest-twpdes.enabled=false ..\e[0m"
      sed -i -e 's/^ingest-twpdes.enabled=.*/ingest-twpdes.enabled=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'ingest-twpdes.enabled=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      echo -e "\e[35m...done!\e[0m\n"
    }
#---------------------
#---------------------
    #c) disable ingest-orphan) "Removing orphanBridge from standalone-full-lab.xml.."
    function REMOVE_ORPHANBRIDGE () {
      echo -e "\e[35mRemoving orphanBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="orphanBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="orphanBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #Undeploy ingest-orphan.war"
    function UNDEPLOY_INGEST-ORPHAN-WAR () {
      echo -e "\e[35mBacking up and Undeploying the ingest-orphan.war ..\e[0m"
      #mkdir -v /opt/jboss/default/standalone/deployments.backup_Reindexing
      mv -v /opt/jboss/default/standalone/deployments/ingest-orphan.war* /opt/jboss/default/standalone/deployments.backup_Reindexing
      echo -e "\e[35m...done!\n"
    #Setting bio.prop ingest-twpdes.enabled=False
      echo -e "\e[35mSetting bio.prop ingest-orphan.enabled=false ..\e[0m"
      sed -i -e 's/^ingest-orphan.enabled=.*/ingest-orphan.enabled=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'ingest-orphan.enabled=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      echo -e "\e[35m...done!\e[0m\n"
    }
#---------------------
#---------------------
    #d) disable wl-merge) "Removing wlmergeBridge from standalone-full-lab.xml.."
    function REMOVE_WLMERGEBRIDGE () {
      echo -e "\e[35mRemoving wlmergeBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="wlmergeBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="wlmergeBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #Undeploy wl-merge.war"
    function UNDEPLOY_WL-MERGE-WAR () {
      echo -e "\e[35mBacking up and Undeploying the wl-merge.war ..\e[0m"
      #mkdir -v /opt/jboss/default/standalone/deployments.backup_Reindexing
      mv -v /opt/jboss/default/standalone/deployments/wl-merge.war* /opt/jboss/default/standalone/deployments.backup_Reindexing
      echo -e "\e[35m...done!\e[0m\n"
    #Setting bio.prop wl-merge.enabled=false
      echo -e "\e[35mSetting bio.prop wl-merge.enabled=false ..\e[0m"
      sed -i -e 's/^wl-merge.enabled=.*/wl-merge.enabled=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'wl-merge.enabled=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      echo -e "\e[35m...done!\e[0m\n"
    }
#---------------------
#---------------------
    #d) disable wl-hits) "Removing wlhitsBridge from standalone-full-lab.xml.."
    function REMOVE_WLHITSBRIDGE () {
      echo -e "\e[35mRemoving wlhitsBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="wlhitsBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="wlhitsBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #Undeploy wl-hits.war"
    function UNDEPLOY_WL-HITS-WAR () {
      echo -e "\e[35mBacking up and Undeploying the wl-hits.war ..\e[0m"
      #mkdir -v /opt/jboss/default/standalone/deployments.backup_Reindexing
      mv -v /opt/jboss/default/standalone/deployments/wl-hits.war* /opt/jboss/default/standalone/deployments.backup_Reindexing
      echo -e "\e[35m...done!\e[0m\n"
    #Setting bio.prop  wl-hits.enabled=false – SZ "ingest-wlhits.useBridgeQueue=false"
      echo -e "\e[35mSetting bio.prop wl-hits.enabled=false and ingest-wlhits.useBridgeQueue=false ..\e[0m"
      sed -i -e 's/^wl-hits.enabled=.*/wl-hits.enabled=false/g' -e 's/^ingest-wlhits.useBridgeQueue=.*/ingest-wlhits.useBridgeQueue=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'wl-hits.enabled=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'ingest-wlhits.useBridgeQueue=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      echo -e "\e[35m...done!\e[0m\n"
    }
#---------------------
#---------------------
    #d) disable wl-export) "Removing wl-export from standalone-full-lab.xml.."
    function REMOVE_WLEXPORTBRIDGE () {
      echo -e "\e[35mRemoving wlexportBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="wlexportBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="wlexportBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #Undeploy wl-export.war"
    function UNDEPLOY_WL-EXPORT-WAR () {
      echo -e "\e[35mBacking up and Undeploying the wl-export.war ..\e[0m"
      #mkdir -v /opt/jboss/default/standalone/deployments.backup_Reindexing
      mv -v /opt/jboss/default/standalone/deployments/wl-export.war* /opt/jboss/default/standalone/deployments.backup_Reindexing
      echo -e "\e[35m...done!\e[0m\n"
    #Setting bio.prop  wl-export.enabled=false – SZ "ingest-wlexport.createWatchml=false"
      echo -e "\e[35mSetting wl-export.enabled=false and ingest-wlexport.createWatchml=false ..\e[0m"
      sed -i -e 's/^wl-export.enabled=.*/wl-export.enabled=false/g' -e 's/^ingest-wlexport.createWatchml=.*/ingest-wlexport.createWatchml=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'wl-export.enabled=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'ingest-wlexport.createWatchml=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      echo -e "\e[35m...done!\e[0m\n"
    }
#---------------------
    #Set bio.prop for reindexing bi2r data
		function set_properties_reindex-bids () {
      echo -e "\e[35m\nSetting bio.prop general values for 'reindex-bids' bi2r data...\e[0m\n"
		  sed -i -e 's/^iafis.ingestNoMatch=.*/iafis.ingestNoMatch=true/g' -e 's/^wl-merge.bypass=.*/wl-merge.bypass=true/g' -e 's/^syphon.originalImporter=.*/syphon.originalImporter=I2AR/g' -e 's/^ingest.systemMode=.*/ingest.systemMode=Normal/g' -e 's/^ingest-twpdes.bypass=.*/ingest-twpdes.bypass=true/g' -e 's/^ingest.clamd.enabled=.*/ingest.clamd.enabled=false/g'  -e 's/^ingest.originalImporter=.*/ingest.originalImporter=I2AR/g' -e 's/^ingest-orphan.enabled=.*/ingest-orphan.enabled=false/g' -e 's/^ingest-orphan.runDailyCheck=.*/ingest-orphan.runDailyCheck=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		}

    #g) clean out jboss/standalone/data/activemq
    function CLEAN_OUT_ACTIVEMQ () {
      echo -e "\e[35m\nCleaning out activmq directory...\e[0m\n"
      rm -vrf /opt/jboss/default/standalone/data/activemq/*
      rm -f /opt/jboss/default/standalone/deployments/{*.failed,*.deployed}
      echo -e "\e[35m...done!\e[0m\n"
    }

    #File in jboss deployments dir check
    function MOVE_WARS_4_REINDEXING-BIDS () {
      echo -e "\e[35m\nMoving unwanted wars to backup...\e[0m\n"
      mv -v /opt/jboss/default/standalone/deployments/{attachments-ws.war,event-smtp.war,idltService.war,ingest-autorun.war,ingest-purge.war,ingest-scanner.war,ingest-syphon.war,ingest-wl-hits.war,legacyUi.war,loginUi.war,productService.war,socom.war,solrSearchService.war,uamtService.war,userService.war,usptService.war,watchlistService.war,xdom-dashboard.war,xdom-receiver.war,xdom-bundler.war,xdom-monitor.war} /opt/jboss/default/standalone/deployments.backup_Reindexing/
      echo -e "\e[35m...done!\e[0m\n"
    }

    #File in jboss deployments dir check (moved out of this section so other flags can use it)
    #Check enabled bridges in the standalone-full-lab.xml (moved out of this section so other flags can use it)


##### Run Stuff within -reindex-bids flag #####
RESTORE_STANDALONE_FULL_LAB_ORIG
RESTORE_DEPLOYMENTS_BAK
REMOVE_XDOM-S_BRIDGE
DISABLING_REFCLIENT_IDML
REMOVE_TWPDES_BRIDGES
REMOVE_TWPDESMERGE_BRIDGES
UNDEPLOY_INGEST-TWPDES-WAR
REMOVE_ORPHANBRIDGE
UNDEPLOY_INGEST-ORPHAN-WAR
REMOVE_WLMERGEBRIDGE
UNDEPLOY_WL-MERGE-WAR
REMOVE_WLHITSBRIDGE
UNDEPLOY_WL-HITS-WAR
REMOVE_WLEXPORTBRIDGE
UNDEPLOY_WL-EXPORT-WAR
set_properties_reindex-bids
CLEAN_OUT_ACTIVEMQ
MOVE_WARS_4_REINDEXING-BIDS
sleep 1

#Check bio.prop configs
		CHECK_BIO_PROP
    echo -e "\n"
    echo -e "\e[35m\n*** NOTE: You will need to modifiy the standalone-full-lab.xml prior to kicking off the Reindexing of Bids.. ie. create jmsUser, disable security and ApplicationRelam settings. ***\e[0m\n"
		sleep 1
		exit 0;

fi

#---------------------
#---------------------
# 5) Re-enable disabled services or deploy undeployed services. "TSDB and SENSORS"
if [ $1 = "reindex-tsdb-sensors" ]
then
  echo -e "\e[35m*********************************************************************************************"
  echo -e " Re-enable disabled services or deploy undeployed services for Indexing "TSDB and SENSORS" "
  echo -e "*********************************************************************************************\e[0m"
  sleep 1
  #) backing up the standalone-full-lab.xml before messing with it.."
      function BACKUP_STANDANLONE_FULL_LAB () {
        echo -e "\e[35mBacking standalone-full-lab.xml before messing with it..\e[0m"
        cp -rpv /opt/jboss/default/standalone/configuration/standalone-full-lab.xml /opt/jboss/default/standalone/configuration/standalone-full-lab.xml_b4_tsdb_sensors_config
        sleep 1
        echo -e "\e[35m...done!\e[0m\n"
}
      #c) add wlexportBridge) "ADD wlexportBridge to standalone-full-lab.xml.."
      function ADD_WLEXPORTBRIDGE () {
        echo -e "\e[35mAdding wlexportBridge to standalone-full-lab.xml..\e[0m"
        sed -i '/<target destination="\/queue\/com.leidos.mb.solr.EventQueue"/a\            <\/jms-bridge>\n            <jms-bridge name="wlexportBridge" add-messageID-in-header="true" client-id="wlexportBridgeClient" subscription-name="wlexport" selector="type IN ('\''TSDB'\'','\''BAT'\'','\''BAT-CXI'\'','\''Sensor'\'','\''EntityEdit'\'', '\''UspTrackerData'\'','\''WatchlistEntry'\'','\''I2AR-MatchML'\'','\''Attribute'\'') AND state='\''Linked'\'' AND (routing IS NULL OR routing LIKE '\''%[wlexport]%'\'')" max-batch-time="500" max-batch-size="500" max-retries="1" failure-retry-interval="500" quality-of-service="DUPLICATES_OK">\n                <source destination="topic\/com.leidos.mb.spi.event.NotificationBus" connection-factory="java:\/ConnectionFactory"/>\n                <target destination="\/queue\/com.leidos.mb.wlexport.EventQueue" connection-factory="java:\/ConnectionFactory"\/>' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
        sleep 1
        echo -e "\e[35m...done!\e[0m\n"
  }

      #a) add twpdesBridge) "ADD twpdesBridge to standalone-full-lab.xml.."
      function ADD_TWPDES_BRIDGES () {
        echo -e "\e[35mAdding twpdesBridge to standalone-full-lab.xml..\e[0m"
        sed -i '/<target destination="\/queue\/com.leidos.mb.wlexport.EventQueue"/a\            <\/jms-bridge>\n            <jms-bridge name="twpdesBridge" add-messageID-in-header="true" client-id="twpdesBridgeClient" subscription-name="twpdes" selector="(type='\''TSDB'\'' OR type='\''Sensor'\'') AND state='\''Linked'\'' AND (routing IS NULL OR routing LIKE '\''%[twpdes]%'\'')" max-batch-time="500" max-batch-size="500" max-retries="1" failure-retry-interval="500" quality-of-service="DUPLICATES_OK">\n                <source destination="topic\/com.leidos.mb.spi.event.NotificationBus" connection-factory="java:\/ConnectionFactory"\/>\n                <target destination="\/queue\/com.leidos.mb.twpdes.EventQueue" connection-factory="java:\/ConnectionFactory"\/>' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
        sleep 1
        echo -e "\e[35m...done!\e[0m\n"
      }

      #a) ADD twpdesMergeBridge) "ADD twpdesMergeBridge to standalone-full-lab.xml.."
      function ADD__TWPDESMERGE_BRIDGES () {
        echo -e "\e[35mAdding twpdesMergeBridge to standalone-full-lab.xml..\e[0m"
        sed -i '/<target destination="\/queue\/com.leidos.mb.atp.EventQueue"/a\            <\/jms-bridge>\n            <jms-bridge name="twpdesMergeBridge" add-messageID-in-header="true" client-id="twpdesMergeBridgeClient" subscription-name="twpdesMerge" selector="type IN ('\''Merged'\'','\''Unmerged'\'')" max-batch-time="500" max-batch-size="500" max-retries="1" failure-retry-interval="500" quality-of-service="DUPLICATES_OK">\n                <source destination="topic\/com.leidos.mb.sg.MergeEventBus" connection-factory="java:\/ConnectionFactory"\/>\n                <target destination="\/queue\/com.leidos.mb.twpdes.merge.EventQueue" connection-factory="java:\/ConnectionFactory"\/>' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
        sleep 1
        echo -e "\e[35m...done!\e[0m\n"
      }

      #b) add wlmergeBridge) "ADD wlmergeBridge to standalone-full-lab.xml.."
      function ADD_WLMERGEBRIDGE () {
        echo -e "\e[35mAdding wlmergeBridge to standalone-full-lab.xml..\e[0m"
        sed -i '/<target destination="\/queue\/com.leidos.mb.sg.EventQueue"/a\            <\/jms-bridge>\n            <jms-bridge name="wlmergeBridge" add-messageID-in-header="true" client-id="wlmergeBridgeClient" subscription-name="wlmerge" selector="type='\''Merged'\''" max-batch-time="500" max-batch-size="500" max-retries="1" failure-retry-interval="500" quality-of-service="DUPLICATES_OK">\n                <source destination="topic\/com.leidos.mb.sg.MergeEventBus" connection-factory="java:\/ConnectionFactory"\/>\n                <target destination="\/queue\/com.leidos.mb.wlmerge.EventQueue" connection-factory="java:\/ConnectionFactory"\/>' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
        sleep 1
        echo -e "\e[35m...done!\e[0m\n"
      }

      #Redeploy ingest-twpdes.war,wl-merge.war,wl-export.war"
      function REDEPLOY_WARS_FOR_TSDB_SENSORS () {
        echo -e "\e[35mRedeploying wars to Index TSDB and SENSORS: ingest-twpdes.war, wl-merge.war, wl-export.war ..\e[0m"
        cp -rpv /opt/jboss/default/standalone/deployments.backup_Reindexing/{ingest-twpdes.war,wl-merge.war,wl-export.war} /opt/jboss/default/standalone/deployments/
        sleep 1
        echo -e "\e[35m...done!\e[0m\n"
      }

      #Enabling bio.props for Indexing TSDB and sensors
      function SET_BIOPROP_FOR_TSDB_SENSORS () {
        echo -e "\e[35mSetting bio.prop properties for Indexing TSDB and sensors ..\e[0m"
        sed -i -e 's/^ingest-twpdes.enabled=.*/ingest-twpdes.enabled=true/g' -e 's/^wl-merge.enabled=.*/wl-merge.enabled=true/g' -e 's/^wl-export.enabled=.*/wl-export.enabled=true/g' -e 's/^ingest-wlexport.createWatchml=.*/ingest-wlexport.createWatchml=true/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
        sleep 1
        echo -e "\e[35m...done!\e[0m\n"
  		}

#RUN Stuff
BACKUP_STANDANLONE_FULL_LAB
ADD_WLEXPORTBRIDGE
ADD_TWPDES_BRIDGES
ADD__TWPDESMERGE_BRIDGES
ADD_WLMERGEBRIDGE
REDEPLOY_WARS_FOR_TSDB_SENSORS
SET_BIOPROP_FOR_TSDB_SENSORS
#Check configurations after
CHECK_BIO_PROP
    echo -e "\n"
    echo -e "\e[35m\n*** NOTE: You will need to Confirm that services are re-enabled by looking at the sys/systemStatus page and the sys/queues page. ***\e[0m\n"
    echo -e "\e[35m\n*** If all looks good.. push a CategoryDirectives.xml to the borg table and then you can proceed with step "7 Catch-up TWPDES" ***\e[0m\n"
		sleep 1
		exit 0;

fi



#################################################################################################################
#################################################################################################################
########################### Modified to test TSDB and Sensors after the v108.1 upgrade ##########################
#################################################################################################################
#################################################################################################################
#4-Set bio.prop for BI2R  "reindex-bids"
if [ $1 = "reindex-bids-108.1" ]
then
    #add properties to bio.prop
    #ADD_PROPERTIES
    #add properties to bio.prop
    function ADD_v108_1_PROPERTIES () {
      echo -e "\e[35m********************************************************************"
      echo -e "  Adding Missing Properties to the biometrics.properties file for v108.1   "
      echo -e "********************************************************************\e[0m"
      echo -e "\n*** The following properties were appended to the biometircs.properties file they are in Paul's Rig for reindexing instructions but not present in the bio.prop v108.1 ***\n"
      echo "### added by check_set_bio_prop_v2.4_modified.sh ###
wl-hits.enabled=false
wl-export.enabled=false" | tee -a /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      echo -e "\n"
      sleep 1
    }
    #1a Prep for full BID reindexing #SZ - running main.pl (2nd ingest) will remove all bridges from the file /opt/jboss/default/standalone/configuration/standalone-full-lab.xml.  You should restore the original "standalone-full-lab.xml.original" back to the standalone-full-lab.xml
    function RESTORE_STANDALONE_FULL_LAB_ORIG () {
      echo -e "\e[35mRestoring standalone-full-lab.xml from backup standalone-full-lab.xml.original..\e[0m"
      rm -vf /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      cp -vrp /opt/jboss/default/standalone/configuration/standalone-full-lab.xml.original /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    function RESTORE_DEPLOYMENTS_BAK () {
      echo -e "\e[35mRestoring deployments.bak -> standalone/deployments dir...\e[0m"
      cp -vrp /opt/jboss/default/standalone/deployments.bak/* /opt/jboss/default/standalone/deployments
      echo -e "\e[35m...done!\e[0m\n"
    }

      #0a) make sure that the XDOM -S bridge queue is re-removed
    function REMOVE_XDOM-S_BRIDGE () {
      echo -e "\e[35mMaking sure that the XDOM -S bridge queue is re-removed from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="xdomBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="xdomBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #a) refClients: unsubscribe the idml clientId before we process BIDs -SZ IMPORTANT NOTE: if the server is restarted then refClient is automatically  starts up and resubscribes
    function DISABLING_REFCLIENT_IDML () {
      echo -e "\e[35mDisabling the IDML Refclient..\e[0m\n"
      echo -e "\e[35mStopping the idml refclient..\e[0m"
      systemctl stop idml
      sleep 5
      echo -e "\e[35mVerifying idml has stopped.. should see "Active: failed"\e[0m"
      sleep 1
      systemctl status idml
      echo -e "\e[35m...done!\e[0m\n"
      echo -e "\e[35mUnsubscribe to the idml clientID..\e[0m"
      cd /opt/BirEsbReferenceClient; /usr/bin/java -Xms256m -Xmx512m -jar /opt/BirEsbReferenceClient/referenceClient.jar -p /opt/BirEsbReferenceClient/subscriber_idml.properties -a unsubscribe
      sleep 2
      echo -e "\e[35mMake sure you see unsubscribe message in log file ie.. cat /var/i2ar/esb/idml/client.log\e[0m"
      echo -e "\e[35mShould see:  “Info - Client exeJar_jps_referenceClient_idml has successfully unsubscribed from  ssl://localhost:61616…”\e[0m"
      tail -n 11 /var/i2ar/esb/idml/client.log
      echo -e "\e[35m...done!\e[0m\n"
}
#---------------------
#---------------------
    #b) disable ingest-twpdes) "Removing twpdesBridge from standalone-full-lab.xml.."
    function REMOVE_TWPDES_BRIDGES () {
      echo -e "\e[35mRemoving twpdesBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="twpdesBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="twpdesBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #b) disable ingest-twpdes) "Removing twpdesMergeBridge from standalone-full-lab.xml.."
    function REMOVE_TWPDESMERGE_BRIDGES () {
      echo -e "\e[35mRemoving twpdesMergeBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="twpdesMergeBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="twpdesMergeBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #Undeploy ingest-twpdes.war"
    function UNDEPLOY_INGEST-TWPDES-WAR () {
      echo -e "\e[35mBacking up and Undeploying the ingest-twpdes.war ..\e[0m"
      mkdir -v /opt/jboss/default/standalone/deployments.backup_Reindexing
      mv -v /opt/jboss/default/standalone/deployments/ingest-twpdes.war* /opt/jboss/default/standalone/deployments.backup_Reindexing
      echo -e "\e[35m...done!\e[0m\n"
    #Setting bio.prop ingest-twpdes.enabled=False
      echo -e "\e[35mSetting bio.prop ingest-twpdes.enabled=false ..\e[0m"
      sed -i -e 's/^ingest-twpdes.enabled=.*/ingest-twpdes.enabled=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'ingest-twpdes.enabled=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      echo -e "\e[35m...done!\e[0m\n"
    }
#---------------------
#---------------------
    #c) disable ingest-orphan) "Removing orphanBridge from standalone-full-lab.xml.."
    function REMOVE_ORPHANBRIDGE () {
      echo -e "\e[35mRemoving orphanBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="orphanBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="orphanBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #Undeploy ingest-orphan.war"
    function UNDEPLOY_INGEST-ORPHAN-WAR () {
      echo -e "\e[35mBacking up and Undeploying the ingest-orphan.war ..\e[0m"
      #mkdir -v /opt/jboss/default/standalone/deployments.backup_Reindexing
      mv -v /opt/jboss/default/standalone/deployments/ingest-orphan.war* /opt/jboss/default/standalone/deployments.backup_Reindexing
      echo -e "\e[35m...done!\n"
    #Setting bio.prop ingest-twpdes.enabled=False
      echo -e "\e[35mSetting bio.prop ingest-orphan.enabled=false ..\e[0m"
      sed -i -e 's/^ingest-orphan.enabled=.*/ingest-orphan.enabled=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'ingest-orphan.enabled=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      echo -e "\e[35m...done!\e[0m\n"
    }
#---------------------
#---------------------
    #d) disable wl-merge) "Removing wlmergeBridge from standalone-full-lab.xml.."
    function REMOVE_WLMERGEBRIDGE () {
      echo -e "\e[35mRemoving wlmergeBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="wlmergeBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="wlmergeBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #Undeploy wl-merge.war"
    function UNDEPLOY_WL-MERGE-WAR () {
      echo -e "\e[35mBacking up and Undeploying the wl-merge.war ..\e[0m"
      #mkdir -v /opt/jboss/default/standalone/deployments.backup_Reindexing
      mv -v /opt/jboss/default/standalone/deployments/wl-merge.war* /opt/jboss/default/standalone/deployments.backup_Reindexing
      echo -e "\e[35m...done!\e[0m\n"
    #Setting bio.prop wl-merge.enabled=false
      echo -e "\e[35mSetting bio.prop wl-merge.enabled=false ..\e[0m"
      sed -i -e 's/^wl-merge.enabled=.*/wl-merge.enabled=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'wl-merge.enabled=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      echo -e "\e[35m...done!\e[0m\n"
    }
#---------------------
#---------------------
    #d) disable wl-hits) "Removing wlhitsBridge from standalone-full-lab.xml.."
    function REMOVE_WLHITSBRIDGE () {
      echo -e "\e[35mRemoving wlhitsBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="wlhitsBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="wlhitsBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #Undeploy wl-hits.war"
    function UNDEPLOY_WL-HITS-WAR () {
      echo -e "\e[35mBacking up and Undeploying the wl-hits.war ..\e[0m"
      #mkdir -v /opt/jboss/default/standalone/deployments.backup_Reindexing
      mv -v /opt/jboss/default/standalone/deployments/wl-hits.war* /opt/jboss/default/standalone/deployments.backup_Reindexing
      echo -e "\e[35m...done!\e[0m\n"
    #Setting bio.prop  wl-hits.enabled=false – SZ "ingest-wlhits.useBridgeQueue=false"
      echo -e "\e[35mSetting bio.prop wl-hits.enabled=false and ingest-wlhits.useBridgeQueue=false ..\e[0m"
      sed -i -e 's/^wl-hits.enabled=.*/wl-hits.enabled=false/g' -e 's/^ingest-wlhits.useBridgeQueue=.*/ingest-wlhits.useBridgeQueue=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'wl-hits.enabled=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'ingest-wlhits.useBridgeQueue=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      echo -e "\e[35m...done!\e[0m\n"
    }
#---------------------
#---------------------
    #d) disable wl-export) "Removing wl-export from standalone-full-lab.xml.."
    function REMOVE_WLEXPORTBRIDGE () {
      echo -e "\e[35mRemoving wlexportBridge from standalone-full-lab.xml..\e[0m"
      grep -A 3 '<jms-bridge name="wlexportBridge"' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
    #removing the xdomBrigde
      sed -i -e '/<jms-bridge name="wlexportBridge"/,+3d' /opt/jboss/default/standalone/configuration/standalone-full-lab.xml
      echo -e "\e[35m...done!\e[0m\n"
    }

    #Undeploy wl-export.war"
    function UNDEPLOY_WL-EXPORT-WAR () {
      echo -e "\e[35mBacking up and Undeploying the wl-export.war ..\e[0m"
      #mkdir -v /opt/jboss/default/standalone/deployments.backup_Reindexing
      mv -v /opt/jboss/default/standalone/deployments/wl-export.war* /opt/jboss/default/standalone/deployments.backup_Reindexing
      echo -e "\e[35m...done!\e[0m\n"
    #Setting bio.prop  wl-export.enabled=false – SZ "ingest-wlexport.createWatchml=false"
      echo -e "\e[35mSetting wl-export.enabled=false and ingest-wlexport.createWatchml=false ..\e[0m"
      sed -i -e 's/^wl-export.enabled=.*/wl-export.enabled=false/g' -e 's/^ingest-wlexport.createWatchml=.*/ingest-wlexport.createWatchml=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'wl-export.enabled=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      grep 'ingest-wlexport.createWatchml=' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
      echo -e "\e[35m...done!\e[0m\n"
    }
#---------------------
    #Set bio.prop for reindexing bi2r data
		function set_properties_reindex-bids () {
      echo -e "\e[35m\nSetting bio.prop general values for 'reindex-bids' bi2r data...\e[0m\n"
		  sed -i -e 's/^iafis.ingestNoMatch=.*/iafis.ingestNoMatch=true/g' -e 's/^wl-merge.bypass=.*/wl-merge.bypass=true/g' -e 's/^syphon.originalImporter=.*/syphon.originalImporter=I2AR/g' -e 's/^ingest.systemMode=.*/ingest.systemMode=Normal/g' -e 's/^ingest-twpdes.bypass=.*/ingest-twpdes.bypass=true/g' -e 's/^ingest.clamd.enabled=.*/ingest.clamd.enabled=false/g'  -e 's/^ingest.originalImporter=.*/ingest.originalImporter=I2AR/g' -e 's/^ingest-orphan.enabled=.*/ingest-orphan.enabled=false/g' -e 's/^ingest-orphan.runDailyCheck=.*/ingest-orphan.runDailyCheck=false/g' /opt/jboss/jboss-eap-7.0/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties
		}

    #g) clean out jboss/standalone/data/activemq
    function CLEAN_OUT_ACTIVEMQ () {
      echo -e "\e[35m\nCleaning out activmq directory...\e[0m\n"
      rm -vrf /opt/jboss/default/standalone/data/activemq/*
      rm -f /opt/jboss/default/standalone/deployments/{*.failed,*.deployed}
      echo -e "\e[35m...done!\e[0m\n"
    }

    #File in jboss deployments dir check
    function MOVE_WARS_4_REINDEXING-BIDS () {
      echo -e "\e[35m\nMoving unwanted wars to backup...\e[0m\n"
      mv -v /opt/jboss/default/standalone/deployments/{attachments-ws.war,event-smtp.war,idltService.war,ingest-autorun.war,ingest-purge.war,ingest-scanner.war,ingest-syphon.war,ingest-wl-hits.war,legacyUi.war,loginUi.war,productService.war,socom.war,solrSearchService.war,uamtService.war,userService.war,usptService.war,watchlistService.war,xdom-dashboard.war,xdom-receiver.war,xdom-bundler.war,xdom-monitor.war} /opt/jboss/default/standalone/deployments.backup_Reindexing/
      echo -e "\e[35m...done!\e[0m\n"
    }

    #File in jboss deployments dir check (moved out of this section so other flags can use it)
    #Check enabled bridges in the standalone-full-lab.xml (moved out of this section so other flags can use it)


##### Run Stuff within -reindex-bids flag #####
ADD_v108_1_PROPERTIES
#RESTORE_STANDALONE_FULL_LAB_ORIG (skipping this as we want to keep the v108.1 version)
#RESTORE_DEPLOYMENTS_BAK (skipping this as we want to keep the v108.1 wars)
REMOVE_XDOM-S_BRIDGE
DISABLING_REFCLIENT_IDML
REMOVE_TWPDES_BRIDGES
REMOVE_TWPDESMERGE_BRIDGES
UNDEPLOY_INGEST-TWPDES-WAR
REMOVE_ORPHANBRIDGE
UNDEPLOY_INGEST-ORPHAN-WAR
REMOVE_WLMERGEBRIDGE
UNDEPLOY_WL-MERGE-WAR
REMOVE_WLHITSBRIDGE
UNDEPLOY_WL-HITS-WAR
REMOVE_WLEXPORTBRIDGE
UNDEPLOY_WL-EXPORT-WAR
set_properties_reindex-bids
CLEAN_OUT_ACTIVEMQ
MOVE_WARS_4_REINDEXING-BIDS
sleep 1

#Check bio.prop configs
		CHECK_BIO_PROP
    echo -e "\n"
    echo -e "\e[35m\n*** NOTE: You will need to modifiy the standalone-full-lab.xml prior to kicking off the Reindexing of Bids.. ie. create jmsUser, disable security and ApplicationRelam settings. ***\e[0m\n"
		sleep 1
		exit 0;

fi


#################################################################################################################
#################################################################################################################
#################################################################################################################
#################################################################################################################
#################################################################################################################
