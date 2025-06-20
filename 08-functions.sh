#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR:: Please run the script with root access"
    exit 1
else
    echo "Running with root access"
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo "Installing $2.....success"
    else
        echo "Installing $2......failed"
        exit 1
    fi
}

dnf list installed mysql -y

if [ $? -ne 0 ]
then
    echo "Installing MYSQL"
    dnf install mysql -y
    VALIDATE $? "mysql"
else
    echo "MYSQL installed nothing to do"
fi

dnf list installed python3

if [ $? -ne 0 ]
then
    echo "Installing python3"
    dnf install python3 -y
    VALIDATE $? "Python3"
else
    echo "Python3 already installed"
fi

dnf list installed nginx

if [ $? -ne 0 ]
then
    echo "Installing nginx"
    dnf install nginx -y
    VALIDATE $? "nginx"
else
    echo "nginx already installed"
fi

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Copying catalogue.service"
