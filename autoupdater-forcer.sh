#!/bin/sh
# call this script with an ipv6 or hostname of the router
if [ "$1" = "" ]; then
        echo call this script with an ipv6 or hostname of the router:
        echo $0 '[IPv6]'
        exit
fi
ssh root@$1 <<'ENDSSH'
#!/bin/sh
echo -n "### hostname :  "
cat /proc/sys/kernel/hostname
echo -n "### firmware :  "
cat /lib/gluon/release
echo -n "### hardware :  "
cat /tmp/sysinfo/model
echo "Das Client WLAN ausschalten..."
uci set wireless.client_radio0.disabled=1
uci commit
echo "restarting wifi to kick all clients and wait 20 seconds..."
wifi
sleep 20
uci set autoupdater.settings.branch='stable'
uci set autoupdater.stable.good_signatures='1'
uci commit
autoupdater -f
ENDSSH
