#Version 1.10, Updated Nov 22, 2015

#Made by Chandler Severson and Abdullah Alshubaili
#CS 336, Networks, Term Project, Southern Oregon University
#Pinger - A UNIX based script that expands on the built-in ping program. 
#         Provides a user friendly layout and useful statistical information about pings.

#!/bin/bash

clear
#this is to make it more user friendly, this is skipped if user is already authenticated as sudoer
echo "Pinger requires root/sudo access to work properly."
echo "Please Enter your Administrative (sudo) password: "
sudo echo "Success!" 


#creating folders for logs/files, -p flag ignores errors
mkdir -p ./whoisLogs
mkdir -p ./stats


#goAgain(), prompts user asking if they want to use the program again, calls mainMenu if they do
goAgain()
{
	while true; do
		echo -e "\n"
		read -p "Go again? (y/n)" yn
		case $yn in
			y)
				mainMenu
				break;;
			n)
				endProgram
				break;;
			*)
				echo "Invalid selection, try again! ";;
		esac
	done
}

#Stops the script's execution, start the script using "bash pinger.sh" to avoid your entire terminal being exited
endProgram()
{
	echo "Goodbye! Thanks for using Pinger."
	exit 1
}

#displays information about the program, gets input from user for the ip/domain of what they want to use
mainMenu()
{
	clear
	echo "========================================"
	echo "|--------------------------------------|"
	echo "|-----------------Pinger---------------|"
	echo "|---------By Chandler and Abdul--------|"
	echo "|-------Southern Oregon University-----|"
	echo "|-----------Networks, CS 336-----------|"
	echo "|------------Fall Term 2015------------|"
	echo "|--------------------------------------|"
	echo -e "========================================\n\n"
	
	read -p "Please Enter an IP Address or Domain Name: " name
	selMenu
}

#Prints out the menu for selections and calls the selector method
selMenu()
{
	clear
	echo "========== $name =========="
	echo "1: Ping $name"
	echo "2: Ping and make statistic file for $name"
	echo "3: Get WHOIS info about $name"
	echo "4: Go Back "
	echo "5: Quit Program"
	echo "========================================"
	selector
}

#Gets the user's selection, protecting against invalid input
selector() 
{
while true; do
	read -p "Make your Selection: " sel
	
	case $sel in 
	
	1)
		clear
		normalPing
		break;;
	2)
		clear
		statsPing
		break
		;;
	3)
		clear
		whoisFunc
		break
		;;
	4)
		mainMenu
		break
		;;
	5)
		endProgram
		break;;
	*)
		echo Invalid selection, Try Again! ;;
	esac
done
}


normalPing()
{
	sudo ping -ac 5 $name
	goAgain
}
statsPing()
{	
	echo "Pinging $name ..."
	sudo ping -fc 30 $name > ./stats/$name.out
	
	#offline=`grep -c '0 packets received' ./stats/$name.out`
	
	if [ `grep -c '0 packets received' ./stats/$name.out` -eq 1 ]
	then
		echo -e "\n\n$name is offline or has blocked pings."
		sudo rm ./stats/$name.out
	else
		lineA=`grep 'transmitted' ./stats/$name.out`
		lineB=`grep 'round-trip' ./stats/$name.out`
		
		echo -e "==========\nReport for $name:\n" > ./stats/$name.txt
		
		#########ADD IN packets info (transmitted/received/loss)
		
		grep 'round-trip' ./stats/$name.out| awk '{print $4}' | awk -F '/' '{print "Round-Trip-Time (RTT) info:\n\tMinimum: "$1 " miliseconds\n\tMaximum: " $3 " miliseconds\n\tAverage: " $2 " miliseconds\n\tStandard Deviation: " $4 " miliseconds"}' >> ./stats/$name.txt
	fi
	
	goAgain
}

whoisFunc()
{
	sudo whois $name > ./whoisLogs/$name.out
	
	#Seeing if the whois returns nothing (e.g. google.com doesn't return anything when we do this)
	lineCount=`grep -c -E -A 8 'Registrant|Administrative' ./whoisLogs/$name.out`
	if [ $lineCount -eq 0 ] 
	then
		echo -e "\n\nNo WHOIS information found for $name"
		sudo rm ./whoisLogs/$name.out
	
	else
		grep -E -A 8 'Registrant|Administrative' ./whoisLogs/$name.out > ./whoisLogs/$name.txt
		sudo rm ./whoisLogs/$name.out
		more ./whoisLogs/$name.txt
		echo -e "\n\nWHOIS information for $name saved in ./whoisLogs/$name.txt"
		

	fi
	
	goAgain
}


#This is where the first mainMenu call is.
mainMenu 








#This is the format of the statistic report file.

#===============
#   Report:
#Packets Transmitted: X
#Packets Received: X
#Packet Loss: X%
#
#Round-Trip-Time (RTT) info:
#	Minimum: X.xxx miliseconds
#	Maximum: XX.xxx miliseconds
#	
#	Average: XX.xxx miliseconds
#
#	Standard Deviation: XX.xxx miliseconds
#	95% of Ping RTTs to [site] will be between: XX.xxx and XX.xxx miliseconds
#================

