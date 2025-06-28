#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
echo "ERROR:: Please run with root access"
exit 1

else
echo "Script running with root access"

fi

dnf list installed mysql -y

if [ $? -ne 0 ]
then
echo "Installing mysql -y"

dnf install mysql -y

else
echo "Mysql installed successfully, nothing to do"
fi

