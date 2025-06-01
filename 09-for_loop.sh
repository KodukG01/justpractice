#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/log/roboshop_log"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
packages=("mysql" "python3" "nginx")

mkdir -p $LOG_FOLDER
echo "Script started executing at $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROE:: Please run the script with root access $N" | tee -a $LOG_FILE
    exit 1
else    
    echo -e "Running script with root access" | tee -a $LOG_FILE
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo "$G Installing $2 is.....success $N" | tee -a $LOG_FILE
    else
        echo "$R Installing $2 is......failure $N" | tee -a $LOG_FILE
        exit 1
    fi
}

for package in ${packages[@]}
do
    dnf list installed $package $>>$LOG_FILE
    if [ $? -ne 0 ]
    then
        echo "Installing packages" | tee -a $LOG_FILE
        dnf install $package -y $>>$LOG_FILE
        VALIDATE $? "$package"
    else
        echo "Installed nothing to do" | tee -a $LOG_FILE
    fi  
done