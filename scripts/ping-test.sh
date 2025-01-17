for i in `seq 1 5`
do

    sudo ping -c 1 192.168.0.19$i
    sudo ping -c 1 192.168.2.19$i

done

