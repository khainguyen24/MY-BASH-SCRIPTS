#!/bin/bash
#
# Utility script that will check, and set if necessary, the current
# ingest mode of the server.
#
# Ingest mode (SystemMode) passed in: BulkIngest, Normal, NoIngest, None
# File checked: biometrics.properties
# Variables checked/set:
#   ingest-twpdes.bypass - desired value is true
#   ingest.systemMode - desired value is BulkIngest for bulk ingest mode
#

DEFAULT_BIO_FILE=/opt/jboss/default/modules/mil/army/inscom/biometrics/resources/main/biometrics.properties

if [ -z "$1" ]; then
    INGEST_MODE=BulkIngest
else
    INGEST_MODE=$1
fi

if [ -z "$2" ]; then
    BIO_FILE=$DEFAULT_BIO_FILE
else
    BIO_FILE=$2
fi

INGEST_PROPERTY=ingest.systemMode

TWPDES_BYPASS_PROPERTY=ingest-twpdes.bypass
TWPDES_BYPASS_MODE="true"

IAFIS_NO_MATCH_PROPERTY=iafis.ingestNoMatch
IAFIS_NO_MATCH_BYPASS_MODE="true"

#
# Support functions
#

function hasProperty {
    grep "${1}" $BIO_FILE | while read -r line ; do
        if [[ $line == \#* ]]; then
            # skip the commented-out line
            # noop
            :
        else
            echo "1"
        fi
    done

    echo "" # doesn't have the property
}

function getPropValue {
    # this is good if only a single value would be found,
    # but multiple, commendted-out lines should probably be accounted for
    #    grep "${1}" $BIO_FILE|cut -d'=' -f2

    modes=`grep "${1}" $BIO_FILE`
    if [ -z "$modes" ]; then
        echo ""
    else
        for mode in $modes; do
            if [[ $mode == \#* ]]; then
                # skip the commented-out line
                # noop
                :
            else # not commented out, get the value
                echo $mode | cut -d'=' -f2
            fi
        done
    fi
}

function replacePropValue {
    PROPERTY_NAME=$1
    NEW_VALUE=$2
    PROPERTY_FILE=$3
    echo "Setting $PROPERTY_NAME value to $NEW_VALUE in file: $PROPERTY_FILE"
    sed -i "s/\(^$PROPERTY_NAME=\).*/$PROPERTY_NAME=$NEW_VALUE/" $PROPERTY_FILE
}

function setPropValue {
    PROPERTY_NAME=$1
    NEW_VALUE=$2
    PROPERTY_FILE=$3
    echo "Setting or adding $PROPERTY_NAME value to $NEW_VALUE in file: $PROPERTY_FILE"
    # Replace the property value if found, otherwise add it as a new name=value pair
    sed -i "/\(^$PROPERTY_NAME\)/{h;s/=.*/=$NEW_VALUE/};\${x;/^$/{s//$PROPERTY_NAME=$NEW_VALUE/;H};x}" $PROPERTY_FILE
}

#
# End Support functions
#

if [ ! -f $BIO_FILE ]; then
    echo "Properties file not found! $BIO_FILE"
    echo "...exiting"
    exit 1;
fi

#value=$(getPropValue "$INGEST_PROPERTY")
#echo "Ingest mode value: [$value]"

# Ingest mode
setPropValue $INGEST_PROPERTY $INGEST_MODE $BIO_FILE

# Twpdes bypass mode
setPropValue $TWPDES_BYPASS_PROPERTY $TWPDES_BYPASS_MODE $BIO_FILE

# Iafis no-match
setPropValue $IAFIS_NO_MATCH_PROPERTY $IAFIS_NO_MATCH_BYPASS_MODE $BIO_FILE

#if [ -z "$value" ]; then
#    # Not set, add the property
#    echo "Setting system mode - $INGEST_MODE"
#    echo "" >> $BIO_FILE # newline
#    echo "$INGEST_PROPERTY=$INGEST_MODE" >> $BIO_FILE
#else
#    # Already set - need to see if it matches what we want.
#    if [ "$INGEST_MODE" != "$value" ]; then
#        # Replace the value
#        replacePropValue $INGEST_PROPERTY $INGEST_MODE $BIO_FILE
#    fi
#fi

#value=$(getPropValue "$TWPDES_BYPASS_PROPERTY")
#value=$(hasProperty "$TWPDES_BYPASS_PROPERTY")
#echo "Twpdes bypass value: [$value]"
#if [ -z "$value" ]; then
#    # Not set, add the property
#    echo "Setting twpdes bypass mode - $TWPDES_BYPASS_MODE"
#    echo "" >> $BIO_FILE # newline
#    echo "$TWPDES_BYPASS_PROPERTY=$TWPDES_BYPASS_MODE" >> $BIO_FILE
#else
#    # Already set - need to see if it matches what we want.
#    if [ "$TWPDES_BYPASS_MODE" != "$value" ]; then
#        # Replace the value
#        replacePropValue $TWPDES_BYPASS_PROPERTY $TWPDES_BYPASS_MODE $BIO_FILE
#    fi
#fi
