#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shellscript-log"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD
Packages=("mysql" "python3" "nginx" "httpd")

mkdir -p $LOGS_FOLDER

echo -e "Script started running at $(date)" | tee -a $LOG_FILE


if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run the script with root access $N" | tee -a $LOG_FILE
    exit 1
else
    echo -e "$G Script started running with root access" | tee -a $LOG_FILE
fi

VALIDATE() {
if [ $1 -eq 0 ]
then
    echo -e "$G Installing $2.........Success $N" | tee -a $LOG_FILE
else
    echo -e "$R Installing $2..........Failed $N" | tee -a $LOG_FILE
    exit 1
fi
}

for package in ${Packages[$@]}
do
    dnf list installed $package &>> $LOG_FILE
    if [ $? -ne 0 ]
    then
        echo "Installing packages" | tee -a $LOG_FILE
        dnf install $package -y &>> $LOG_FILE
        VALIDATE $? "Packages"
    else
        echo "Packages installed nothing to do" | tee -a $LOG_FILE
    fi

done