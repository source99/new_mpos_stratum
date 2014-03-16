#!/bin/bash

if [ $# -lt 5 ]; then
	echo "not enough parameters"
	echo "git_path, coin_name, rpc_port, rpc_user, rpc_password"
	exit -1
fi

cd $HOME/coins
git clone $1
AFTER_SLASH=${1##*/}
B=${AFTER_SLASH%.git}
BEFORE_git=${AFTER_SLASH%.git}

cd $B/src
#make -f makefile.unix
sudo cp $B\d /usr/bin/


mkdir $HOME/\.$B

cp $HOME/new_mpos_stratum/template_coin_rpcconfig.conf $HOME/\.$B/$B.conf

sed -e s/REPLACE_RPC_PORT/$3/g -i $HOME/\.$B/$B.conf
sed -e s/REPLACE_RPC_USER/$4/g -i $HOME/\.$B/$B.conf
sed -e s/REPLACE_RPC_PASSWORD/$5/g -i $HOME/\.$B/$B.conf

sudo cp $HOME/new_mpos_stratum/template_upstart.conf /etc/init/$B\d.conf

sudo sed -e s/REPLACE_COIN/$B/g -i /etc/init/$B\d.conf
sudo sed -e s/REPLACE_DAEMON/$B\d/g -i /etc/init/$B\d.conf
sudo sed -e s/REPLACE_DIRECTORY/\.$B/g -i /etc/init/$B\d.conf

sudo initctl start $B\d
