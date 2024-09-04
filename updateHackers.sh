#!/bin/bash
source config.conf

grep -oE '([0-9]*\.){3}[0-9]*' /var/log/auth.log | uniq | tac > temp.txt

cpt=0
while read line; do
line=${line##*( )}
query="select hacker_id from hack.hackers where hacker_ip=\"${line}\""
var=$(mysql -u$user -p$pass -B --disable-column-names -e "${query}" 2> /dev/null )
if [ -z "$var" ]; then
	query="insert into hack.hackers (hacker_ip) values (\"${line}\")"
	mysql -p$pass -e "${query}" 2> /dev/null && let "cpt++"
fi
done < temp.txt

wakt=`date +"%d-%m-%Y"`
echo "$wakt: there has been $cpt new IP addresses added" >> hack.log
rm temp.txt
