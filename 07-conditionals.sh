#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Please run the script with root access"
    exit 1
else
    echo "Runnning script with root access"
fi

dnf list installed mysql

if [ $? -ne 0 ]
then
    echo "Installing mysql"
    dnf install mysql -y
    if [ $? -eq 0 ]
    then
        echo "Mysql istalled successfully"
    else
        echo "Error: Failed to install mysql"
        exit 1
    fi
else
    echo "Mysql installed nothing to do"

fi
