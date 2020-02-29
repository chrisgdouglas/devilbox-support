#!/bin/bash

devilbox_path=~/code/devilbox
curr_dir=$(pwd)
docker_down=$(systemctl show --property ActiveState docker | grep -c inactive)

if [ "$docker_down" == "1" ];
    then
        sudo /usr/bin/systemctl start docker
        docker_down=0
fi 

if [ "$docker_down" == "0" ];
    then
        cd $devilbox_path
        ./start.sh
        cd $curr_dir
    else 
        echo "Docker isn't running. Check system logs."
fi
