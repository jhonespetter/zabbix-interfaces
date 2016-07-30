#!/bin/bash
# https://vpsboard.com/topic/2491-zabbix-series-4-low-level-discovery/


#UserParameter=ips.discovery[*],/etc/zabbix/temp-int/lld-ipaddr.sh discover
#UserParameter=ip[*],/etc/zabbix/temp-int/lld-ipaddr.sh $1

case "$1" in
        discover)
                echo "{"
                echo "\"data\":["
                        #ip addr | grep "inet " | \
                        ifconfig | grep "inet " | \
                        awk '{ print $2 }' | \
                        awk -F\. '{print ($4)+($3*256)+($2*256*256)+($1*256*256*256)}' | \
                        awk '{ print int($1 / 16777216) "." int($1 % 16777216 / 65536) "." int($1 % 65536 / 256) "." int($1 % 256) }' | \
                        awk '{ print "{\"{#SIP}\":\""$0"\"}," }' | \
                        head -c -2
                echo "]"
                echo "}"
                exit 1;
        ;;
        *)
                check=$1
                if [ "$check" = "" ]; then
                        echo "Nenhum ip especificado..."
                        exit 1
                fi
#               /bin/ping $1 -c 1 -w 1 -q | grep rtt | wc -l
                echo $1
esac