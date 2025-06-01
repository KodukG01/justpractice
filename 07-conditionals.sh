#!/bin/bash

USERID=$(id -u)

if [ $USERID -eq 0 ]
then
    echo "Please run the script with root access"
else
    echo "Runnning script with root access"
fi
