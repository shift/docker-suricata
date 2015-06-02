#!/usr/bin/env bash

if [ "$1" == "update" ]
then
  /blacklists.sh
  exec /usr/sbin/oinkmaster -o /etc/suricata/rules
elif [ "$1" == "build-info" ]
then
  exec /usr/bin/suricata --build-info
elif [ "$1" == "shell" ]
then
  exec /bin/bash
else
  /usr/sbin/cron
  /sbin/ethtool -K $DEVICE tx off
  exec /usr/bin/suricata -c /etc/suricata/suricata.yaml -i $DEVICE
fi
