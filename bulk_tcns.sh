#!/bin/bash

#Check param"
if [ -z "$1" ]
then
    echo -e "\nMissing parameter...exiting.\n"
    echo "How to use this script:"
    echo "./bulk_tcns.sh seed.xml 500"
    echo -e "\n"
    exit 1;

else

    SEED_FILE=$1
fi

##Check to see if $2 parameter was specified. required.. ie "SP85"
if [ -z "$2" ]
then
  echo -e "\nMissing parameter...exiting.\n"
  echo "How to use this script:"
  echo "./bulk_tcns.sh seed.xml 500"
  echo -e "\n"
  exit 1;

else

    MULTIPLIER=$2
fi


# nuts and bolts

function GEN_FILES () {
      SEED_FILE=$1
      MULTIPLIER=$2

      for (( c=1; c<=6; c++ ))
      do
      cp test_1file.xml test_1file${c}.xml
      sed -i "s/aaaaaaaaa/aaaaaaaaa$c/g" "test_1file${c}.xml"
      done
    }

#run STUFF
GEN_FILES $SEED_FILE $MULTIPLIER
