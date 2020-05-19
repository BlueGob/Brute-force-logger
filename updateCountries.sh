#!/bin/bash

sup=`mysql --password="your_password" -B --disable-column-names -e "SELECT max(hacker_id) from hackers" hack 2>> /dev/null`
inf=`mysql --password="your_password" -B --disable-column-names -e "SELECT hacker_id from hack.hackers where country is null limit 1" 2>> /dev/null`
for ((i = $inf; i <= $sup; i++))
do
	querysel="select hacker_ip from hack.hackers where hacker_id=${i}"
	ip=$(mysql --password="your_password" -B --disable-column-names -e "${querysel}" 2>> errlog/errlogsel )
	echo "${ip}" | ./ipapi.py > iptemp
	country=`cut iptemp -d ';' -f 1`
	city=`cut iptemp -d ';' -f 2`
	timezone=`cut iptemp -d ';' -f 3`
	queryins="update hack.hackers set country = \"${country}\", city = \"${city}\", timezone = \"${timezone}\" where hacker_id=${i}"
	mysql --password="your_password" -e "${queryins}" 2>> errlog/errlogins
done
rm iptemp
