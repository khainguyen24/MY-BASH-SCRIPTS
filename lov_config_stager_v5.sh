#!/bin/bash
#just adding some comments into this file from ATOM
# LOV Configuration Stager finding and copying these files to use with configuration-importer.groovy and the borg-cli tool
# Change Log:
# 04/15/2020 - updated script to show the directory that was passed in, fixed header, fixed the 's' in attribute_lists'  in line 151 - find $BI2R_EXPORT_DIR -type d -name attribute_lists -exec cp -rp {} ${LOV_ATTR_DIR} \;'
# I recall having issues with the configuration-importer looking for 'attribute_list' and not 'attribute_lists' i had to remove the 's' in order for the configuration-importer to find it and process the attribute_lists in the statge directory
# 04/27/2021 - updated to rename attribute_lists to attribute_list
# 05/12/2021 line #143 commenting this out so turns out that the groupType.xml rename only needed if the file is placed in jboss main directory. if it's going to be imported with the configuration-importer then event_types.xml is filename
# 1 ###############################################
#Check to see if $1 parameter was specified"
if [ -z "$1" ]
then
    echo -e "\nMissing parameter...exiting.\n"
    echo "How to use this script:"
    echo "./lov_config_stager.sh <Full_Path to BI2R_Export_directory>"
    echo -e "\nExample:"
    echo "./lov_config_stager.sh /var/temp/2019-12-04"
    echo -e "\n"
    exit 1;

else

    BI2R_EXPORT_DIR=$1
    #BASE_DIR=/var/temp #change this to where you want the backup directory to be
fi

# 2 ###############################################

# Setting the global variables and creating dir for the script.
echo -e "\n\e[35m********************************************************************"
echo -e "              ***  BI2R LOVs & CONFIGs STAGER TOOL ***              "
echo -e "********************************************************************\e[0m"
sleep 1
echo -en "\e[35mCreating LOV_CONFIG_STAGE directories.."
sleep 1
Create_LOV_CONFIG_STAGED_dir="$(mkdir --parent /var/temp/LOV_CONFIG_STAGE/{LOVs/{bewl,success,error},CONFIGs})"
# Defining paths
LOV_BEWL_DIR=/var/temp/LOV_CONFIG_STAGE/LOVs/bewl/
LOV_ATTR_DIR=/var/temp/LOV_CONFIG_STAGE/LOVs
LOV_ATTR_LIST_DIR=/var/temp/LOV_CONFIG_STAGE/LOVs
LOV_CONFIG_DIR=/var/temp/LOV_CONFIG_STAGE/CONFIGs/
echo -e "..done!\n"
# 3 #######################################################

# Function to create the LOVs and CONFIGs ARRAYS

function CREATE_ARRAYS () {
# LOV bewl (removing Configs adding groupType.xml and analysts.xml to the bewl stage directory)
ARRAY_LOV_BEWL_FILES=(
abisDerivedDataSource.xml
alertCategoryMvJust.xml
alertCategory.xml
alertRegion.xml
analysts.xml
changeRequestStatus.xml
classifications.xml
confidence.xml
deleteNominationJustification.xml
lov_watchlist_export_fields.xml
lov_watchlist_search_fields.xml
event_types.xml
messagesSipr.xml
messagesJwics.xml
nationality.xml
nominationStatus.xml
nominatorGroup.xml
productType.xml
relationship.xml
subcategory.xml
)


# CONFIGs
ARRAY_CONFIG_FILES=(
oriIgnoreFile.txt
namesIgnoreList.txt
masking-rules.xml
agencyOriMap.xml
data-source-normalization.xml
CategoryDirectives.xml
usp_rules_export.xml
)

# LOV attr
#ARRAY_LOV_ATTR_FILES=(
#)


# LOV attr_List
#ARRAY_LOV_ATTR_LIST_FILES=(
#)
}

#function to copy over the LOV and Config Files
function STAGE_LOV_CONFIG () {

  # 4 ######################################################
  # could wrap this in a loop but will keep it as is (for readablity) for now just in case i need to change what files map to what.
  #find event_types.xml amd analysts.xml and move to the /var/temp/LOV_CONFIG_STAGE/LOVs/bewl

      sleep 1
      echo -n "Copying the LOV bewl files to the /var/temp/LOV_CONFIG_STAGE/LOVs/bewl directory.."
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[0]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[1]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[2]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[3]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[4]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[5]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[6]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[7]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[8]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[9]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[10]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[11]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[12]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[13]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[14]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[15]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[16]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[17]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[18]} -exec cp {} ${LOV_BEWL_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_LOV_BEWL_FILES[19]} -exec cp {} ${LOV_BEWL_DIR} \;
      sleep 1
      echo -e "..done!\n"
      # 5 ######################################################

      sleep 1
      echo -n "Copying/renaming the BI2R config files to the /var/temp/LOV_CONFIG_STAGE/CONFIGs directory.."
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_CONFIG_FILES[0]} -exec cp {} ${LOV_CONFIG_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_CONFIG_FILES[1]} -exec cp {} ${LOV_CONFIG_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_CONFIG_FILES[2]} -exec cp {} ${LOV_CONFIG_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_CONFIG_FILES[3]} -exec cp {} ${LOV_CONFIG_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_CONFIG_FILES[4]} -exec cp {} ${LOV_CONFIG_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_CONFIG_FILES[5]} -exec cp {} ${LOV_CONFIG_DIR} \;
      find $BI2R_EXPORT_DIR -type f -name ${ARRAY_CONFIG_FILES[6]} -exec cp {} ${LOV_CONFIG_DIR} \;

      #6 ######################################################
      # find and rename namesIgnoreList.txt > namesIgnoreFile.txt | usp_rules_export.xml > usp-rules.xml
      find ${LOV_CONFIG_DIR} -type f -name ${ARRAY_CONFIG_FILES[1]} -exec mv {} ${LOV_CONFIG_DIR}namesIgnoreFile.txt \;
      find ${LOV_CONFIG_DIR} -type f -name ${ARRAY_CONFIG_FILES[6]} -exec mv {} ${LOV_CONFIG_DIR}usp-rules.xml \;
      find ${LOV_BEWL_DIR} -type f -name ${ARRAY_LOV_BEWL_FILES[1]} -exec mv {} ${LOV_BEWL_DIR}alertCategoryMovementJustification.xml \;
      # commenting this out so turns out that the groupType.xml rename only needed if the file is placed in jboss main directory. if it's going to be imported with the configuration-importer then event_types.xml is filename
      # find ${LOV_BEWL_DIR} -type f -name ${ARRAY_LOV_BEWL_FILES[11]} -exec mv {} ${LOV_BEWL_DIR}groupType.xml \;
      sleep 1
      echo -e "..done!\n"
}


#function to copy over the LOV attribute and attribute_list
function STAGE_LOV_ATTR () {
echo -n "Copying LOV attribute and LOV attribute_lists..."
  find $BI2R_EXPORT_DIR -type d -name attribute -exec cp -rp {} ${LOV_ATTR_DIR} \;
  find $BI2R_EXPORT_DIR -type d -name attribute_lists -exec cp -rp {} ${LOV_ATTR_LIST_DIR} \;
  sleep 1
  echo -e "...done!\n"
  sleep 1
  #need to rename the attribute_lists from the BIR export to attribute_list .. the configuration-importer.groovy script looks for attribute_lists
  echo -n "Renaming attribute_lists to attribute_list.."
  sleep 1
  mv ${LOV_ATTR_LIST_DIR}/attribute_lists ${LOV_ATTR_LIST_DIR}/attribute_list
  echo -e "...done!\n"
  sleep 1
}

#change ownwership and permissions of /var/temp/LOV_CONFIG_STAGE
function CHOWN_CHMOD () {
  echo -n "Changing ownership and permission on LOV_CONFIG_STAGE directory ..."
  chown -R webadmin:webadmin /var/temp/LOV_CONFIG_STAGE/
  chmod -R 775 /var/temp/LOV_CONFIG_STAGE/
  sleep 1
  echo -e "...done!\n"
}

# DO STUFF
CREATE_ARRAYS
sleep 1
STAGE_LOV_CONFIG
sleep 1
STAGE_LOV_ATTR
sleep 1
CHOWN_CHMOD
sleep 1
echo -en "All LOVs and CONFIGs from: $BI2R_EXPORT_DIR have been copied to:\e[0m \e[32m/var/temp/LOV_CONFIG_STAGE/\e[0m\n"
echo -e "\n"
exit 0;
