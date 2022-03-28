#!/bin/sh
# 2019-05-28 https://roddie.digital
# Check SystemStatus items from Sophos SNMP

# Usage: check_snmp_sophos -H <hostname|hostaddress> -C <community> -O <oid>

# SystemStatus ::= INTEGER { unknown(0), disabled(1), ok(2), warn(3), error(4) }

# Check the arguments
while [ $# -gt 0 ]
do
  case $1 in
    -H)
      HOST=$2
      shift 2
    ;;
    -C)
      CMNTY=$2
      shift 2
    ;;
    -O)
      OID=$2
      shift 2
    ;;
    -h|--help)
      echo 'Checks Sophos-specifc SNMP OIDs translating results for Nagios.'
      echo 'Sophos uses unknown(0), disabled(1), ok(2), warn(3), error(4) whereas Nagios'
      echo 'uses ok(0), warning(1), critical(2), unknown(3).'
      echo ''
      echo 'Usage: check_snmp_sophos -H <hostname|hostaddress> -O <oid>'
      echo ''
      echo 'It requires the standard check_snmp Nagios plugin and the SOPHOS.txt MIB file'
      echo '(which can be downloaded from the SNMP settings menu of your Sophos appliance).'
      echo ''
      echo 'Assuming your path and filename are the same, you can run the following command'
      echo 'to see a list of all the different types of checks that can be peformed:'
      echo ''
      echo '$ snmptranslate -m /usr/share/snmp/mibs/SOPHOS.txt -Tp'
      echo ''
      echo 'This script can queury any items from that output where the Textual Convention'
      echo 'is SystemStatus. For checks that are Integer32 you can use the standard'
      echo 'check_snmp Nagios plugins and set your thresholds as usual.'
      exit
    ;;
  esac
done

# If no community specified default to public
if [ -z $CMNTY ]
then
  CMNTY='public'
fi

# Build the command
CHK=$(/usr/lib64/nagios/plugins/check_snmp -H $HOST -C $CMNTY -o $OID)

case $CHK in
        *0*)
                OUTPUT="UNKNOWN: Unable to determine the system status of $OID"
                EXIT=3
                SOPHOS=0
        ;;
        *1*)
                OUTPUT="WARNING: $OID is disabled"
                EXIT=1
                SOPHOS=1
        ;;
        *2*)
                OUTPUT="OK: $OID system status is OK"
                EXIT=0
                SOPHOS=2
        ;;
        *3*)
                OUTPUT="WARNING: $OID system status is warn"
                EXIT=1
                SOPHOS=3
        ;;
        *4*)
                OUTPUT="CRITICAL: $OID system status is error"
                EXIT=2
                SOPHOS=4
        ;;
        *)
                OUTPUT="UNKNOWN: Unable to determine the system status of $OID"
                EXIT=3
                SOPHOS=0
        ;;
esac

echo "$OUTPUT | $OID=$SOPHOS"
exit $EXIT
