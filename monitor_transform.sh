#!/bin/bash
# Expected application path: /usr/bin/gnome-monitor-config
# Use Case: Crontab Example
# * * * * * /opt/scripts/monitor_transform.sh left

export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus

transform_options=(normal left inverted right)
if ! [[ " ${transform_options[@]} " =~ " $1 " ]]; then
    echo "Error: $1 is not a valid transform option. Valid options are: ${transform_options[*]}"
    exit 1
fi

monitor_info=$(/usr/bin/gnome-monitor-config list)
enabled_monitor=$(echo "$monitor_info" | grep "ON" | awk -F'[][]' '{print $2}')
current_transform=$(echo "$monitor_info" | grep "Logical monitor" | awk -F'transform =' '{print $2}')
if [ $current_transform != "$1" ]; then
    /usr/bin/gnome-monitor-config set -LpM $enabled_monitor -t $1
fi
