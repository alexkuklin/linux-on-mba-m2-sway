#!/bin/bash
# Usage: wg1-routes.sh up|down <interface> <endpoint-host>
ACTION=$1
IFACE=$2
ENDPOINT_HOST=$3

ENDPOINT_IP=$(getent ahosts "$ENDPOINT_HOST" | awk 'NR==1 {print $1}')

if [ "$ACTION" = "up" ]; then
    GW=$(ip route show default | awk 'NR==1 {print $3}')
    DEV=$(ip route show default | awk 'NR==1 {print $5}')
    ip route add "$ENDPOINT_IP/32" via "$GW" dev "$DEV"
    ip route add default dev "$IFACE"
else
    ip route del default dev "$IFACE" 2>/dev/null
    ip route del "$ENDPOINT_IP/32" 2>/dev/null
fi
