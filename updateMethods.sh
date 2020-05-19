#!/bin/bash
grep -oE 'Failed password for [a-zA-Z0-9_]+ from ([0-9]+\.){3}[0-9]+ port [0-9]+' /var/log/auth.log | sort | uniq > temp
cpt=0

while read line; do
	line=${line##*( )}

	usr=`echo "$line" | cut -d ' ' -f 4`
	ip=`echo "$line" | cut -d ' ' -f 6`
	por=`echo "$line" | cut -d ' ' -f 8`
	query="select hacker_id from hack.hackers where hacker_ip=\"${ip}\""
	id=$(mysql --password="your_password" -B --disable-column-names -e "${query}" 2> /dev/null )
	if [ -n "$id" ]; then
        query="insert into hack.methods (hacker_id, username, port) values (${id},\"${usr}\",${por})"
        mysql --password="your_password" -e "${query}" 2> /dev/null && let "cpt++"
	fi
done < temp

rm temp
wakt=`date +"%d-%m-%Y"`
echo "Today ${wakt}, server has been rammed in $cpt unique way" >> /var/log/hack.log

