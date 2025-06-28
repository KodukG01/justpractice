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

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enabling nodejs:20"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installing nodejs"

id roboshop
if [ $? -ne 0 ]
then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
    VALIDATE $? "Creating system user"
else
    echo "User created nothing to do"
fi

mkdir /app 
VALIDATE $? "Creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "Downloading catalogue"

rm -rf /app/*
cd /app 
unzip /tmp/catalogue.zip 
VALIDATE $? "Unzip catalogue file"

npm install 
VALIDATE $? "Install dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Cpying catalogue services"

systemctl daemon-reload &>>$LOG_FILE
systemctl enable catalogue  &>>$LOG_FILE
systemctl start catalogue &>>$LOG_FILE
VALIDATE $? "Starting Catalogue" 

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongodb files and folders"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing mongodb client"

STATUS=$(mongosh --host mongodb.devsecops.fun --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.devsecops.fun </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Connecting to mongodb"
else
    echo -e "Data is already loaded .........$Y skipping $N"
fi
