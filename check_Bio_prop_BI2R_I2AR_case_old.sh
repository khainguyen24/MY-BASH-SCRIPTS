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



read -p "Enter your choice [check/bi2r/i2ar]:" choice

case $choice in
     check/Check/CHECK)
          echo "Checkikng bio.prop properties..."

					ARRAY_1=(
					ingest.systemMode=
					ingest-twpdes.bypass=
					wl-merge.bypass=
					syphon.originalImporter=
					iafis.ingestNoMatch=
					)

					echo "*** Current Bio.prop settings ***"
					grep ${ARRAY_1[0]} biometrics.properties.test
					grep ${ARRAY_1[1]} biometrics.properties.test
					grep ${ARRAY_1[2]} biometrics.properties.test
					grep ${ARRAY_1[3]} biometrics.properties.test
					grep ${ARRAY_1[4]} biometrics.properties.test
					sleep 1
					echo "To set bio.prop values for BI2R or I2AR... run the script agian and specify BI2R or I2AR"
          ;;


     bi2r/BI2R/Bi2r)
          echo "Setting bio.prop values for bi2r"
					sed "/^ingest.systemMode=/c\ingest.systemMode=BulkIngest" biometrics.properties.test
					sed "/^ingest-twpdes.bypass=/c\ingest-twpdes.bypass=true" biometrics.properties.test
					sed "/^wl-merge.bypass=/c\wl-merge.bypass=true" biometrics.properties.test
					sed "/^syphon.originalImporter=/c\syphon.originalImporter=BI2R" biometrics.properties.test
					sed "/^iafis.ingestNoMatch=/c\iafis.ingestNoMatch=true" biometrics.properties.test
          ;;


		 i2ar/I2AR/i2ar)
		      echo "Setting bio.prop values for i2ar"
					sed "/^ingest.systemMode=/c\ingest.systemMode=Normal" biometrics.properties.test
					sed "/^ingest-twpdes.bypass=/c\ingest-twpdes.bypass=false" biometrics.properties.test
					sed "/^wl-merge.bypass=/c\wl-merge.bypass=false" biometrics.properties.test
					sed "/^syphon.originalImporter=/c\syphon.originalImporter=I2AR" biometrics.properties.test
					sed "/^iafis.ingestNoMatch=/c\iafis.ingestNoMatch=false" biometrics.properties.test
		      ;;
     *)
          echo "Invalid parm .. use: check | bi2r | i2ar"
          ;;
esac
#Check to see if $1 parameter was specified the 7th column was specified as the awk pattern to use in the script"
