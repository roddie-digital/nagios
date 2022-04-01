#!/bin/sh
# 2020-06-01 https://roddie.digital
# Nagios plugin to check stratum level of NTP server

stratum=`chronyc tracking | grep -o Stratum.*`
stratum=${stratum#*:}

if [ $stratum -eq 2 ]
then
    OUTPUT='STRATUM OK: Synced to stratum 1 (GPS)'
    EXIT=0
elif [ $stratum -eq 4 ]
then
    OUTPUT='STRATUM CRITICAL: Synced to stratum 3, local NTP has switched to backup'
    EXIT=2
else
    OUTPUT='STRATUM UNKNOWN: Unable to determine NTP stratum'
    EXIT=3
fi

echo "$OUTPUT"
exit $EXIT
