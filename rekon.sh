#!/bin/bash
if [ ! -d "$1" ]; then
        mkdir -p targets/$1
fi

echo -e "\e[1;31m COLLECTING PARAMETERS :-P \e[0m"
python3 /root/Desktop/RECON/ParamSpider/paramspider.py -d $1 -o targets/$1/param.txt
echo -e "\e[1;31m *********************** \e[0m"
echo "Running waybackurls <3"
waybackurls $1 >> targets/$1/waybackurl.txt
echo -e "\e[1;31m WAYBACKURLS COLLECED :-P \e[0m"
echo -e "\e[1;31m *********************** \e[0m"
echo -e "\e[1;31m COLLECTING SUBDOMAINS <3 \e[0m"
amass enum -d $1 -o targets/$1/domains.txt
echo "\e[1;31m SUBDOMAIN COLLECTED! \e[0m"
echo -e "\e[1;31m *********************** \e[0m"
echo -e "\e[1;31m SHOWING TITLES, CONTENT-LENGTH AND STATUS OF DOMAINS\e[0m"
cat targets/$1/domains.txt | httpx -silent -status-code -content-length -title
echo -e "\e[1;31m *********************** \e[0m"
echo -e "\e[1;31m SAVING SUBDOMAINS WITH STATUS CODE 200 \e[0m"
cat targets/$1/domains.txt | httpx -mc 200 -o targets/$1/httpx_status_200.txt
echo -e "\e[1;31m *********************** \e[0m"
echo -e "\e[1;31m SEARCHING FOR SENSITIVE DIRECTORIES :-) \e[0m"
ffuf -u https://$1/FUZZ -w /root/Desktop/RECON/OneListForAll/onelistforallshort.txt -mc 200 -recursion
echo "****************************"
echo "Enjoy... <3 "

rm -fr targets/$1/$1.txt
