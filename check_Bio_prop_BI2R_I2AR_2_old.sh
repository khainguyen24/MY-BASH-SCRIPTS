#!/bin/bash
#
# Utility script that will check, or set bio.props for BI2R or I2AR


if [ -z "$1" ]
then
    echo -e "Missing parm .. use: check | bi2r | i2ar"
		sleep 1
		exit 1;
fi


if [ $1 = "check" ]
then
		echo -e "\nCheckikng bio.prop properties...\n"

#create arrays of properties to check
ARRAY_1=(
ingest.systemMode=
ingest-twpdes.bypass=
wl-merge.bypass=
syphon.originalImporter=
iafis.ingestNoMatch=
)
#Check bio.prop configs
		function check_BIO_Prop () {
		echo "*** Current Bio.prop settings ***"
		grep ${ARRAY_1[0]} biometrics.properties.test
		grep ${ARRAY_1[1]} biometrics.properties.test
		grep ${ARRAY_1[2]} biometrics.properties.test
		grep ${ARRAY_1[3]} biometrics.properties.test
		grep ${ARRAY_1[4]} biometrics.properties.test
		sleep 1
		echo 'To set bio.prop values for BI2R or I2AR... run the script agian and specify BI2R or I2AR'
		}
		check_BIO_Prop
		sleep 1
		exit 0;

fi


if [ $1 = "bi2r" ]
then
    echo -e "\nSetting bio.prop values for bi2r...\n"
#Set bio.prop to BI2R
		function set_properties_BI2R () {
		sed -i -e 's/^ingest.systemMode=.*/ingest.systemMode=BulkIngest/g' -e 's/^ingest-twpdes.bypass=.*/ingest-twpdes.bypass=true/g' -e 's/^wl-merge.bypass=.*/wl-merge.bypass=true/g' -e 's/^iafis.ingestNoMatch=.*/iafis.ingestNoMatch=true/g' -e 's/^syphon.originalImporter=.*/syphon.originalImporter=BI2R/g' biometrics.properties.test
		}
		set_properties_BI2R
		sleep 1
#create arrays of properties to check
		ARRAY_1=(
		ingest.systemMode=
		ingest-twpdes.bypass=
		wl-merge.bypass=
		syphon.originalImporter=
		iafis.ingestNoMatch=
		)
#Check bio.prop configs
		function check_BIO_Prop () {
		echo "*** Bio.prop set to BI2R ingest ***"
		grep ${ARRAY_1[0]} biometrics.properties.test
		grep ${ARRAY_1[1]} biometrics.properties.test
		grep ${ARRAY_1[2]} biometrics.properties.test
		grep ${ARRAY_1[3]} biometrics.properties.test
		grep ${ARRAY_1[4]} biometrics.properties.test
		sleep 1
		echo 'To set bio.prop values for BI2R or I2AR... run the script agian and specify BI2R or I2AR'
		}
		check_BIO_Prop
		sleep 1
		exit 0;

fi


if [ $1 = "i2ar" ]
then
    echo -e "\nSetting bio.prop values for i2ar...\n"
#Set bio.prop to I2AR
		function set_properties_I2AR () {
		sed -i -e 's/^ingest.systemMode=.*/ingest.systemMode=Normal/g' -e 's/^ingest-twpdes.bypass=.*/ingest-twpdes.bypass=false/g' -e 's/^wl-merge.bypass=.*/wl-merge.bypass=false/g' -e 's/^iafis.ingestNoMatch=.*/iafis.ingestNoMatch=false/g' -e 's/^syphon.originalImporter=.*/syphon.originalImporter=I2AR/g' biometrics.properties.test
		}
		set_properties_I2AR
		sleep 1
#create arrays of properties to check
		ARRAY_1=(
		ingest.systemMode=
		ingest-twpdes.bypass=
		wl-merge.bypass=
		syphon.originalImporter=
		iafis.ingestNoMatch=
		)
#Check bio.prop configs
		function check_BIO_Prop () {
		echo "*** Bio.prop set for I2AR ingest ***"
		grep ${ARRAY_1[0]} biometrics.properties.test
		grep ${ARRAY_1[1]} biometrics.properties.test
		grep ${ARRAY_1[2]} biometrics.properties.test
		grep ${ARRAY_1[3]} biometrics.properties.test
		grep ${ARRAY_1[4]} biometrics.properties.test
		sleep 1
		echo 'To set bio.prop values for BI2R or I2AR... run the script agian and specify bi2r or i2ar'
		}
		check_BIO_Prop
		sleep 1
		exit 0;
fi
