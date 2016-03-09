#!/bin/bash
# Be sure to include /etc/bind/named.conf.blocked in /etc/bind/named.conf
DIR=$(pwd)
CONFFILE="/etc/bind/named.conf.blocked"

if [ ! -d "$DIR" ]; then
	mkdir -p $DIR
	apt-get install bind9
	echo "include '$CONFFILE';" >> /etc/bind/named.conf
	cp $DIR/conf/null.zone.file /etc/bind
	echo '* 12 * * * '$DIR'/update_lists.sh' 
else
	echo "Looks like this has already been installed. Skipping including files."
fi

bash $DIR/update_lists.sh

service bind9 restart

