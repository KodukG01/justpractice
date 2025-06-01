#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Please run the script with root access"
    exit 1
else
    echo "Runnning script with root access"
fi

dnf install mysql -y

if [ $? -ne 0 ]
then
    echo "ERROR:: MYSQL installation failed"
    exit 1
else
    echo "MSYQL successfully installed"
fi
