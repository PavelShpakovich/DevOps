#!/bin/bash

THRESHOLD=10

if [[ $# -gt 0 && $1 =~ ^[0-9]+$ ]]
then
    THRESHOLD=$1
else
    echo "Using the defualt threshold"
fi

echo "Treshold = $THRESHOLD%" 

df -Ph | grep -vE '^Filesystem|tmpfs|cdrom|map|Code' | awk '{print $1,$5}' | while read data;
do
    capacity=$(echo $data | awk '{print $2}' | sed s/%//g)
    p=$(echo $data | awk '{print $1}')
    if [[ $capacity -ge $THRESHOLD ]]
    then
        echo "WARNING: The partition \"$p\" has used $capacity% of total available space"
    fi
done

