#!/bin/sh
# 2019-09-16 https://roddie.digital
# Checks number of disabled printers
# $0 <servername> <warning threshold> <critical threshold>
# Requires lpstat

# count of jobs
disprint=`lpstat -h $1 -p 2>/dev/null | grep '^printer [^ ]\+ \+disabled since '`
#disprint=`lpstat -h $1 -p 2>/dev/null | grep 'enabled'`

msg='CUPS Disabled Printers'
if [ -z "$disprint" ]; then
        echo "OK: $msg: 0 Disabled Printers"
        exit 0
fi

discount=`echo "$disprint" | wc -l`

if [ -z "$discount" ]; then
        echo "UNKNOWN: $msg: Failed to get stats"
        exit 3
elif [ $discount -ge $3 ]; then
        printers=`echo "$disprint" | awk '{print $2}' ORS=' '`
        echo "CRITICAL: $msg: $discount Disabled Printers: $printers"
        exit 2
elif [ $discount -ge $2 ]; then
        printers=`echo "$disprint" | awk '{print $2}' ORS=' '`
        echo "WARNING: $msg: $discount Disabled Printer(s): $printers"
        exit 1
else
        echo "UNKNOWN: $msg: Failed to get stats"
        exit 3
fi
