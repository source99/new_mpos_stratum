#!/bin/bash

#check command line arguments

if [ $# -lt 7 ]; then
	echo "not enough parameters"
	echo "code_name, rpc_port, rpc_user, rpc_password, wallet_address, stratum_port wallet_host"
	exit -1
fi



#create databasei
echo "creating new database for $1"
sudo mysql -u root -pQwerty21 -e "create database $1"
echo "creating tables in database for $1"
sudo mysql -u root -pQwerty21 $1 < /var/www/MPOS_template/sql/000_base_structure.sql

#copy stratum-mining template
echo "copying stratum server"
cp -r /home/ubuntu/stratum_directories/stratum_mining_template /home/ubuntu/stratum_directories/$1


#replace values in conf file
echo "updating stratum server $1 with correct values"
sed -e s/REPLACE_CODE_NAME/$1/g -i /home/ubuntu/stratum_directories/$1/conf/config.py
sed -e s/REPLACE_DB_NAME/$1/g -i /home/ubuntu/stratum_directories/$1/conf/config.py
sed -e s/REPLACE_COINDAEMON_TRUSTED_PORT/$2/g -i /home/ubuntu/stratum_directories/$1/conf/config.py
sed -e s/REPLACE_COINDAEMON_TRUSTED_USER/$3/g -i /home/ubuntu/stratum_directories/$1/conf/config.py
sed -e s/REPLACE_COINDAEMON_TRUSTED_PASSWORD/$4/g -i /home/ubuntu/stratum_directories/$1/conf/config.py
sed -e s/REPLACE_CENTRAL_WALLET/$5/g -i /home/ubuntu/stratum_directories/$1/conf/config.py
sed -e s/REPLACE_LISTEN_SOCKET_TRANSPORT/$6/g -i /home/ubuntu/stratum_directories/$1/conf/config.py
sed -e s/REPLACE_COINDAEMON_TRUSTED_HOST/$7/g -i /home/ubuntu/stratum_directories/$1/conf/config.py

#copy MPOS template
echo "copying MPOS"
sudo cp -r /var/www/MPOS_template /var/www/MPOS_$1

#replace values in conf file
echo "updating MPOS_$1 with proper values"
sudo sed -e s/REPLACE_CODE_NAME/$1/g -i /var/www/MPOS_$1/public/include/config/global.inc.php
sudo sed -e s/REPLACE_DB_NAME/$1/g -i /var/www/MPOS_$1/public/include/config/global.inc.php
sudo sed -e s/REPLACE_COINDAEMON_TRUSTED_PORT/$2/g -i /var/www/MPOS_$1/public/include/config/global.inc.php
sudo sed -e s/REPLACE_COINDAEMON_TRUSTED_USER/$3/g -i /var/www/MPOS_$1/public/include/config/global.inc.php
sudo sed -e s/REPLACE_COINDAEMON_TRUSTED_PASSWORD/$4/g -i /var/www/MPOS_$1/public/include/config/global.inc.php
sudo sed -e s/REPLACE_CENTRAL_WALLET/$5/g -i /var/www/MPOS_$1/public/include/config/global.inc.php
sudo sed -e s/REPLACE_LISTEN_SOCKET_TRANSPORT/$6/g -i /var/www/MPOS_$1/public/include/config/global.inc.php
sudo sed -e s/REPLACE_COINDAEMON_TRUSTED_HOST/$7/g -i /var/www/MPOS_$1/public/include/config/global.inc.php


#install /etc/init/special_twistd
echo "copying config to automatically start twistd on system boot"
sudo cp /home/ubuntu/new_mpos_stratum/template_twistd.conf /etc/init/twistd_$1.conf

#start /etc/init/special_twistd
echo "updating /etc/init/twistd_$1.conf with proper values"
sudo sed -e s/REPLACE_CODE_NAME/$1/g -i /etc/init/twistd_$1.conf

#start twistd server
echo "starting server"
sudo initctl start twistd_$1

#setting permissions
sudo chown -R www-data /var/www/MPOS_$1/public/templates/compile /var/www/MPOS_$1/public/templates/cache /var/www/MPOS_$1/logs

 
echo "adding cronjobs to crontab"
command="/var/www/MPOS_$1/cronjobs/run-crons.sh"
job="*/2 * * * * $command"

(sudo crontab -l; echo "*/1 * * * * /var/www/MPOS_$1/cronjobs/run-crons.sh") | sudo crontab
