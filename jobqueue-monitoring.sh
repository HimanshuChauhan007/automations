#!/bin/bash

cat /dev/null > /tmp/count_ok

cat /dev/null > /tmp/count_notok

LOG_OK=/tmp/count_ok

LOG_FAIL=/tmp/count_notok

"token1=`curl --location --request GET 'API URL to generate passcode for the tool you are using for jobqueue' \

--header 'Cookie: Provide cookie if any and extract data using jq' |  jq '.token' | tr '"' ' ' | grep -i token | awk '{print $3}'`"

echo ${token1}

curl --location --request GET "API URL to get the jobqueue information' --header 'Cookie: Provide cookie if any; ewtoken=${token1}" >  job.txt

# Extract required field using JQ

cat job.txt | jq .data.objList[].jobId | tr '"' ' ' > abc.txt

check=`cat abc.txt | wc -l`

echo $check

# Logic to compare the jobqueue with a specified number

if (( $check>=30 ))

then

echo "not ok" > $LOG_FAIL

else

echo "ok" > $LOG_OK

fi

# To display data on monitoring tool i.e. Site24*7

PLUGIN_VERSION=1

HEARTBEAT=true

default_attributes="plugin_version:$PLUGIN_VERSION|heartbeat_required:$HEARTBEAT"

FILE=` cat /tmp/count_notok | wc -l `

FILE1=` cat /tmp/count_ok | wc -l `

attributes="fail_count:$FILE|ok_count:$FILE1"

PLUGIN_OUTPUT=$PLUGIN_OUTPUT"plugin_version:$PLUGIN_VERSION|"

PLUGIN_OUTPUT=$PLUGIN_OUTPUT"heartbeat_required:$HEARTBEAT|"

PLUGIN_OUTPUT=$PLUGIN_OUTPUT"fail_count:$FILE|"

PLUGIN_OUTPUT=$PLUGIN_OUTPUT"ok_count:$FILE1"

echo "$PLUGIN_OUTPUT" 
