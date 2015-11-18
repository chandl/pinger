#!/bin/sh
#

function selector {
	read -p "Make a selection (1-3): " sel
	
	case $sel in
		1)
			ping1
		;;
		2)
			ping2
		;;
		3)
			ping3
		;;
		*)
			echo Invalid Selection, Try Again!
			selector
		;;
	esac
}

function ping1 {
	echo Ping 1 Function
}

function ping2 {
	echo Ping 2 Function
}

function ping3 {
	echo Ping 3 Function
}

#Begin Here
clear
echo "===============Ping Program==============="
echo "1) Ping Type 1"
echo "2) Ping Type 2" 
echo "3) Ping Type 3"
selector

read -p "Enter an IP address or Domain name to Continue: " name
echo "Trying to connect to: $name ..."

sudo ping -fc 30 $name > pingResults.ping

more pingResults.ping
rm pingResults.ping
