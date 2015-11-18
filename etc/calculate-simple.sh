#!/bin/bash
#this script is simple program that calculates +,-,* math operations

function selector {

	read -p "choose (1-3): " select
	case $select in
	1) plus ;;
	2) sub ;;
	3) times ;;
	*) echo error
		selector
		;;
	esac
}

function plus {
	echo input two number to add	
	read -p "first #" num1
	read -p "second #" num2
	num=$((num1+num2))
	echo $num1 + $num2 = $num
	 }
function sub {
	echo input two to subtract them from each other
	read -p "first #" num1
	read -p "second #" num2
	num=$((num1-num2))
	echo $num1 - $num2 = $num
}
function times {
	echo input two to time them
	read -p "first #" num1
	read -p "second #" num2
	num=$((num1*num2))
	echo $num1 '*' $num2 = $num
}
#Begin Here
echo "math program will begin"
echo "1) pick 1"
echo "2) pick 2"
echo "3) pick 3"
selector














