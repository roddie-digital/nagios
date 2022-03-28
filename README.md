# Nagios

Collection of useful plugins and tidbits for Nagios, primarily monitoring InterSystems Cache on RHEL 7. My instance is installed from the RHEL repos so the main files are in `/etc/nagios`, the plugins are in `/usr/lib64/nagios/plugins` and the webserver is in `/usr/share/local/html` - if you've built from source you might have to update the paths.

## `check_snmp_sophos` Translate Sophos SNMP codes
Checks Sophos-specifc SNMP OIDs translating results for Nagios. Sophos uses unknown(0), disabled(1), ok(2), warn(3), error(4) whereas Nagios uses ok(0), warning(1), critical(2), unknown(3).'

Usage: `check_snmp_sophos -H <hostname|hostaddress> -O <oid>`

It requires the standard `check_snmp` Nagios plugin and the `SOPHOS.txt` MIB file (which can be downloaded from the SNMP settings menu of your Sophos appliance).

Assuming your path and filename are the same, you can run the following command to see a list of all the different types of checks that can be peformed:

`$ snmptranslate -m /usr/share/snmp/mibs/SOPHOS.txt -Tp`

This script can queury any items from that output where the Textual Convention is 'SystemStatus'. For checks that are 'Integer32' you can use the standard `check_snmp` Nagios plugins and set your thresholds as usual.

## Adding a config changelog
*(According to the Nagios Core 4.x Version History, as of 4.4.6 the configuration will be verified before reloading when using `systemd`.)*

A useful feature I added to my Nagios Core installation is a changelog to keep track of changes to configuration files which is also available through the web interface. I use the `restart.sh` script which first checks the config is valid - if there are any errors it will quit but if it's successful (or only warnings), it will prompt for a summary of the changes and then restart `nagios` and `nrpe` (you'll need to check the paths are correct for your installation).
  
In case I want to record any changes outwith the Nagios config files (eg the PHP files instead) then I use the `addchange.sh` script to add a change without checking or restarting Nagios.

For tidiness, I use the following cron job to add a blank line between months:

```shell
1 0 1 * *  echo '' >> /etc/nagios/change.log
```

Then in `/usr/share/nagios/html/side.php` you can add the following line so that the Changelog appears in the side bar and can be displayed in the main Nagios web frame:

```php
<li><a href="/nagios/changelog.txt" target="<?php echo $link_target;?>">Changelog</a></li>
```

You can obviously change date format for your own preference but this is how the script currently writes it:

```
2021-04-12 09:29:46: Some text about the change goes here
```
