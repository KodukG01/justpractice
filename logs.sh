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

dnf list installed mysql -y &>> $LOG_FILE
if [ $? -ne 0 ]
then
echo "Installing MYSQL" | tee -a $LOG_FILE
dnf install mysql -y &>> $LOG_FILE
VALIDATE $? "MYSQL installation"
else
echo "MYSQL Already Installed Nothing TO DO" &>> $LOG_FILE
fi

dnf list installed python3 -y &>> $LOG_FILE
if [ $? -ne 0 ]
then
echo "Installing Python3" | tee -a $LOG_FILE
dnf install python3 -y &>> $LOG_FILE
VALIDATE $? "Python3 installation" 
else
echo "Python3 Already Installed Nothing TO DO" &>> $LOG_FILE
fi

dnf list installed nginx -y &>> $LOG_FILE
if [ $? -ne 0 ]
then
echo "Installing Nginx" | tee -a $LOG_FILE
dnf install nginx -y &>> $LOG_FILE
systemctl start nginx &>> $LOG_FILE
VALIDATE $? "Nginx installation"
else
echo "Nginx Already Installed Nothing TO DO" | tee -a $LOG_FILE
fi

