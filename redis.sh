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
    echo -e "$R ERROR:: Please run the script with root access $N" | tee -a $LOG_FILE
    exit1
else
    echo -e "$G Script started executing with root access $N" | tee -a $LOG_FILE
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is .......$G Success $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is ........$R Failure $N" | tee -a $LOG_FILE
        exit 1
    fi

}

dnf module disable redis -y
VALIDATE  $? "Disable redis"

dnf module enable redis:7 -y
VALIDATE $? "Enable redis"

dnf install redis -y 
VALIDATE $? "Install redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Change redis.config"

systemctl enable redis 
VALIDATE $? "Enable redis"

systemctl start redis 
VALIDATE $? "Start redis"