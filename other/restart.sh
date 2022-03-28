#!/bin/bash
# 2019-01-09 https://roddie.digital
# Check Nagios configuration is valid before restarting it
# and append summary to config changelog

/usr/sbin/nagios -v /etc/nagios/nagios.cfg

warnings=$(/usr/sbin/nagios -v /etc/nagios/nagios.cfg | grep -o "Warnings.*")
warnings=${warnings#*:}
warnings=$(echo $warnings | xargs)

errors=$(/usr/sbin/nagios -v /etc/nagios/nagios.cfg | grep -o "Errors.*")
errors=${errors#*:}
errors=$(echo $errors | xargs)

if [ "$errors" = "0" ]
then
    #echo "No errors so let's check for warnings..."
    if [ "$warnings" = "0" ]
    then
        #echo "No warnings so let's restart it..."
        read -p "Add summary of change: " updcom
        upddts=$(date "+%Y-%m-%d %T:")
        updlog="$upddts $updcom"
        echo $updlog >> change.log && tac change.log > /usr/share/nagios/html/changelog.txt
        systemctl restart nagios && systemctl restart nrpe
        systemctl status nagios
    else
        #echo "Some warnings, so check the output and make a decision"
        echo "Warnings found, either add summary to continue or Control-C to quit"
        read -p "Add summary of change: " updcom
        upddts=$(date "+%Y-%m-%d %T:")
        updlog="$upddts $updcom"
        echo $updlog >> change.log && tac change.log > /usr/share/nagios/html/changelog.txt
        systemctl restart nagios && systemctl restart nrpe
        systemctl status nagios
    fi
else
    #echo "Some errors; quitting..."
    exit
fi
