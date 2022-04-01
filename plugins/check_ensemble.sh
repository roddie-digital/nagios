#!/bin/bash
# 2019-02-05 https://roddie.digital
# Check status of business objects in InterSystems Ensemble
# Create EnsLib.TCP.StatusService service in your production first

CONF=$1
HOST=$2
PORT=$3

PROD=$(echo "namespace" | nc $HOST $PORT)
CHKCMD=$(echo "configitemstatus $CONF" | nc $HOST $PORT)

if [ ! -z $PROD ]
then
    case $CHKCMD in
        *Retry*)
            OUTPUT="CRITICAL: $CONF in $PROD showing as retrying - may be disconnected or queuing"
            EXIT=2
            STATUS="Retry"
        ;;
        *"Connection refused"*)
            OUTPUT="UNKNOWN: Connection to $PORT refused - confirm the production is running and the business service EnsLib.TCP.StatusService is enabled"
            EXIT=3
            STATUS="Connection refused"
        ;;
        *"not found"*)
            OUTPUT="UNKNOWN: $CONF either disabled or doesn't exist in $PROD"
            EXIT=3
            STATUS="not found"
        ;;
        *Error*)
            OUTPUT="CRITICAL: $CONF in $PROD error state"
            EXIT=2
            STATUS="Error"
        ;;
        *running*)
            OUTPUT="OK: $CONF in $PROD is running"
            EXIT=0
            STATUS="running"
        ;;
        *dequeuing*)
            OUTPUT="OK: $CONF in $PROD is dequeuing"
            EXIT=0
            STATUS="dequeuing"
        ;;
        *"enabled for external invocation"*)
            OUTPUT="OK: $CONF in $PROD is enabled for external invocation"
            EXIT=0
            STATUS="enabled for external invocation"
        ;;
        *)
            OUTPUT="UNKNOWN: $CONF is down or unknown"
            EXIT=3
            STATUS="Unknown"
        ;;
    esac
else
    OUTPUT="UNKNOWN: Unable to establish connection to $PORT - confirm the production is running and the business service EnsLib.TCP.StatusService is enabled"
    EXIT=3
    STATUS="Unknown (may be unable to connect)"
fi


echo "$OUTPUT | $STATUS"
exit $EXIT
