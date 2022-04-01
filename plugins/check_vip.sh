#!/bin/bash
# 2018-11-19 https://roddie.digital
# Check virtual/floating IP address is only active on Primary mirror member node

#determine cache mirror status and store in variable
status=$(ccontrol list | grep -o "Status.*")
status=${status#*=}
status=$(echo $status | xargs)

#check if vip is present
vip='secondary ens192'
result=$(ip a | grep "$vip")

#
a1="Primary"
a2="Backup"

if [ "$status" = "$a2" ]
then
    #this the backup node, check the vip is down
    if [ -z "$result" ]
    then
        OUTPUT="OK - Server is $status and VIP is down on this server"
        EXIT=0
    else
        OUTPUT="CRITICAL - Server is $status and the VIP is up on this server"
        EXIT=2
    fi
elif [ "$status" = "$a1" ]
then
    #server is primary node, check the vip is up
    if [ -z "$result" ]
    then
        OUTPUT="CRITICAL - Server is $status and VIP is down on this server"
        EXIT=2
    else
        OUTPUT="OK - Server is $status and VIP is up on this server"
        EXIT=0
    fi
else
    #unable to determine mirror status
    if [ -z "$result" ]
    then
        OUTPUT="UNKNOWN - Unable to determine mirror status and VIP is down on this server"
        EXIT=3
    else
        OUTPUT="CRITICAL - Unable to determine mirror status and VIP is up on this server"
        EXIT=2
   fi
fi

echo $OUTPUT
exit $EXIT
