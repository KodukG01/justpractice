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

dnf module disable nginx -y
VALIDATE $? "Disable nginx"

dnf module enable nginx:1.24 -y
VALIDATE $? "Enabling nginx 1.24"

dnf install nginx -y
VALIDATE $? "Install nginx"

systemctl enable nginx 
systemctl start nginx 
VALIDATE $? "Enable and start nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "Removing default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "Download frontend"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "Unzip files"

rm -rf /etc/nginx/nginx.conf
VALIDATE $? "Remove default nginx conf"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copying nginx.conf"

systemctl restart nginx 
VALIDATE $? "Restarting nginx"