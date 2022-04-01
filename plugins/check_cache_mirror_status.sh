#!/bin/sh
# 2018-11-29 https://roddie.digital
# Check Cache Mirror Status
# https://docs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=GHA_mirror_manage

#determine cache mirror status and store in variable
STATUS=$(ccontrol list | grep "Status" )
STATUS=${STATUS#*=}

case $STATUS in
        *Primary*)
                OUTPUT="Primary: Current primary."
                EXIT=0
        ;;
        *Backup*)
                OUTPUT="Backup: Connected to primary as backup."
                EXIT=0
        ;;
        *Connected*)
                OUTPUT="Connected: Connected to primary as async"
                EXIT=0
        ;;
        *Transition*)
                OUTPUT="Transition: In a transitional state that will soon change when initialization or another operation completes; this status prompts processes querying a member’s status to query again shortly. When there is no operating primary, a failover member can report this status for an extended period while it retrieves and applies journal files in the process of becoming primary; if there is another failover member that is primary, the status is Synchronizing instead."
                EXIT=1
        ;;
        *Synchronizing*)
                OUTPUT="Syncronizing: Starting up or reconnecting after being stopped or disconnected, retrieving and applying journal files in order to synchronize the database and journal state before becoming Backup or Connected."
                EXIT=1
        ;;
        *Waiting*)
                OUTPUT="Waiting: Unable to complete an action, such as becoming primary or connecting to primary; will retry indefinitely, but user intervention may be required. See console log for details."
                EXIT=1
        ;;
        *Stopped*)
                OUTPUT="Stopped: Mirroring on member stopped indefinitely by user and will not start automatically; see console log for details."
                EXIT=1
        ;;
        *Crashed*)
                OUTPUT="Crashed: Mirror no longer running due to unexpected confition; see console log for details."
                EXIT=2
        ;;
        *Error*)
                OUTPUT="Error: An unexpected error occurred while fetching the member's status."
                EXIT=3
        ;;
        *Initialized*)
                OUTPUT="Not Initialized: The member is not initialized (the mirror configuration is not yet loaded)."
                EXIT=3
        ;;
        *Down*)
                OUTPUT="Down: Displayed on other members for a member that is down or inaccessible."
                EXIT=2
        ;;
        *)
                OUTPUT="UNKNOWN: Nagios was unable to determine the Cache mirror status."
                EXIT=3
        ;;
esac

echo $OUTPUT
exit $EXIT
