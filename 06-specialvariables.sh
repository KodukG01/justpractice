#!/bin/bash

echo "All variables: $@"
echo "Number of variables: $#"
echo "Current script name: $0"
echo "Current working directory: $PWD"
echo "User running the script: $USER"
echo "PID of current script: $$"
sleep 10
echo "PID of last command: $!
echo "Exit status of last command: $?"

#  Special Variables in Shell Sceipting
#  • $0: Script name
#  • $1, $2…: Positional arguments
#  • $@: All arguments individually
#  • $*: All arguments as one string
#  • $#: Number of arguments passed to the script
#  • $PWD: Current working directory
#  • $HOME: Home directory of the current user
#  • $USER: User running the script
#  • $$: Process ID of the current script
#  • $!: PID of the last background command
#  • $?: Exit status of the last executed comand
#  • $-: Current shell flags/options