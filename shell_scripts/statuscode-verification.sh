#!/bin/bash

cat /dev/null > /tmp/ok_response

cat /dev/null > /tmp/false_response

LOG_OK=/tmp/ok_response

LOG_FAIL=/tmp/false_response

#Ping Whatever API to you need to check status code for and store the value in variable

status_code=$(curl --write-out %{http_code} --silent --output /dev/null 'Provide the URL' -H 'x-user-id: XXXXXXXXXXX' -H 'x-global-user-id: XXXXXXXXXXX' -H 'accept: application/json')

echo "$status_code"

# Logic to compare the status code

if (($status_code!=200))

then

echo "Response value is false: $status_code" > $LOG_FAIL

else 

echo "Response code received is true: $status_code" > $LOG_OK

fi

# Logic to display the data on monitoring tool i.e. Site24*7

PLUGIN_VERSION=1

HEARTBEAT=True

default_attributes="Plugin_Version:$PLUGIN_VERSION|Heartbeat_required:$HEARTBEAT"

FILE=`cat /tmp/false_response | wc -l`

FILE1=`cat /tmp/ok_response | wc -l`

attributes=" False_Response:$FILE| Ok_Response:$FILE1"

PLUGIN_OUTPUT=$PLUGIN_OUTPUT" Plugin_Version:$PLUGIN_VERSION | "

PLUGIN_OUTPUT=$PLUGIN_OUTPUT" False_Response:$FILE | "

PLUGIN_OUTPUT=$PLUGIN_OUTPUT" Ok_Response:$FILE1 "

echo "$PLUGIN_OUTPUT "
