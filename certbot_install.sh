#!/bin/env bash

#set -x
#trap read debug

#################################################################################
#
#Run example: ./certbot_install.sh
#File:        certbot_install.sh
#Date:        2022MAR01
#Author:      William Blair
#Contact:     williamblair333@gmail.com
#Tested on:   Debian 11
#To test:     Ubuntu 20+
#
#This script was shamelessly taken taken from Tyson Nichols - February 21, 2022 14:20
#https://help.datica.com/hc/en-us/articles/360044373551-Creating-and-Deploying-a-LetsEncrypt-Certificate-Manually
#and intends to do the following:
#
#- manually setup and create a certificate from certbot for a website
#################################################################################

#Update, add repo, get packages do the install
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update && sudo apt-get install certbot

#Generate A Certificate
sudo certbot certonly --manual --preferred-challenges dns

#Enter the domain name. Type your domain and press Enter.
#Log your IP. Certbot will not issue a cert without this..
#The IP of this machine will be publicly logged as having requested this
#certificate. If you're running certbot in manual mode on a machine that is not
#your server, please ensure you're okay with that.
#Go to your site and create a DNS TXT record. This is how Certbot verifies that 
#you own the domain you are making a certificate for.

#Deploy the DNS TXT record under the name _acme-challenge.test.<Your Domain Here>
#with the following value:
# onzt5fUIcbhY6t8BW4asQHi8k-Imwwi1Epxy4Q8Fb9A

#Before continuing, verify the record is deployed.
#After you have create and saved this record, you can press enter for Certbot to resume.

#Certificate and chain have been saved at:
#/etc/letsencrypt/live/<Your Domain Here>/fullchain.pem
#Your key file has been saved at:
#/etc/letsencrypt/live/<Your Domain Here>/privkey.pem

#Now go install your certificate..
#todo https://www.ssldragon.com/blog/how-to-install-an-ssl-certificate-on-debian/
