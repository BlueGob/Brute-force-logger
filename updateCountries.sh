#!/bin/bash
source config.conf

sup=`mysql -u$user -p$pass -B --disable-column-names -e "SELECT max(hacker_id) from hackers" hack 2>> /dev/null`
inf=`mysql -u$user -p$pass -B --disable-column-names -e "SELECT hacker_id from hack.hackers where country is null or country='' limit 1" 2>> /dev/null`

if [[ -z "$inf" ]]; then
	echo "No countries to update"
	exit 0
fi

for ((i = $inf; i <= $sup; i++))
do
	querysel="select hacker_ip from hack.hackers where hacker_id=${i}"
	ip=$(mysql -u$user -p$pass  -B --disable-column-names -e "${querysel}" 2>> /dev/null )
	echo "${ip}" | python3 ipapi.py > iptemp
	country=`cut iptemp -d ';' -f 1`
	city=`cut iptemp -d ';' -f 2`
	timezone=`cut iptemp -d ';' -f 3`
	queryins="update hack.hackers set country = \"${country}\", city = \"${city}\", timezone = \"${timezone}\" where hacker_id=${i}"
	mysql -p3asba -e "${queryins}" 2>> /dev/null
done
rm iptemp
