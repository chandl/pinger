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
	sudo ping -a -c 10 $name
	;;
	3)
	ping3
	;;
	4)
	ping4
	sudo whois $name | grep -A 4 'Registrant'
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
	function ping4
	{
	echo ping 4 function 
	}
#Begin here 

clear
echo "----Ping is about to begin----"
echo "Ping 1: ping ip/domain silently"
echo "Ping 2: ping ip/domain louadly"
echo "Ping 3: ping ip/domain securily (not avaliable yet)"
echo "Ping 4: find out about $name"
selector 

