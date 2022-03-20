#!/usr/bin/env bash

#It's not finished.

#https://www.ssldragon.com/blog/how-to-install-an-ssl-certificate-on-debian/
#https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/
#https://docs.cpanel.net/ea4/apache/modify-apache-virtual-hosts-with-include-files/

set -o errexit
set -o nounset
set -eu -o pipefail
#set -x
#trap read debug
#################################################################################

function Help() {
   # Display Help
   echo "SSL CSR Generation Script"
   echo
   echo "Syntax: ssl-csr-gen.sh  [-w|b|c|s|t|n|o|u|h]"
   echo "options:"
   echo "w     Website FQDN"
   echo "b     Bit size, default is 2048"
   echo "c     Country"
   echo "s     State"
   echo "t     City"
   echo "n     ORG Name"
   echo "o     OU Name"
   echo "m     Common Name, default is $website_name"
   echo "h     This help file"
   echo 
}
#################################################################################
    website_name=my.site.org
	bit_size=2048
	country=GB
	state=London
	city=London
	org_name=Fu-bar
	ou_name=some_ou
	common_name="$website_name"
	#email_addr=""
	#password=""
	#company_name=""
#################################################################################

while getopts w:b:c:s:t:n:o:u:h: flag
do
    case "${flag}" in
        w)    website_name=${OPTARG};;
        b)    bit_size=${OPTARG};;
        c)    country=${OPTARG};;
        s)    state=${OPTARG};;
	    t)    city=${OPTARG};;
        n)    org_name=${OPTARG};;
	    o)    ou_name=${OPTARG};;
	    u)    common_name=${OPTARG};;
	    h)    Help
	    exit;;
	    [?])  print >&2 "Usage: $0 [-w Website FQDN] [-c Country] [-s State] \
	          [-t City] [-n ORG Name] [-o OU Name] [-u Common Name]"
	    exit 1;;
        \?)   # incorrect option
              echo "Error: Invalid option"
              exit;;			   
        *)
    esac
done
#################################################################################

function csr_generate() {
    openssl req \
        -new \
	-newkey \
	rsa:"$bit_size" \
	-nodes \
	-keyout "$website_name".key \
	-out "$website_name".csr \
	-subj "/C=""$country""/ST=""$state""/L=""$city""/O=""$org_name""/OU=""$ou_name""/CN=""$common_name"""
	
    printf "%s\n" "Generating: " """$website_name"".key ""$website_name"".csr"
}
#################################################################################

function csr_setup() {
    printf "%s\n" "csr_setup"
    #Make directories here
    #do Error handling
}
#################################################################################

function csr_install() {
    printf "%s\n" "csr_install"
    #Create the apache2 include file with cat piping
}
#################################################################################

function main() {
    csr_generate
#################################################################################
}
# Invokes the main function
#main
main "$@"
#################################################################################
