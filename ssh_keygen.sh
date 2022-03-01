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
#
#- copy the public key to the remote server
#################################################################################

#better way..
#mkdir -p ${HOME}/.ssh
#ssh-keygen -f ${HOME}/.ssh/$(whoami)_id_rsa -t rsa -N ''
#scp ${HOME}/.ssh/$(whoami)_id_rsa.pub user@192.168.1.1:/home/user/.ssh/$(whoami)_id_rsa.pub
#################################################################################

user_name="$1"
dir_ssh="$2"
ip_addr="$3"

if [ -z "$user_name" ]; then
	user_name=$(whoami)
fi

if [ -z "$dir_ssh" ]; then
	mkdir $HOME/.ssh
	dir_ssh=$(ls -a $HOME | grep '.ssh')
fi

if [ -z "$ip_addr" ]; then
	ip_addr="192.168.1.1"
fi



key_name=id_rsa
ssh-keygen -f $HOME/.ssh/$key_name -t rsa -N ''

#check if .ssh exists. If not, create the directory and copy the public key 
if ssh $(whoami)@$ip_addr '[ -d $HOME/.ssh ]'
then
{
    echo 'directory already exists'
    scp ${HOME}/.ssh/$key_name $(whoami)@$ip_addr:${HOME}/.ssh/$key_name
}
else
{
    ssh $(whoami)@$ip_addr "mkdir $HOME/.ssh"
    scp ${HOME}/.ssh/$key_name $(whoami)@$ip_addr:${HOME}/.ssh/$key_name
}
fi

ssh-copy-id -i ${HOME}/.ssh/$key_name $(whoami)@$ip_addr

#################################################################################
