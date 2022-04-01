#!/bin/sh
# 2019-02-20 https://roddie.digital
# Check for stale logins (idle for 24hrs+)

#first arg should be warning threshold
if [ -z $1 ]
then
    #set it to 1 if not
    WARNING=1
else
    WARNING=$1
fi

#second arg should be critical threshold
if [ -z $2 ]
then
    #set it to 2 if not
    CRITICAL=2
else
    CRITICAL=$2
fi

#check the users, grep old ones and then count them
#grep -w is whole word match to avoid false positives
OLD=$(who -u | grep old | wc -l)
USERS=$(who -u | grep old | awk '{print $1}')

if [ $OLD -ge $CRITICAL ]
then
    OUTPUT="CRITICAL: $OLD user(s) idle for over 24 hours: $USERS"
    EXIT=2
elif [ $OLD -ge $WARNING ]
then
    OUTPUT="WARNING: $OLD user(s) idle for over 24 hours: $USERS"
    EXIT=1
elif [ $OLD -eq 0 ]
then
    OUTPUT='OK: No users idle for over 24 hours'
    EXIT=0
else
    OUTPUT='UNKNOWN: Unable to determine users idle for over 24 hours'
    EXIT=3
fi

#print the output for nagios and exit with relevant code
echo "$OUTPUT | oldlogins=$OLD"
exit $EXIT
