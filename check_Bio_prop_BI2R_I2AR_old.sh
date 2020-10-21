#!/bin/bash
#
# Utility script that will check, or set bio.props for BI2R or I2AR


<<COMMENT
During ingest and reindexing:
	• ingest.systemMode=BulkIngest
	• Twpdes bypass=true
	• Wl-merge.bypass=true
	• Syphon.originalImporter=BI2R
	• iafis.ingestNoMatch=true

After ingest/indexing is completed:
	• ingest.systemMode=Normal
	• Twpdes bypass=false
	• Wl-merge.bypass=false
	• Syphon.originalImporter=I2AR
iafis.ingestNoMatch=??


# values that are checked/changed

ingest.systemMode=
ingest-twpdes.bypass=
wl-merge.bypass=
syphon.originalImporter=
iafis.ingestNoMatch=

COMMENT


#Check to see if $1 parameter was specified the 7th column was specified as the awk pattern to use in the script"

if [ -z "$1" ]
then
    echo -e "Missing parm .. use: check | bi2r | i2ar"
		sleep 1
		exit 1;
else
		echo -e "Missing parm .. use: check | bi2r | i2ar"
fi


if [ $1 = "check" ]
then
		echo -e "\nCheckikng bio.prop properties...\n"
    check_BIO_Prop
		sleep 1
		exit 0;
else
    echo "Invalid parm .. use: check | bi2r | i2ar"
		exit 1;
fi


if [ $1 = "bi2r" ]
then
    echo 'Setting bio.prop values for bi2r'
		set_properties_BI2R
		sleep 1
		exit 0;
else
    echo 'Invalid parm .. use: check | bi2r | i2ar'
		exit 1;
fi


if [ $1 = "i2ar" ]
then
    echo 'Setting bio.prop values for i2ar'
		set_properties_I2AR
		sleep 1
		exit 0;
else
    echo 'Invalid parm .. use: check | bi2r | i2ar'
		exit 1;
fi

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
echo '*** Current Bio.prop settings ***'
grep ${ARRAY_1[0]}
grep ${ARRAY_1[1]}
grep ${ARRAY_1[2]}
grep ${ARRAY_1[3]}
grep ${ARRAY_1[4]}
sleep 1
echo 'To set bio.prop values for BI2R or I2AR... run the script agian and specify BI2R or I2AR'
}

#Set bio.prop to BI2R

function set_properties_BI2R () {
sed "/^ingest.systemMode=/c\ingest.systemMode=BulkIngest" biometrics.properties.test
sed "/^ingest-twpdes.bypass=/c\ingest-twpdes.bypass=true" biometrics.properties.test
sed "/^wl-merge.bypass=/c\wl-merge.bypass=true" biometrics.properties.test
sed "/^syphon.originalImporter=/c\syphon.originalImporter=BI2R" biometrics.properties.test
sed "/^iafis.ingestNoMatch=/c\iafis.ingestNoMatch=true" biometrics.properties.test
}


#Set bio.prop to I2AR

function set_properties_I2AR () {
sed "/^ingest.systemMode=/c\ingest.systemMode=Normal" biometrics.properties.test
sed "/^ingest-twpdes.bypass=/c\ingest-twpdes.bypass=false" biometrics.properties.test
sed "/^wl-merge.bypass=/c\wl-merge.bypass=false" biometrics.properties.test
sed "/^syphon.originalImporter=/c\syphon.originalImporter=I2AR" biometrics.properties.test
sed "/^iafis.ingestNoMatch=/c\iafis.ingestNoMatch=false" biometrics.properties.test
}


#run STUFF
check_BIO_Prop
set_properties_BI2R
set_properties_I2AR
echo "Done.."
