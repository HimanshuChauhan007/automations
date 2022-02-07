#!/bin/bash

to=`date +"%T"`
echo $to
let from_in_seconds=`date +%s`-900
from=`date -d @$from_in_seconds +"%T"`
echo $from
a=`awk '$3>=from && $3<=to' from="$from" to="$to" logs_check1 | grep "property name or domain name" | grep -i "server name" | wc -l`
echo $a

b=`awk '$3>=from && $3<=to' from="$from" to="$to" logs_check1 | grep "property name or domain name" | grep -i "server name" | wc -l`
echo $b

c=`expr $a - $b`
echo $c

if [ $c -gt 50 ]
then
status = 0
elif [ $c -gt -50 -a $c -lt 50 ]
then
status = 1
else
status = 0
fi

# To display data on monitoring tool i.e. Site24*7

PLUGIN_VERSION=1
HEARTBEAT=true

#METRICS_UNITS={file_count-'count',dir_count-'count'}

default_attributes="plugin_version:$PLUGIN_VERSION|heartbeat_required:$HEARTBEAT"

attributes="Status:$status"
echo "$attributes|$default_attributes"
