#!/bin/sh

if [  -f /tmp/nzcpe_firmware*.bin ]; then	
	killall sequansd
	killall sqnConnectivityController
	killall cpecm

	rm /usr/bin/default.fw
	rm /usr/bin/sequansd*
	rm /usr/bin/sqnConnectivityController*
	rm /usr/bin/cpecm
	rm -rf /home/iptables/
	rm /bin/pppd
	rm /bin/nart.out
	#rm -rf /lib

	#cd /tmp/
	#tftp -r $1 -g $2

	rm -rf /var/nzcpe_firmware*
	cp /tmp/nzcpe_firmware* /var/
	/sbin/flash_eraseall /dev/mtd1
	reboot
fi
