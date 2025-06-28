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

mkdir -p $LOGS_FOLDER

echo -e "Script started running at $(date)" &>> $LOG_FILE


if [ $USERID -ne 0 ]
then
echo -e "$R ERROR:: Please run the script with root access $N" &>> $LOG_FILE
exit 1
else
echo -e "$G Script started running with root access" &>> $LOG_FILE
fi

VALIDATE() {
if [ $1 -eq 0 ]
then
echo -e "$G Installing $2.........Success $N" &>> $LOG_FILE
else
echo -e "$R Installing $2..........Failed $N" &>> $LOG_FILE
exit 1
fi
}

dnf list installed mysql -y &>> $LOG_FILE
if [ $? -ne 0 ]
then
echo "Installing MYSQL" &>> $LOG_FILE
dnf install mysql -y
VALIDATE $? "MYSQL installation"
else
echo "MYSQL Already Installed Nothing TO DO" &>> $LOG_FILE
fi

dnf list installed python3 -y &>> $LOG_FILE
if [ $? -ne 0 ]
then
echo "Installing Python3"
dnf install python3 -y &>> $LOG_FILE
VALIDATE $? "Python3 installation" 
else
echo "Python3 Already Installed Nothing TO DO" &>> $LOG_FILE
fi

dnf list installed nginx -y
if [ $? -ne 0 ]
then
echo "Installing Nginx" &>> $LOG_FILE
dnf install nginx -y &>> $LOG_FILE
systemctl start nginx &>> $LOG_FILE
VALIDATE $? "Nginx installation" &>> $LOG_FILE
else
echo "Nginx Already Installed Nothing TO DO" &>> $LOG_FILE
fi

