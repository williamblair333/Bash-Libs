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
   echo "Add description of the script functions here."
   echo
   echo "Syntax: ssh_keygen.sh  [-b|u|d|i|k|h]"
   echo "options:"
   echo "b     SSH bit strength.  Default is 2048"
   echo "u     The user name to be used"
   echo "d     The ssh directory name to use. Default is .ssh"
   echo "i     IP address of remote server to send the SSH public key to"
   echo "k     SSH key name to use"
   echo "h     This help file"
   echo 
}
#################################################################################
        website_name=my.site.org
	bit_size=2048
	country=US
	state=Indiana
	city=Carmel
	org_name=Foobar
	ou_name=some_ou
	common_name="$server_name"
	server_name=webserver.mysite.org
	email_addr=joe.smith@gmail.com
	password=""
	company_name=Foobars
#################################################################################

while getopts u:d:i:k: flag
do
    case "${flag}" in
        w)    website_name=${OPTARG};;
        b)    bit_size={OPTARG};;
        c)    country=${OPTARG};;
        s)    state=${OPTARG};;
	t)    city=${OPTARG};;
	n)    org_name=${OPTARG};;
	o)    ou_name=${OPTARG};;
	u)    user_name=${OPTARG};;
	h)    Help
	exit;;
	[?])  print >&2 "Usage: $0 [-b bitsize] [-u username] [-d .ssh] [-i 192.168.1.1] [-k id_rsa] [-h]"
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
	-subj "/C="$country"/ST="$state"/L="$city"/O="$org_name"/OU="$ou_name"/CN="$common_name""
	
  printf "%s\n" "Generating: " ""$website_name".key "$website_name".csr"
}
#################################################################################

function csr_setup() {
    #Make directories here
	  #do Error handling
}
#################################################################################

function csr_install() {
    #Create the apache2 include file with cat piping
}
#################################################################################

function main() {
  # The only function that is not "pure"
  # This function is tightly coupled to the script
  #call your other functions here... 
}
#################################################################################

# Invokes the main function
#main
main "$@"
#################################################################################
