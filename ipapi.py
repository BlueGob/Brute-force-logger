#!/usr/bin/env python
import requests
import sys
import time

data = sys.stdin.readlines()
result = requests.get("http://ip-api.com/json/%s" % data[0].strip())
if result.status_code != 200:
	time.sleep(35)
	result = requests.get("http://ip-api.com/json/%s" % data[0].strip())
	while  result.status_code != 200:
		 result = requests.get("http://ip-api.com/json/%s" % data[0].strip())
if result.json()["status"] != "success":
	with open("errlog/ip_apifaillog","a") as res:
		res.write(result.text+"\n")
	st="noinfo;noinfo;noinfo"
else :
	js=result.json()
	st=js["country"]+";"+js["city"]+";"+js["timezone"]
print(st.encode('utf-8').strip())
