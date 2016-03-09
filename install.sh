#!/bin/bash
# Be sure to include /etc/bind/named.conf.blocked in /etc/bind/named.conf
DIR=$(pwd)
FILES=('/etc/bind/named.conf.blocked' '/etc/bind/named.conf.trackers')
if [ ! -d "$DIR" ]; then
	mkdir -p $DIR
	apt-get install bind9
	for i in ${FILES[@]}; do
		echo "include '$i';" >> /etc/bind/named.conf
	done
	cp $DIR/conf/null.zone.file /etc/bind
	echo '* 12 * * * '$DIR'/update_lists.sh'  >> /etc/cron.d/afh
	echo '* */6 * * * '$DIR'/update_trackers.sh' >> /etc/cron.d/afh
else
	echo "Looks like this has already been installed. Skipping including files."
fi

bash $DIR/update_lists.sh
bash $DIR/update_trackers.sh

service bind9 restart

