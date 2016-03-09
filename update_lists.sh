#!/bin/bash
# Updates the lists and formats for named.conf.blocked use
DIR="/opt/adblocker/lists"
ZONEFILE="/etc/bind/null.zone.file"
if [ ! -d "$DIR" ]; then
	mkdir -p $DIR
fi

if [ -a /etc/bind/named.conf.blocked ]; then
	rm /etc/bind/named.conf.blocked
fi

lists=('http://adblock.gjtech.net/?format=unix-hosts' 'http://mirror1.malwaredomains.com/files/justdomains' 'http://sysctl.org/cameleon/hosts' 'https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist' 'https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt' 'https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt')

for i in ${lists[@]}; do
	NAME=$(echo $i | sed 's/http:\/\///g' | sed 's/https:\/\///g' | cut -d"/" -f1)
	echo "Fetching $NAME ..."
#	curl $i -o $DIR/$NAME
done

for i in $(ls $DIR); do
	for h in $(cat $DIR/$i | grep '127.0.0.1' | awk {'print $2'} | sort | uniq); do
		echo 'zone "'"$h"'" { type master; notify no; file "'"$ZONEFILE"'"; };' >> /etc/bind/named.conf.blocked.tmp
	done
done

cat /etc/bind/named.conf.blocked.tmp | egrep -v '_|localhost' | sort | uniq > /etc/bind/named.conf.blocked
rm /etc/bind/named.conf.blocked.tmp
service bind9 restart
