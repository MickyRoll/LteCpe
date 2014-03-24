#!/bin/sh
#
# $Id: firewall.sh,v 1.1 2007-09-26 02:25:17 winfred Exp $
#
# usage: firewall.sh init|fini
#

IPPORT_FILTER_CHAIN="ipport_block"
MAC_FILTER_CHAIN="mac_block"
DMZ_CHAIN="DMZ"
PORT_FORWARD_CHAIN="port_forward"
MALICIOUS_INPUT_CHAIN="malicious_input_filter"
URL_FILTER_CHAIN="url_filter"

usage()
{
	echo "Usage:"
	echo "  $0 init|fini"
	exit 1
}

iptablesAllFilterClear()
{
	iptables -F -t filter 1>/dev/null 2>&1		
	
	iptables -D FORWARD -j $URL_FILTER_CHAIN 1>/dev/null 2>&1			
	iptables -F $URL_FILTER_CHAIN 1>/dev/null 2>&1

	iptables -D FORWARD -j $MAC_FILTER_CHAIN 1>/dev/null 2>&1			
	iptables -F $MAC_FILTER_CHAIN 1>/dev/null 2>&1

	iptables -D FORWARD -j $IPPORT_FILTER_CHAIN 1>/dev/null 2>&1	
	iptables -F $IPPORT_FILTER_CHAIN 1>/dev/null 2>&1							

									
	iptables -D INPUT -j $MALICIOUS_INPUT_CHAIN 1>/dev/null 2>&1			
	iptables -F $MALICIOUS_INPUT_CHAIN 1>/dev/null 2>&1	
	
	iptables -P INPUT ACCEPT			
	iptables -P OUTPUT ACCEPT			
	iptables -P FORWARD ACCEPT		
}

init()
{
	iptablesAllFilterClear

	iptables -t filter -N $URL_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -N $IPPORT_FILTER_CHAIN 1>/dev/null 2>&1						
	iptables -t filter -N $MAC_FILTER_CHAIN 1>/dev/null 2>&1		
	iptables -t filter -N $MALICIOUS_INPUT_CHAIN 1>/dev/null 2>&1				
			 
	iptables -t filter -A FORWARD  -j $URL_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A FORWARD  -j $MAC_FILTER_CHAIN 1>/dev/null 2>&1		 
	iptables -t filter -A FORWARD  -j $IPPORT_FILTER_CHAIN 1>/dev/null 2>&1 
	iptables -t filter -A INPUT -i eth0 -j $MALICIOUS_INPUT_CHAIN 1>/dev/null 2>&1 
	iptables -t filter -A INPUT -i eth2 -j $MALICIOUS_INPUT_CHAIN 1>/dev/null 2>&1    ###########

	#############################################################################################
	#iptables -A FORWARD -j ACCEPT -i eth1 -o eth0  -m state --state NEW 1>/dev/null 2>&1
	#iptables -A FORWARD -j ACCEPT -i eth1 -o eth2  -m state --state NEW 1>/dev/null 2>&1  ###########
	iptables -A FORWARD -m state --state ESTABLISHED,RELATED  -j ACCEPT 1>/dev/null 2>&1
	#############################################################################################


	#iptablesAllFilterRun();

	# init NAT(DMZ)
	# We use -I instead of -A here to prevent from default MASQUERADE NAT rule being in front of us.
	# So "port forward chain" has the highest priority in the system, and "DMZ chain" is the second.
	iptables -t nat -D PREROUTING -j $PORT_FORWARD_CHAIN 1>/dev/null 2>&1	
	iptables -t nat -F $PORT_FORWARD_CHAIN 1>/dev/null 2>&1								
	iptables -t nat -X $PORT_FORWARD_CHAIN 1>/dev/null 2>&1							

	iptables -t nat -N $PORT_FORWARD_CHAIN 1>/dev/null 2>&1										
	iptables -t nat -I PREROUTING 1 -j $PORT_FORWARD_CHAIN 1>/dev/null 2>&1		
	iptables -t nat -N $DMZ_CHAIN 1>/dev/null 2>&1														
	iptables -t nat -I PREROUTING 2 -j $DMZ_CHAIN 1>/dev/null 2>&1
	#iptables -t nat -I PREROUTING 3 -i eth2 -j $DMZ_CHAIN 1>/dev/null 2>&1	###########					

	#iptablesAllNATRun();
}


if [ "$1" = "" ]; then
	echo "$0: insufficient arguments"
	usage $0
elif [ "$1" = "init" ]; then
	init
else
	echo "$0: unknown argument: $1"
	usage $0
fi

