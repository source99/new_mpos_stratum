#!/bin/bash

if [ $# -lt 5 ]; then
	echo "not enough parameters"
	echo "git_path, coin_name, rpc_port, rpc_user, rpc_password"
	exit -1
fi

cd /home/hashcow/coins
git clone $1
cd $2/src
make -f makefile.unix
sudo cp $2d /usr/bin/


mkdir /home/hashcow/\.$2

cp /home/hashcow/new_mpos_stratum/template_coin_rpcconfig.conf /home/hashcow/\.$2/$2.conf

sed -e s/REPLACE_RPC_PORT/$3/g -i /home/hashcow/\.$2/$2.conf
sed -e s/REPLACE_RPC_USER/$4/g -i /home/hashcow/\.$2/$2.conf
sed -e s/REPLACE_RPC_PASSWORD/$5/g -i /home/hashcow/\.$2/$2.conf

sudo cp /home/hashcow/new_mpos_stratum/template_upstart.conf /etc/init/$2_daemon.conf

sudo sed -e s/REPLACE_COIN/$2/g -i /etc/init/$2_daemon.conf
sudo sed -e s/REPLACE_DAEMON/$2d/g -i /etc/init/$2_daemon.conf
sudo sed -e s/REPLACE_DIRECTORY/\.$2/g -i /etc/init/$2_daemon.conf

sudo initctl start $2_daemon
