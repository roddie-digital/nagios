#!/bin/bash
# 2019-02-05 https://roddie.digital
# Use EnsLib.TCP.StatusService to check config items


#while [ $# -gt 0 ]; do
#    case $1 in
#       -H)  HOST=$2
#            echo $HOST;shift 2
#       ;;
#       -p)  PORT=$2
#            echo $PORT;shift 2
#       ;;
#       -c)  CONF=$2
#            echo $CONF;shift 2
#       ;;
#       *)   echo "$# arguments detected - exiting..."
#            shift 1
#    esac
#done

HOST=$1
PORT=$2
shift 2
CONFS=$@

for CONF in $@
do

PROD=$(echo "production" | nc $HOST $PORT)
CHKCMD=$(echo "configitemstatus $CONF" | nc $HOST $PORT)

if [ ! -z $PROD ]
then
    case $CHKCMD in
        *"Connection refused"*)
            OUTPUTS+="UNKNOWN: Connection to $PORT refused - confirm the production is running and the business service EnsLib.TCP.StatusService is enabled"
            EXITS+=3
        ;;
        *"not found"*)
            OUTPUTS+="UNKNOWN: $CONF either disabled or doesn't exist in $PROD"
            EXITS+=3
        ;;
        *Error*)
            OUTPUTS+="CRITICAL: $CONF in $PROD error state"
            EXITS+=2
        ;;
        *running*)
            OUTPUTS+="OK: $CONF in $PROD is running"
            EXITS+=0
        ;;
        *dequeuing*)
            OUTPUTS+="OK: $CONF in $PROD is dequeuing"
            EXITS+=0
        ;;
        *)
            OUTPUTS+="UNKNOWN: $CONF is down or unknown"
            EXITS+=3
        ;;
    esac
else
    OUTPUT="UNKNOWN: Unable to establish connection to $PORT - confirm the production is running and the business service EnsLib.TCP.StatusService is enabled"
    EXIT=3
    echo $OUTPUT
    exit $EXIT
fi

done

for OUTPUT in "$OUTPUTS"
do
   echo "$OUTPUT"
done


echo $OUTPUT
exit $EXIT
