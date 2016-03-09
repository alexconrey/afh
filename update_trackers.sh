#!/bin/bash
# Updates the lists and formats for named.conf.blocked use
DIR="/opt/adblocker/trackers"
ZONEFILE="/etc/bind/null.zone.file"
if [ ! -d "$DIR" ]; then
	mkdir -p $DIR
fi

if [ -a /etc/bind/named.conf.trackers ]; then
	rm /etc/bind/named.conf.trackers
fi

lists=('https://raw.githubusercontent.com/quidsup/notrack/master/trackers.txt')
for i in ${lists[@]}; do
	NAME=$(echo $i | sed 's/http:\/\///g' | sed 's/https:\/\///g' | cut -d"/" -f1)
	echo "Fetching $NAME ..."
	curl $i -o $DIR/$NAME
done

for i in $(ls $DIR); do
	for t in $(cat $DIR/$i | grep -v '^#' | awk '{ print $1 }' | sort | uniq); do
		echo 'zone "'"$t"'" { type master; notify no; file "'"$ZONEFILE"'"; };' >> /etc/bind/named.conf.trackers.tmp
	done
done

cat /etc/bind/named.conf.trackers.tmp | sort | uniq > /etc/bind/named.conf.trackers

service bind9 restart
