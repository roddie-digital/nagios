#!/bin/bash
# 2018-04-03 https://roddie.digital
# Check CUPS queue via lpq

# This will attempt to locate existing lpq command
LPQ=`which lpq`

while [ $# -gt 0 ]
do
        case $1 in
                -h)
                        HOST=$2
                        shift 2
                ;;
                -P)
                        PRINTER=$2
                        shift 2
                ;;
                *)
                        echo "The arguments to use are"
                        echo "-h: The host of the CUPS server"
                        echo "-P: The CUPS printer name"
                        shift 1
                ;;
        esac
done

#RESULT=`lpq -h $HOST -P $PRINTER`

RESULT=$((lpq -h $HOST -P $PRINTER) 2>&1)

case $RESULT in
        *"Unknown destination"*)
                OUTPUT="CRITICAL - $PRINTER is unknown to $HOST!"
                EXIT=2
        ;;
        *"not ready"*)
                OUTPUT="WARNING - $PRINTER is not ready on $HOST"
                EXIT=1
        ;;
        *"is ready"*)
                OUTPUT="OK - $PRINTER is ready on $HOST"
                EXIT=0
        ;;
        *)
                OUTPUT="CRITICAL - Unknown error occurred while checking $PRINTER on $HOST"
                EXIT=2
        ;;
esac

echo $OUTPUT
exit $EXIT
