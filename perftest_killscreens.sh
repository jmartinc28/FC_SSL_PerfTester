#!/bin/bash

for sessionName in $(screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}')
do
    echo "Killing Session $sessionName"
    screen -S $sessionName -p 0 -X stuff "^C"
    sleep 1
done