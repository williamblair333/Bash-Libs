#!/bin/sh

sleep_time=1
net_status=0
gateway="192.168.1.1"
ip_status=$(ip address s <nic_name> |grep 192)

while [ "$net_status" -le 0 ]
do
    if ping -q -c 1 -W 1 "$gateway" >/dev/null; then
        net_status=1
        echo Network appears to be online, running scripts.
        <do stuff here>
    else
        echo Network appears offline, sleeping for "$sleep_time" second\(s\).
        sleep "$sleep_time"
    fi
done
