#!/bin/bash

read -p "please enter a domain or ip address to ping: " name

function selector {

read -p "choose one of the following: " sel
	
	case $sel in 
	
	1)
	ping1
	sudo ping -fc 30 $name
	;;
	2)
	ping2
	sudo ping -a -c 5 $name
	;;
	3)
	ping3
	sudo whois $name | grep -E -A 8 'Registrant|Administrative'
	;;
	*)
	echo invalid selection 
	;;
	
	esac
	}
	function ping1 
	{
	echo ping 1 funciton 
	}
	function ping2 
	{
	echo ping 2 function
	}
	function ping3
	{
	echo ping 3 function 
	}
#Begin here 

clear
echo "----Ping is about to begin----"
echo "Ping 1: ping ip/domain silently"
echo "Ping 2: ping ip/domain louadly"
echo "Ping 3: find out about $name"
selector 

