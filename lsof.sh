#!/bin/bash

echo -e 'PID\tUSER\tNAME\tCOMM'

for i in $(ls /proc/ | grep -P "[0-9]" | sort -n)
do
    proc="/proc/$i"
    if [[ -d "$proc" ]]
    then
    USER=`awk '/Uid/{print $2}' /proc/$i/status`

    COMM=`cat /proc/$i/comm`

    if [[ User -eq 0 ]]
    then
    UserName='root'
    else
    USERNAME=`grep $USER /etc/passwd | awk -F ":" '{print $1}'`
    fi

    map_files=`readlink /proc/$i/map_files/*; readlink /proc/$i/cwd`
    if ! [[ -z "$map_files" ]]
    then
    for NUM in $map_files
    do
    echo -e $i '\t' $USERNAME '\t' $NUM '\t' $COMM
    done
    fi

   fi
done