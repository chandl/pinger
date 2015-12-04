#Version 2.00, Updated Nov 23, 2015

#Made by Chandler Severson and Abdullah Alshubaili
#CS 336, Networks, Term Project, Southern Oregon University
#Pinger - A UNIX based script that expands on the built-in ping program. 
#         Provides a user friendly layout and useful statistical information about pings.

#!/bin/bash

########################################################
#VARIABLES
version=2.00
header="**********Pinger v$version**********\n"
name="127.0.0.1"
minPing=1
maxPing=100

#creating folders for logs/files, -p flag ignores errors
mkdir -p ./whoisLogs
mkdir -p ./stats
########################################################


#------------------------------------------------------#
#this is to make it more user friendly, this is skipped if user is already authenticated as sudoer
clear
echo "Pinger requires root/sudo access to work properly."
echo "Please Enter your Administrative (sudo) password: "
sudo echo "Success!" #sudo here makes user type password before starting
#------------------------------------------------------#


##################menu functions########################
########################################################
#displays information about the program, gets input from user for the ip/domain of what they want to use
mainMenu()
{
	clear
	creatorInfo
	read -p "Please Enter an IP Address or Domain Name: " name
	selMenu
}

#Prints out the menu for selections and calls the selector method
selMenu()
{
	clear
	echo -e $header
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
		echo "Invalid selection, Try Again!" ;;
	esac
done
}
########################################################
########################################################


################ping/whois functions####################
########################################################
#normally pings a location, asks for number of pings from the user
normalPing()
{
	#Getting User input for number of pings
	clear
	echo -e $header
	while true; do
		read -p "Enter the desired amount of pings ($minPing - $maxPing): " pingCount
		re='^[0-9]+$'
		if ! [[ $pingCount =~ $re ]] ; then
			echo "Input must be a number!" 
		elif [ $pingCount -gt $maxPing ] ; then
			echo "Input must be between $minPing and $maxPing"
		elif [ $pingCount -lt $minPing ] ; then
			echo "Input must be between $minPing and $maxPing"
		else break;
		fi
	done
	
	#Starting the Ping Process
	clear
	echo -e $header
	echo -e "Pinging $name $pingCount times.\n"
	sudo ping -ac $pingCount $name
	goAgain
}

#pings location and creates statistic file with information
statsPing()
{	
	echo -e $header
	echo "Pinging $name ..."
	sudo ping -fc 60 $name > ./stats/$name.out
	
	if [ `grep -c '100.0% packet loss' ./stats/$name.out` -eq 1 ] ; then
		echo -e "\n\n$name is offline or has blocked pings."
		sudo rm ./stats/$name.out
	else
		#if the file exists already, we don't want to add more header info. Just keep appending reports to the bottom
		if ! [ -a ./stats/$name.txt ] ; then
			creatorInfo > ./stats/$name.txt
		fi
		echo -e "\n==============================\nPing statistics report for $name\nReport generated at: `date`\n" >> ./stats/$name.txt
		#------------------------------------------------------# 
		#Packet Transmission section of report
		echo -e "\nPacket Transmission info: " >> ./stats/$name.txt
		grep 'transmitted' ./stats/$name.out | awk -F ", " '{print "\t"$1"\n\t"$2"\n\t"$3"\n"}' >> ./stats/$name.txt
		#------------------------------------------------------#
		#RTT Info section of report
		stddev=`grep 'min/avg/max' ./stats/$name.out| awk '{print $4}' | awk -F '/' '{print $4}'`
		avgping=`grep 'min/avg/max' ./stats/$name.out| awk '{print $4}' | awk -F '/' '{print $2}'`
		minTime=`echo $avgping - 2 \* $stddev | bc -l`
		maxTime=`echo $avgping + 2 \* $stddev | bc -l`
		grep 'min/avg/max' ./stats/$name.out| awk '{print $4}' | awk -F '/' '{print "Round-Trip-Time (RTT) info:\n\tMinimum: "$1 " milliseconds\n\tMaximum: " $3 " milliseconds\n\tAverage: " $2 " milliseconds\n\tStandard Deviation: " $4 " milliseconds"}' >> ./stats/$name.txt
		echo -e "\t95% of ping RTTs to $name will be between $minTime ms and $maxTime ms" >> ./stats/$name.txt
		#------------------------------------------------------#
		echo -e "==============================" >> ./stats/$name.txt
		sudo rm -r ./stats/$name.out
		more ./stats/$name.txt
		echo -e "\n\nPing statistics file for $name saved in ./stats/$name.txt"
	fi
	goAgain
}

#gets whois information for the entered domain, will not work for IPs entered
whoisFunc()
{
	echo -e $header
	sudo whois $name > ./whoisLogs/$name.out
	
	#Seeing if the whois returns nothing (e.g. google.com doesn't return anything when we do this)
	lineCount=`grep -c -E -A 8 'Registrant|Administrative' ./whoisLogs/$name.out`
	if [ $lineCount -eq 0 ] ; then
		echo -e "\n\nNo WHOIS information found for $name"
		sudo rm ./whoisLogs/$name.out
	else
		creatorInfo > ./whoisLogs/$name.txt
		echo -e "WHOIS information for $name\nReport generated at: `date`\n" >> ./whoisLogs/$name.txt
		grep -E -A 8 'Registrant|Administrative' ./whoisLogs/$name.out >> ./whoisLogs/$name.txt
		sudo rm ./whoisLogs/$name.out
		more ./whoisLogs/$name.txt
		echo -e "\n\nWHOIS information for $name saved in ./whoisLogs/$name.txt"
	fi
	
	goAgain
}
########################################################
########################################################


################Extra Functions#########################
########################################################
#goAgain(), prompts user asking if they want to use the program again, calls mainMenu if they do
goAgain()
{
	while true; do
		echo -e "\n"
		read -p "Would you like to go again? (y/n)" yn
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

#echos information of creators
creatorInfo()
{
	echo "========================================"
	echo "|--------------------------------------|"
	echo "|--------------Pinger v$version------------|"
	echo "|---------By Chandler and Abdul--------|"
	echo "|-------Southern Oregon University-----|"
	echo "|-----------Networks, CS 336-----------|"
	echo "|------------Fall Term 2015------------|"
	echo "|--------------------------------------|"
	echo -e "========================================\n"
}

#Stops the script's execution, start the script using "bash pinger.sh" to avoid your entire terminal being exited
endProgram()
{
	clear
	creatorInfo
	echo -e "Goodbye! Thanks for using Pinger.\n\n"
	exit 1
}
########################################################
########################################################

#Begin Execution Here: 
mainMenu 



#Copyright (c) 2015 Chandler Severson and Abdullah Alshubaili 


#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.