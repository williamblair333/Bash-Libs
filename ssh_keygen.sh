#!/bin/sh
#################################################################################
#
#Run example: ./ssh_keygen.sh "Torvalds"
#File:        ssh_keygen.sh
#Date:        2022FEB16
#Author:      William Blair
#Contact:     williamblair333@gmail.com
#Tested on:   Debian 11
#To test:     Ubuntu 20+
#
#This script is intended to do the following:
#
#- automatically create ssh public and private key in the $HOME/.ssh directory
#- without any passphrase
#################################################################################

user_name="$1"
dir_ssh=$(ls -a $HOME | grep '.ssh')

if [ -z "$user_name" ]; then
	user_name=$(whoami)
	echo $user_name
fi

if [ -z "$dir_ssh" ]; then
	mkdir $HOME/.ssh
	dir_ssh=$(ls -a $HOME | grep '.ssh')
fi

key_name=${user_name}_id_rsa

ssh-keygen -f $HOME/.ssh/$key_name -t rsa -N ''
