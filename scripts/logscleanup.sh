#!/bin/bash

# Created by: Chee Wei
# Purpose: Cleans up log files in specified directory
# How to use: Add the variables for directory of the log files (LOGDIRECTORY) and a list of log file prefixes (LOGFILEPREFIXES) that needs to be cleaned up
# Check the LOGFILE to get a history of the log files that has been deleted or cleaned up

# Required Variables
LOGDIRECTORY="/var/log"                                             # Directory of log files to clean up
LOGFILEPREFIXES="backend application monitoring"                    # A list of log file prefixes to clean up
# LOGFILEPREFIXES="yum boot choose tally last secure messages"      # A list of log file prefixes to clean up (Testing)
MODIFIEDTIME=3                                                      # Last modified time in days for log file
LOGFILE="logscleanup.log"                                           # Log file for this script

# Start of main script
echo -e "=========================================================" | tee -a $LOGFILE
echo "This script was executed on `date`" | tee -a $LOGFILE
echo "==> Output a list of log file prefixes to be cleaned up: '$LOGFILEPREFIXES'" | tee -a $LOGFILE

for LFP in `echo $LOGFILEPREFIXES`
do
        #LOGFILES=`find ${LOGDIRECTORY}  -name "${LFP}*" -mtime +${MODIFIEDTIME} -exec rm -f {} \;`
        LOGFILESTOCLEANUP=`find ${LOGDIRECTORY}  -name "${LFP}*" -mtime +${MODIFIEDTIME} -exec ls {} \;`
        #echo "$LOGFILESTOCLEANUP"

        if [ -z "${LOGFILESTOCLEANUP}" ]
        then
                echo "Cannot find log file prefix '${LFP}*' that has been modified more than ${MODIFIEDTIME} days ago" | tee -a $LOGFILE
        else
                echo "Found Log Files '$LOGFILESTOCLEANUP' that has been modified more than ${MODIFIEDTIME} days ago" | tee -a $LOGFILE
                echo "Proceeding to delete log files $LOGFILESTOCLEANUP" | tee -a $LOGFILE
                # Add the actual delete commands here
                #for LF in $LOGFILESTOCLEANUP
                #do
                #       rm $LF
                #done
                #OR run the following
                #find ${LOGDIRECTORY}  -name "${LFP}*" -mtime +${MODIFIEDTIME} -exec rm -f {} \;`
        fi
done
# End of main script