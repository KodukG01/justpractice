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

dnf module disable nodejs -y
VALIDATE $? "Disable nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "Enable nodejs"

dnf install nodejs -y
VALIDATE $? "Install nodejs"

id roboshop

if [ $? -ne 0 ]
then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
     VALIDATE $? "Creating roboshop system user"
else 
     echo -e "System user roboshop already created ... $Y SKIPPING"
fi

mkdir -p /app
VALIDATE $? "Creating /app directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip
VALIDATE $? "Install zip"

rm -rf /app/*
cd /app 
unzip /tmp/cart.zip &>>$LOG_FILE
VALIDATE $? "unzipping cart"

npm install
VALIDATE $? "Installing dependencies"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
VALIDATE $? "Copying cart service"

systemctl daemon-reload
systemctl enable cart 
systemctl start cart
VALIDATE $? "Start cart"

