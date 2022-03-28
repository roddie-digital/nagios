# Nagios

Collection of useful plugins and tidbits for Nagios, primarily monitoring InterSystems Cache on RHEL 7. My instance is installed from the RHEL repos so the main files are in `/etc/nagios', the plugins are in `/usr/lib64/nagios/plugins` and the webserver is in `/usr/share/local/html` - if you've built from source you might have to update the paths.

## `check_snmp_sophos` Translate Sophos SNMP codes
Checks Sophos-specifc SNMP OIDs translating results for Nagios. Sophos uses unknown(0), disabled(1), ok(2), warn(3), error(4) whereas Nagios uses ok(0), warning(1), critical(2), unknown(3).'

Usage: `check_snmp_sophos -H <hostname|hostaddress> -O <oid>`

It requires the standard `check_snmp` Nagios plugin and the `SOPHOS.txt` MIB file (which can be downloaded from the SNMP settings menu of your Sophos appliance).

Assuming your path and filename are the same, you can run the following command to see a list of all the different types of checks that can be peformed:

`$ snmptranslate -m /usr/share/snmp/mibs/SOPHOS.txt -Tp`

This script can queury any items from that output where the Textual Convention is 'SystemStatus'. For checks that are 'Integer32' you can use the standard `check_snmp` Nagios plugins and set your thresholds as usual.
