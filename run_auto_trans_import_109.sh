[root@ip-172-36-24-6 automated_Import_Scripts]# cat run_auto_trans_imports.sh
#! /bin/bash
#
# Script to automate data ingestion for transactional.
#
#* Check for a new archive on s3
#** If found, copy it from s3 to local
#*** Remove old archive location
#*** Potentially archive and cleanout old stats/log/etc
#*** Explode the archive to final destination
#*** start ingest (main.pl) - nohup perl main.pl <exported tar directory> &

# Example run: cd /var/webadmin/automated_Import_Scripts && ./run_auto_trans_imports.sh "true" "false"
# First param is for puppet being run before doing the trans ingest (true/false) - defaults to false
# Second param is for major counts being run (true/false) - defaults to true

#
# Support functions
#

monitorIngest() {
    # See if the main ingestion script is running
    while [ "$(isIngestRunning)" = "true" ]
    do
        sleep 60
        echo "`date +%F_%T`...monitoring automated ingest." | tee -a $results
    done
    echo "`date +%F_%T`...Ingest finished" | tee -a $results
}

isIngestRunning() {
    # See if the main ingestion script is running
    processCheck=$(ps -aef | grep perl | grep $INGEST_SCRIPT)
    if [ -n "$processCheck" ]; then
        echo "true"
    else
        echo "false"
    fi
}

pause() {
   read -p "$1" key
}

#
# Handles tasks once ingest is finished
#
postIngest() {
    # Update lastProcessed for cleanup on the next run
    echo $export_location > $LAST_PROCESSED

    # Archive the AWS tar by undoing the ".working"
    aws s3 mv s3://$S3_ARCHIVE_BUCKET/$export_to_process".working" s3://$S3_ARCHIVE_BUCKET/$export_to_process

    # Clean up/remove the local copy of the imported source archive
    rm $ARCHIVE_DEST/$export_to_process

    # From ITWOAR-10994 research:
    # If we choose to go the route of using the export's BIDs list,
    # it should be a matter of copying the file located in:
    # $export_location/export_lists/BIDS.TXT to s3 instead of the
    # current $bidsFile (set below)...which will get picked by
    # cron_auto_reindex.sh on the verification UI server.
    # So the line would look like:
    # aws s3 cp $export_location/export_lists/BIDS.TXT s3://$S3_SOURCE_BUCKET/$bidsFile
    # Would also want to add some error checking to make sure BIDS.TXT exists before copying.
    # Also, if we choose a different name, it should include the date...and cron_auto_reindex.sh
    # will need an update to account for the name change.

    # Index the bids
    # stage the bid list to s3 for indexing
    bidsFile=$runDate-bids_primary-post.txt
    # See if the bid list file has content
    if [ -s $bidsFile ]; then
        aws s3 cp $bidsFile s3://$S3_SOURCE_BUCKET/$bidsFile
    else
        echo "BIDs list file $bidsFile is empty, not copying to S3." | tee -a $results
    fi
}


#
# End Support functions
#

# update the path var so aws commands are included
# This could be done in crontab (I think) or as part
# of a slightly less obvious cron command setup.  The
# issue is that cron jobs are run as a user (in this case root)
# but don't get a 'full' environment setup because they aren't
# a user that has gone through a shell login.
#
# From examples I've seen in forum discussions, it's possible
# to do something like "su -l -c <command>" in the cron setup,
# but I had no success when trying in a test case.
#
# Explicitly setting this path in the script makes it
# obvious what is being done, and only scripts like this
# one need to worry about setting it which feels like
# a better approach, imo.

if [ ! -z "$1" ]
then
    update_server=$1
fi

if [ ! -z "$2" ]
then
    run_major_counts=$2
else
    run_major_counts="true"
fi

PATH=$PATH:/usr/local/bin

date=`date +%F`
results="$date.automated-export.results"
echo "Automated Import started: `date +%F_%T`" | tee $results

S3_SOURCE_BUCKET=trans-data-sync-working
S3_ARCHIVE_BUCKET=trans-data-sync-archive
ARCHIVE_DEST=/var/webadmin/temp
BASE_DIR=/var/webadmin/automated_Import_Scripts
LAST_PROCESSED=$BASE_DIR/autoImport.lastProcessed
INGEST_SCRIPT=main.pl
SPROCKET_DIR=/opt/i2ar/sprocket

# See if a new archive exists
archive_list=$(aws s3 ls s3://$S3_SOURCE_BUCKET/ | grep "\.tar\.gz" | awk '{print $4}')
if [ -z "$archive_list" ]; then
    echo "Nothing new to process...exiting." | tee -a $results
    exit 1
fi

# double-check that an import isn't currently ongoing
if [ "$(isIngestRunning)" = "false" ]; then
    if [ "$update_server" = "true" ]; then
        echo "Running puppet to update the server" | tee -a $results
        puppet agent --enable
        puppet agent -t
        puppet agent --disable
    fi
    # No import processes running, shutdown jboss, this is so pushCatcher can complete before we start ingesting
    systemctl stop jboss
else
    echo "An import process is already running...exiting."
    exit 1;
fi

# If there is more than 1 export file, only process the oldest archive first
#
# So, we'll snag the first one to process for this transactional run
export_to_process=`echo $archive_list | cut -d' ' -f 1`

#echo $archive_list
echo "Export file: $export_to_process - copying to: $ARCHIVE_DEST"

# copy the archive
aws s3 cp s3://$S3_SOURCE_BUCKET/$export_to_process $ARCHIVE_DEST/

# Grab the top-level directory contained in the archive, trim trailing '/'
export_location=$(tar -tvzf $ARCHIVE_DEST/$export_to_process | head -n1 | rev | cut -d' ' -f 1 | rev | sed 's:/*$::')

echo "export_location: $export_location"

# Find the last directory processed, if there was one and remove it
if [ -e $LAST_PROCESSED ]; then
    lastProcessedLocation=`cat $LAST_PROCESSED`
    echo "Cleaning up last automated import remnants at: $lastProcessedLocation"  | tee -a $results
    if [ -d $lastProcessedLocation ]; then
        rm -rf $lastProcessedLocation
        status=$?
    fi
fi

#explode the archive to import location
echo "Exploding $export_to_process to: $BASE_DIR" | tee -a $results
tar -xvzf $ARCHIVE_DEST/$export_to_process -C $BASE_DIR | tee -a $results
status=$?
#echo "tar status: $status"

if [ "$status" != "0" ]; then
    echo "Error exploding archive [$status]...exiting." | tee -a $results
    exit 1;
fi

# archive as ".working" so that if the cron happens to run again due to processing happen from one day to the next, it won't pick it up again
aws s3 mv s3://$S3_SOURCE_BUCKET/$export_to_process s3://$S3_ARCHIVE_BUCKET/$export_to_process".working"

if [ ! -e "$BASE_DIR/major-counts-email-body.txt" ]; then
    echo "Major Counts results for transactional ingested on host: `hostname`" > $BASE_DIR/major-counts-email-body.txt
fi

echo "Starting main perl script"
runDate=`date +%F`
# Start the main ingest script
nohupFile="$runDate.automated.nohup.out"

if [ "$run_major_counts" = "true" ]; then
     echo "Running main.pl with -skipClearDirs" | tee -a $results
     nohup perl main.pl $BASE_DIR/$export_location -skipClearDirs > $nohupFile&
else
     echo "Running main.pl with -skipClearDirs and -skipMajorCountsCheck" | tee -a $results
     nohup perl main.pl $BASE_DIR/$export_location -skipClearDirs -skipMajorCountsCheck > $nohupFile&
fi
sleep 60
monitorIngest
postIngest

[root@ip-172-36-24-6 automated_Import_Scripts]#
