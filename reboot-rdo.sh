#!/bin/bash

for i in $(seq 71 77)
do

    sshpass -p "changeme" ssh -o StrictHostKeyChecking=no root@192.168.0.$1 reboot

done

