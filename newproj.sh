#!/bin/bash
#set variables
project_path=~/code/projects
devilbox_path=~/code/devilbox
docker_down=$(systemctl show --property ActiveState docker | grep -c inactive)
curr_dir=$(pwd)
if sudo -nv 2>/dev/null && sudo -v ; then
    sudo_active=1
else
    sudo_active=0
fi
echo "Creating project paths."
mkdir $project_path/$1
mkdir $project_path/$1/htdocs
mkdir $project_path/$1/.vscode
echo "Creating new project git."
git init $project_path/$1/htdocs
echo "Creating placeholder html file."
touch $project_path/$1/htdocs/index.html
echo "Preparing project config files."
cp $project_path/default.code-workspace $project_path/$1.code-workspace
cp -r $project_path/.vscode $project_path/$1/
#replace placeholder in defaults with project specific paths
sed -i "s|REPLACE|${1}|g" $project_path/$1.code-workspace
sed -i "s|REPLACE|${1}|g" $project_path/$1/.vscode/launch.json
echo "Updating /etc/hosts with a new entry for project. Access http://$1.loc in your browser."
if [ "$sudo_active" == "1" ] ; 
then
    sudo sed -i "$ a 127.0.0.1  $1.loc" /etc/hosts
else
    echo "Error: No access to /etc/hosts."
fi
echo "Start docker and launching devilbox image."
if [ "$docker_down" == "1" ] && [ "$sudo_active" == "1" ] ;
then
    sudo systemctl start docker
    docker_down=0
else
    echo "Error: Can't start docker."
fi
if [ "$docker_down == "0" ] ;
then
    cd $devilbox_path
    ./start.sh
    #go back home
    cd $curr_dir
fi
echo "Complete."
