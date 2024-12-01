#!/bin/bash

for i in $(seq 181 187)
do

    sshpass -p "changeme" ssh -o StrictHostKeyChecking=no root@192.168.0.$i reboot

done

