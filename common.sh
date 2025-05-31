#!/bin/bash

USERID=$(id -u)
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shell-script-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="/$LOGS_FOLDER/$SCRIPT_NAME.log"

check_root(){
    if ( $USERID -ne 0 )
    then
        echo -e "ERROR:: $R Please run with root access $N"
        exit 1
    else
        echo "Running with root access"
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2....$G Success $N"
    else
        echo -e "$2....$R Failed $N"
        exit 1
    fi
}

check_root

mkdir -p $LOGS_FOLDER

USAGE(){
    echo "USAGE:: sudo sh backup.sh <source-dir> <destination-dir> <days(optional)>"
    exit 1
}

if [ $# -lt 2 ]
then
    USAGE
fi

if [ ! -d $SOURCE_DIR]
then
    echo "$R Source directory $SOURCE_DIR doesnt exist please check"
    exit 1
fi

if [ ! -d $DEST_DIR ]
then
    echo "$R Destination directory $DEST_DIR doesnt exist please check"
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$(DAYS))

if [ ! -z  $FILES ]
then
    echo "Files to zip are: $FILES"
    TIMESTAMP=($date +%F-%M-%S)
    ZIP_FILE="$DEST-DIR/app-logs-$TIMESTAMP.zip"
    echo "$FILES| zip -@ $ZIP_FILE
else
    echo -e "No log file found older than 14 days .... $Y Skipping $N"
fi

if [ -f $ZIP_FILE ]
then
    echo -e "Successfully created zip file"
    
    while IFS= read -r $filepath
    do
        echo "Remove files: $filepath"
        r -rf $filepath
    done <<< $FILES
fi
    