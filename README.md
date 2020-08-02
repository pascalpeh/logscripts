# Logscripts 

## Overview
This repository contains the following unix bash scripts
* scripts/checkApacheError.sh
* scripts/logscleanup.sh


Script Name         | Location                      | Purpose
--------------------|-------------------------------|-------------------
checkApacheError.sh | scripts/checkApacheError.sh   | Counts the number of HTTP 4xx/5xx response statuses in apache log file and sends email when error exceeds 100
logscleanup.sh      | scripts/logscleanup.sh        | Cleans up log files that are older than 3 days from specified directory


## Requirements
* Requires postfix, mailx package to be installed & configured for sending of email notifications in bash scripts (Or use any other email client packages)
* Requires SMTP account for sending email notifications (Can use free Gmail)

## Test environment
* OS: RedHat version 7.7
* postfix version 2.10.1
* mailx version 12.5

## How to use/run
The scripts are located under the directory "scripts". To use the scripts, check the "Required Variables" at the top of each script and modify them accordingly, the purpose of the variables are also described below.

### Variables for "script/checkApacheError.sh"
#### Variables
Variable Name   | Purpose            
----------------|--------------------------
APACHELOGFILE   | Specify the file location of Apache log file
MAXERRORCOUNT   | Specify the maximum number of HTTP error count before sending     

#### Sample output for "script/checkApacheError.sh"
\# ./checkApacheError.sh\
Found Apache log file\
Total HTTP 4xx error count: 328\
Total HTTP 5xx error count: 1\
Found a total of 328 HTTP 4xx status code from Apache log. Please check\
\## Summary of HTTP 4xx Errors ##\
Total Count for HTTP Error 403 => 84\
Total Count for HTTP Error 404 => 244\

#### Use cronjob scheduler below to run the script "checkApacheError.sh" daily at 12am automatically
crontab -e
0 0 * * * /checkApacheError.sh

### Required variables for "script/logscleanup.sh"
#### Variables
Variable Name   | Purpose            
----------------|--------------------------
LOGDIRECTORY    | Specify the directory that contains the log files to clean up
LOGFILEPREFIXES | Specify a list of log file prefixes to clean up 
MODIFIEDTIME    | Number of days to keep the logs (eg. 3 means to keep the last 3 days of logs and purge logs older than 3 days)
LOGFILE         | Location of log file to be used by this script (eg. This log file can be used to check what and when the log file prefixes that has been cleaned up or deleted)

#### Sample log file for "script/logscleanup.sh" (Tested with log file prefixes "yum boot choose tally last secure messages")
\# cat logscleanup.log
\=========================================================
This script was executed on Wed Jul 29 18:38:19 +08 2020
==> Output a list of log file prefixes to be cleaned up: 'yum boot choose tally last secure messages'
Found Log Files '/var/log/yum.log' that has been modified more than 3 days ago
Proceeding to delete log files /var/log/yum.log
Found Log Files '/var/log/boot.log' that has been modified more than 3 days ago
Proceeding to delete log files /var/log/boot.log
Found Log Files '/var/log/choose_repo.log' that has been modified more than 3 days ago
Proceeding to delete log files /var/log/choose_repo.log
Cannot find log file prefix 'tally*' that has been modified more than 3 days ago
Cannot find log file prefix 'last*' that has been modified more than 3 days ago
Cannot find log file prefix 'secure*' that has been modified more than 3 days ago
Cannot find log file prefix 'messages*' that has been modified more than 3 days ago