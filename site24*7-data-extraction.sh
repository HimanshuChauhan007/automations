#!/bin/bash
 
rm -rf monitor.txt
rm -rf data.txt
rm -rf monitor.txt
rm -rf result.json
rm -rf final.csv
rm -rf alarm-new.json
rm -rf final-new.csv
 
#Get Access token from the refresh token for authentication with Site24x7
token=`curl https://accounts.zoho.com/oauth/v2/token -X POST -d "client_id=XXXXXXXXXXXXXXX" -d "client_secret=XXXXXXXXXXXXXXX" -d "refresh_token=XXXXXXXXXXXXXXX" -d "grant_type=refresh_token" | jq '.access_token' | tr '"' ' '`
 
echo $token 
 
echo "Running job to get monitor id"

#Get yesterday data since contant used is 4 for last month use 7 or read details on https://www.site24x7.com/help/api/#constants

curl "https://www.site24x7.com/api/reports/alarm?period=4" -X GET -H "Accept: application/json; version=2.0" -H "Authorization: Zoho-oauthtoken $token" > data.txt
 
echo "fetching monitor id"
 
cat data.txt | jq .data.outage_details[].monitor_id | tr '"' ' ' > monitor.txt
 
echo "Running for loop"
 
for i in `cat monitor.txt` ; do curl "https://www.site24x7.com/api/reports/alarm/$i?period=4" -X GET -H "Accept: application/json; version=2.0" -H "Authorization: Zoho-oauthtoken $token" ; done >> alarm-new.json
 
cat alarm-new.json | jq '.data | [.info.resource_name, .info.monitor_type, .summary_details.alarm_count, .outage_details[].outages[].reason , .outage_details[].outages[].duration , .outage_details[].outages[].type ] | @csv' > final-new.csv
