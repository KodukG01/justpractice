#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOG_FOLDER
echo "Script started executing at $(date)"

if [ $USERID -ne 0 ]
then
    echo "$R ERROR:: Please run the script with root access $N"
    exit1
else
    echo "$G Script started executing with root access $N"
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo "$G $2 is .......Success $N"
    else
        echo "$R $2 is ........Failure $N"
        exit 1
    fi

}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongo.repo"

dnf install mongodb-org -y 
VALIDATE $? "Installing mongodb"

systemctl enable mongod 
VALIDATE $? "Enabling mongodb"

systemctl start mongod 
VALIDATE $? "Start mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Enditing mogodb config files"

systemctl restart mongod
VALIDATE $? "Restart mongodb file"
