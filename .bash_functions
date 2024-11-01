#!/bin/bash

function psfind {
	if [[ -z $1 ]]; then
		printf "${RED}You did not provide a service to find.${NC}\n"
		printf "Syntax: ${GRN}psfind vpn${NC}\n\n"
	else
		ps aux | grep -iv grep | grep $1
	fi
}

function vpnkill {
	kill $(ps -aux | grep -v grep | grep -i "openvpn" | awk '{print $2}')
}

function vpnstart {
	if [[ $(id -u) -ne 0 ]]; then
		printf "${RED}vpnstart must be run as root\n"
		printf "Please try again using "sudo vpnstart"${NC}\n"
		exit 1
	elif [[ $# -eq 0 ]]; then
		printf "${RED}No arguments supplied. Please provide the path to the configuration\n${NC}"
		return 1
	else
		printf "${GRN}Starting openvpn...\n${NC}"
		openvpn $1 &
		return 0
	fi
}

function vpnstatus {
	echo ' '
	printf "${GRN}Service status:\n${NC}"
	systemctl is-active openvpn
	echo ' '
	printf "${GRN}Process information:\n${NC}"
	ps -aux | grep -v grep | grep -i "openvpn"
	echo ' '
	printf "${GRN}IP information:\n${NC}"
	ip a | grep tun0
	echo ' '
}

function scan {
	if [[ -z $@ ]]; then
		printf "${RED}You did not provide an IP.${NC}\n"
		return 1
	fi
	printf "\n${GRN}Starting NMAP scan on $1.  This may take a while...${NC}\n\n"
	ports=$(nmap -p- $2 --min-rate=1000 -T4 $1 | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
	nmap -p$ports -sC -sV 10.10.10.178
}

function ipsweep {
	
	if [[ -z $1 ]]; then
		printf "${RED}You did not provide a subnet.${NC}\n"
		printf "Syntax: 192.168.1 \n"
		return 1
	fi
	if test -f ./results.txt; then 
		rm -f ./results.txt
	fi
	printf "Searching from $1.1 through $1.254...\n"

	for ip in {1..254}; do 
		printf "\nWorking on 192.168.1.$ip\n"
		(ping -c 1 192.168.1.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" & ) >> results.txt
	done

	for job in `jobs -p`
	do 
		echo $job
		wait $job || let "FAIL+=1"
	done

	wait < <(jobs -p)
}

function backup_file() {
	if [ -f $1 ]
	then
		BACK="/tmp/$(basename ${1}).$(date +%F).$$"
		echo "Backing up $1 to ${BACK}"
		cp $1 $BACK
	fi
	if [ $? -eq 0 ]
	then
		echo "Backup succeeded!"
	fi
}

perms() {
	# This function will show the current path (or provided path)'s permissions all the way up to /
	
	## Create help file for syntax usage
	 [[ $1 == "-h" ]] && printf "Syntax:\n\t perms\n\t perms /var/log/messages\n" && return 0
	 
	## If a path is provided, use that path. If not, use current directory
	 [[ -z $1 ]] && local len2=$PWD && local len1=${PWD//[!\/]}
	 [[ ! -z $1 ]] && local len2="$(echo $1 | sed 's/\/$//')" && local len1=${len2//[!\/]}
	 
	## Set the len var equal to the number of slashs, aka, the number of directories in the path
	 local len=${#len1}
	 
	## Create the array for the results
	  local arr="Permissions\tUser\tGroup\tDirectory\n"
	 local arr+="-----------\t----\t-----\t---------\n"
	 
	## The root dir will always be first, therefore, it's not included in the 'for loop' and added manually
	 local tmp=$(ls -lhd --full-time / | cut -d" " -f1,3,4,9)
	 local arr+="$tmp\n"
	 
	## Loop through all the directories and save their permissions to the array
	 for (( i=2; i<=$(($len +1)); i++ ))
	   do
	     # Some magic to find each individual directory in the path, building them into the variable with each iteration
		  local base=$base/`echo $len2 | cut -d"/" -f$i`
		 # Add the result to the array
		  local tmp=$(ls -lhd --fulltime $base | cut -d" " -f1,3,4,9)
		  local arr+="$tmp\n"
	  done
	  
	## Finally, echo out the results to the console and format them to column format
	 echo ""
	 echo -e "${arr}" | column -t && return 0
	 
}

tsing() {
	
	# Script for common troubleshooting
	outfile=/tmp/.tsing.$(date +%F).$(date +%N)
	printf "\n\nResults saved to $outfile"
	
	# Show who's logged into the system
	echo "Who's logged on right now:"
	w | tee -a $outfile
	echo ""
	
	# Run which on the command provided
	[[ ! -z $1 ]] && printf "\nLocation of $1:\n\n" && which $1 | tee -a $outfile
	
	# Save the location of the command to a var and check the perms down to that directory 
	[[ ! -z $1 ]] && location=$(which $1)
	[[ ! -z $1 ]] && perms $location | tee -a $outfile
	[[ -z $1 ]] && perms | tee -a $outfile
	
	# Show the uname information
	printf "\n\nUname information:\n"
}
