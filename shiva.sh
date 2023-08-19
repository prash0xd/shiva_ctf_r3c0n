#!/bin/bash

#####Colors#######

RESET="\e[0m"
GRAY="\e[1;30m"
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
PURPLE="\e[1;35m"
CYAN="\e[1;36m"
WHITE="\e[1;37m"


##################

banner(){
echo -e "${RED} ____  _   _ _____     ___   ${RESET}" 
echo -e "${RED}/ ___|| | | |_ _\ \   / / \  ${RESET}"
echo -e "${RED}\___ \| |_| || | \ \ / / _ \ ${RESET}" 
echo -e "${RED} ___) |  _  || |  \ V / ___ \ ${RESET}" 
echo -e "${RED}|____/|_| |_|___|  \_/_/   \_\ ${RESET}"
echo -e "${GREEN}         Created by: prash0xd ${RESET}"

}

divider(){
       echo
       echo -e "${PURPLE}================================================================${RESET}"
       echo
}

help(){
      clear
      banner
      echo
      echo -e "USAGE:$0 [DOMAIN...] [OPTIONS...]"
      echo -e "\t-h , --help \t\t Help Menu"
      echo -e "\t-n , --nmap \t\t NMAP Scan"
      echo -e "\t-d , --dirsearch \t Directory Enumeration with 'dirsearch'"
      echo -e "\t-f , --fuff \t\t Directory Enumeration with 'FUFF'"
      echo -e "\t-ws , --wpscan \t\t Wordpress Website Scan"
      echo -e "\t-nk , --nikto \t\t NIKTO Scan"
      echo 
}


############################################VARIABLES#################################################

DOMAIN=$1

if [ $# -eq 0 ]  || [ $# -eq 1 ] 
then 
      help
      exit 1
fi



if ! [ -d "$DOMAIN" ]
then 
     mkdir $DOMAIN
     cd $DOMAIN
     
else 
    echo -e "${RED} Directory already exists...EXITING....${RESET}"
    exit 4
fi


##########################################SCRIPT##################################################

banner
divider 

#############################################CASE################################################

while  [ $# -gt 0 ]
do
     case "$2" in
          "-h" | "--help")
           help
           shift 
           ;; 

           "-n" | "--nmap")
           echo -e "${BLUE}[-]Starting NMAP scan be patient...${RESET}"
           nmap -sC -sV -A -p- --min-rate 1000  $DOMAIN -v  >>  nmap_results.txt
           echo -e "${GREEN}[+]NMAP SCAN Completed...${RESET}"
           divider
           shift
           ;;


          "-d" | "--dirsearch")

           echo -e "${BLUE}[-]Starting directory enumeration with dirsearch...${RESET}"
           dirsearch -u http://$DOMAIN  -x 400-410,500-510  >> dirsearch_results.txt
           echo -e "${GREEN}[+]Dirsearch Enum Completed...${RESET}"
           divider 
           shift
           ;;


          "-f" |  "--fuff")
           echo -e "${BLUE}[-]Starting directory enumeration with FUFF...${RESET}"
           ffuf -u http://$DOMAIN/FUZZ -w /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt  >> ffuf_results.txt
           echo -e "${GREEN}[+]FFUF Enum Completed...${RESET}"
	   divider 
           shift 
           ;;
          

          "-ws" | "--wpscan")
           echo -e "${BLUE}[-]Starting Wordpress Website scan be patient...${RESET}"
           wpscan --url http://$DOMAIN >> wpscan_results.txt
           echo -e "${GREEN}[+]Wordpress Website SCan Completed...${RESET}"            
           divider 
           shift
           ;;

          "-nk"  | "--nikto")
           echo -e "${BLUE}[-]Starting NIKTO scan be patient...${RESET}"
           nikto -h http://$DOMAIN  >> nikto_results.txt
           echo -e "${GREEN}[+]NIKTO scan  Completed...${RESET}"
           divider
           shift
           ;;
         
           "*" )
               help
           ;;
esac
done

divider  
echo -e "$BLUE} RECON COMPLETED... ${RESET}"
divider
