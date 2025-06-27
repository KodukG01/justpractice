#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Error:: Please run script with root access"
exit 1
else
    echo "Script running with root access"
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo "Installing $2 is........success"
    else
        echo "Installing $2 is........failure"
    exit 1
    fi
}

dnf list installed mysql -y

if [ $? -ne 0 ]
then
    echo "installing mysql"
    dnf install mysql -y
    VALIDATE $? "mysql"
else
    echo "Mysql installed nothing to do"
fi

dnf list installed python3 -y

if [ $? -ne 0 ]
then
    echo "installing python3"
    dnf install python3 -y
    VALIDATE $? "python3"
else
    echo "python3 installed nothing to do"
fi

dnf list installed nginx -y

if [ $? -ne 0 ]
then
    echo "installing nginx"
    dnf install nginx -y
    systemctl start nginx
    VALIDATE $? "nginx"
else
    echo "nginx installed nothing to do"
fi