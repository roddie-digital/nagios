#!/bin/bash
# 2019-01-09 https://roddie.digital
# Add manual change to config changelog

changelog='/etc/nagios/change.log'

read -p "Add summary of change: " updcom
        upddts=$(date "+%Y-%m-%d %T:")
        updlog="$upddts $updcom"
        echo $updlog >> $changelog && tac $changelog > /usr/share/nagios/html/changelog.txt
