#!/bin/sh
# 2020-10-27 https://roddie.digital
# Check PAC scripts are in sync

ENVIRON=$1
PACFILE=$2


if [[ $ENVIRON == 'live' ]]
then
    PAC1=$(wget -qO- https://live-server-01.domain.com/$PACFILE)
    PAC2=$(wget -qO- https://live-server-02.domain.com/$PACFILE)
elif [[ $ENVIRON == 'test' ]]
then
    PAC1=$(wget -qO- https://test-server-01.domain.com/pactest/$PACFILE)
    PAC2=$(wget -qO- https://test-server-02.domain.com/pactest/$PACFILE)
else
    echo "PAC UNKNOWN: Unable to determine environment"
    exit 3
fi

if [[ "$PAC1" == "$PAC2" ]]
then
    OUTPUT="PAC OK: $PACFILE same on both $ENVIRON nodes"
    EXIT=0
elif [[ "$PAC1" != "$PAC2" ]]
then
    OUTPUT="PAC CRITICAL: Mismatch in $PACFILE on $ENVIRON"
    EXIT=2
else
    OUTPUT="PAC UNKNOWN: Unable to compare $PACFILE on $ENVIRON"
    EXIT=3
fi

echo $OUTPUT
exit $EXIT
