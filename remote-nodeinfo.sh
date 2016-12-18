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
#[ -f /etc/banner ] && cat /etc/banner
echo -n "### IP :  "
ifconfig |head|tail -n1
ip r s t all
echo    "### from ssh : "$SSH_CONNECTION
echo -n "### uptime :  "
uptime
echo -n "### pubkey :  "
/etc/init.d/fastd show_key mesh_vpn
echo -n "### firmware :  "
cat /lib/gluon/release
echo -n "### hardware :  "
cat /tmp/sysinfo/model
echo -n "### Radio-Networks acitve:"
iwinfo
echo -n "### connected to this node  :  "
batctl tl |grep W |wc -l
echo -n "### number of total clients :    "
batctl tg |grep W |wc -l
echo -n "### Mesh: MoL:$(uci show|grep mesh_lan.auto|cut -d= -f2)"
echo -n " MoW:$(uci show|grep mesh_wan.auto|cut -d= -f2)"
echo    " Fastd:$(uci show|grep fastd.mesh_vpn.enabled|cut -d= -f2)"
echo "### BatIFs:"
batctl if
echo "batctl gw :     " $(batctl gw)
echo "### BatGateways"
batctl gwl
echo -n "### Location: Geo?:$(uci show|grep .share_location=|cut -d= -f2)"
echo -n " lon:$(uci show|grep .longitude=|cut -d= -f2)"
echo -n " lat:$(uci show|grep .latitude=|cut -d= -f2)"
echo    " Contact:$(uci show|grep contact|cut -d= -f2)"
echo Mesh neighbours:
DEV_LIST="$(iw dev|grep Interface|grep -e 'mesh' -e 'ibss'| awk '{ print $2 }')"
for DEV in $DEV_LIST
do
iw dev $DEV station dump | grep -e "^Station "
done
ENDSSH
