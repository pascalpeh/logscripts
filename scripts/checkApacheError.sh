#!/bin/bash

# Created by: Chee Wei
# Purpose: This bash script checks the Apache log file for 4xx/5xx errors and sends an email if the errors exceeds 100
# How to use: Add the actual location of Apache log file (usually default is /var/log/httpd/access_log or ssl_access_log) under "APACHELOGFILE" variable and run the script or schedule as a cronjob daily

# Required variables
APACHELOGFILE="/var/log/httpd/ssl_access_log"      # Specify the file location of Apache log file
MAXERRORCOUNT=100                                  # Specify the maximum number of HTTP error count before sending email notifications

# Start of main script
if [ -f $APACHELOGFILE ]
then
        echo "Found Apache log file"
        # Get a list of all HTTP 4xx errors
        ALL_4xx_ERROR=`cat ${APACHELOGFILE} | awk '{print $9}' |sort -d |grep ^4`
        ALL_4xx_ERROR_COUNT=`echo "${ALL_4xx_ERROR}"|wc -l`
        echo "Total HTTP 4xx error count: ${ALL_4xx_ERROR_COUNT}"

        # Get a list of all HTTP 5xx errors
        ALL_5xx_ERROR=`cat ${APACHELOGFILE} | awk '{print $9}' |sort -d |grep ^5`
        ALL_5xx_ERROR_COUNT=`echo "${ALL_5xx_ERROR}"|wc -l`
        echo "Total HTTP 5xx error count: ${ALL_5xx_ERROR_COUNT}"

        # Sends email if HTTP 4xx error is greater than MAXERRORCOUNT
        if [ ${ALL_4xx_ERROR_COUNT} -gt ${MAXERRORCOUNT} ]
        then
                echo "Found a total of ${ALL_4xx_ERROR_COUNT} HTTP 4xx status code from Apache log. Please check"
                ERROR_TYPE_4xx=`echo "${ALL_4xx_ERROR}"|uniq`
                #echo "Type of 4xx errors: ${ERROR_TYPE_4xx}"
                for ERROR in `echo ${ERROR_TYPE_4xx}`
                do
                        HTTP_4xx_BREAKDOWN="${HTTP_4xx_BREAKDOWN} \nTotal Count for HTTP Error $ERROR => `echo "${ALL_4xx_ERROR}"|grep $ERROR|wc -l`"
                done

                echo -e "## Summary of HTTP 4xx Errors ## \n ${HTTP_4xx_BREAKDOWN}"
                echo -e "## Summary of HTTP 4xx Errors ## \n ${HTTP_4xx_BREAKDOWN}" | mail -s "Apache HTTP 4xx errors has exceeded ${MAXERRORCOUNT} : ${ALL_4xx_ERROR_COUNT}" "pascalpeh@hotmail.com"
        fi

        # Sends email if HTTP 5xx error is greater than MAXERRORCOUNT
        if [ ${ALL_5xx_ERROR_COUNT} -gt ${MAXERRORCOUNT} ]
        then
                echo "Found a total of ${ALL_5xx_ERROR_COUNT} HTTP 4xx status code from Apache log. Please check"
                ERROR_TYPE_5xx=`echo "${ALL_5xx_ERROR}"|uniq`
                #echo "Type of 5xx errors: ${ERROR_TYPE_5xx}"
                for ERROR in `echo ${ERROR_TYPE_5xx}`
                do
                        HTTP_5xx_BREAKDOWN="${HTTP_5xx_BREAKDOWN} \nTotal Count for HTTP Error $ERROR => `echo "${ALL_5xx_ERROR}"|grep $ERROR|wc -l`"
                done
                echo -e "## Summary of HTTP 5xx Errors ## \n ${HTTP_5xx_BREAKDOWN}"
                echo -e "## Summary of HTTP 5xx Errors ## \n ${HTTP_5xx_BREAKDOWN}" | mail -s "Apache HTTP 5xx errors has exceeded ${MAXERRORCOUNT} : ${ALL_5xx_ERROR_COUNT}" "pascalpeh@hotmail.com"
        fi


else
        echo "Unable to find specified apache log file '${APACHELOGFILE}'. Please check the log file location."
fi
# End of main script