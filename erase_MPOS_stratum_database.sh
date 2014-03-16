#!/bin/bash

if [ $# -lt 1 ]; then
	echo "not enough parameters"
	echo "code_name"
	exit -1
fi

echo "removing $1 database"
mysql -u root -pQwerty21 -e "drop database $1"
echo "removing $1 stratum server"
rm -rf /home/ubuntu/stratum_directories/$1
echo "removing MPOS server"
sudo rm -rf /var/www/MPOS_$1
echo "removing automatic start script"
sudo initctl stop twistd_$1
sudo rm /etc/init/twistd_$1.conf
echo remove crontab
sudo crontab -l | grep -v MPOS_$1 > temp_new_crontab
sudo crontab temp_new_crontab
rm temp_new_crontab

