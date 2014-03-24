#!/bin/sh

mac_cmd_1=$MAC_CMD
#mac_cmd_2=$MAC_CMD_2

if [ "$1" != "" ];then
   mac_cmd_1=$1
fi

#	if [ "$2" != "" ];then
#	   mac_cmd_2=$2
#	fi

echo iwpriv ath0 maccmd $mac_cmd_1
iwpriv ath0 maccmd $mac_cmd_1
#echo now mac_cmd_1 is:$mac_cmd_1

#	echo iwpriv ath1 maccmd $mac_cmd_2
#	iwpriv ath1 maccmd $mac_cmd_2
#echo now mac_cmd_2 is:$mac_cmd_2

cat /etc/acl.conf |
while read row;do
  #echo $row
  echo iwpriv ath0 addmac $row
  iwpriv ath0 addmac $row
done

#	cat /etc/acl_2.conf |
#	while read row;do
#	  #echo $row
#	  echo iwpriv ath1 addmac $row
#	  iwpriv ath1 addmac $row
#	done


#filename="/etc/acl.conf"
#while read line
#do
#  echo "$line"
#done < $filename
#
