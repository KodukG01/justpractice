#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
echo -e "$R ERROR:: Please run the script with root access $N"
exit 1
else
echo -e "$G Script started running with root access"
fi

VALIDATE() {
if [ $1 -eq 0 ]
then
echo "$G Installing $2.........Success $N"
else
echo "$R Installing $2..........Failed $N"
exit 1
fi
}

dnf list installed mysql -y
if[ $? -ne 0 ]
then
echo "Installing MYSQL"
dnf install mysql -y
VALIDATE $? "MYSQL installation"
else
echo "MYSQL Already Installed Nothing TO DO"
fi

dnf list installed python3 -y
if[ $? -ne 0 ]
then
echo "Installing Python3"
dnf install python3 -y
VALIDATE $? "Python3 installation"
else
echo "Python3 Already Installed Nothing TO DO"
fi

dnf list installed nginx -y
if[ $? -ne 0 ]
then
echo "Installing Nginx"
dnf install nginx -y
systemctl start nginx
VALIDATE $? "Nginx installation"
else
echo "Nginx Already Installed Nothing TO DO"
fi

