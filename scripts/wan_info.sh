#!/bin/sh

cfg -a WAN_IPADDR=$ip
cfg -a WAN_NETMASK=$subnet
cfg -a DHCPC_INTERFACE=$interface
#cfg -a CONNECT_STATUS=connected


num=0
for i in $dns ; do
        if [ "$num" = "0" ];then
                cfg -a PRIDNS=$i
        fi
        if [ "$num" = "1" ];then
                cfg -a SECDNS=$i
        fi
	num=`expr $num + 1`
	echo "dsn num := $num" 
done

for j in $router ; do

	cfg -a IPGW=$j
       
done
