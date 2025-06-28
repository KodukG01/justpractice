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
    echo "$R ERROR:: Please run the script with root access $N" | tee -a $LOG_FILE
    exit1
else
    echo "$G Script started executing with root access $N" | tee -a $LOG_FILE
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo "$2 is .......$G Success $N" | tee -a $LOG_FILE
    else
        echo "$2 is ........$R Failure $N" | tee -a $LOG_FILE
        exit 1
    fi

}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongo.repo"

dnf install mongodb-org -y &>> $LOG_FILE
VALIDATE $? "Installing mongodb"

systemctl enable mongod &>> $LOG_FILE
VALIDATE $? "Enabling mongodb"

systemctl start mongod &>> $LOG_FILE
VALIDATE $? "Start mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Enditing mogodb config files for remote connections"

systemctl restart mongod
VALIDATE $? "Restart mongodb file"
