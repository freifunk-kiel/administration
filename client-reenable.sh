#!/bin/sh
# call this script with an ipv6 or hostname of the router
if [ "$1" = "" ]; then
        echo call this script with an ipv6 or hostname of the router:
        echo $0 '[IPv6]'
        exit
fi
ssh root@$1 <<'ENDSSH'
uci set wireless.client_radio0.disabled=0
uci commit
wifi
ENDSSH
