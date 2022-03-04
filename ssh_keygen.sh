#!/bin/env bash

#set -x
#trap read debug

#################################################################################
#
#Run example: ./ssh_keygen.sh -b 2048 -u williamblair333 -d .ssh -i 192.168.1.1 -k id_rsa
#File:        ssh_keygen.sh
#Date:        2022FEB16
#Author:      William Blair
#Contact:     williamblair333@gmail.com
#Tested on:   Debian 11
#To test:     Ubuntu 20+
#
#This script is intended to do the following:
#
#- automatically create ssh public and private key in the $HOME/$dir_ssh directory
#- without any passphrase
#
#- copy the public key to the remote server
#################################################################################

while getopts u:d:i:k: flag
do
    case "${flag}" in
        b) bits=${OPTARG};;
	u) user_name=${OPTARG};;
        d) dir_ssh=${OPTARG};;
        i) ip_addr=${OPTARG};;
	k) key_name=${OPTARG};;
    esac
done

# [ -z "$variable" ] means empty
if [ -z "$user_name" ]; then
    user_name=$(whoami)
fi

if [ -z "$dir_ssh" ]; then
    mkdir $HOME/.ssh
    dir_ssh=$(ls -a $HOME | grep '.ssh')
fi

#check if the ssh key destination directory exists
dir_chk=$(ls -a $HOME | grep -Fx $dir_ssh)

if [ "$dir_ssh" != "$dir_chk" ]; then
    mkdir $HOME/$dir_ssh
else
{
    echo "directory already exists"
}
fi

#check if $key_name exists
key_chk=$(ls -a $HOME/$dir_ssh/$key_name | awk 'BEGIN {FS="/"} {print $5}')

if [ "$key_chk" != "$key_name" ]; then
    yes 'y' | ssh-keygen -b $bits -f $HOME/$dir_ssh/$key_name -q -t rsa -N ''
    
else
{
    echo "key already exists"
}

fi

if [ -z "$ip_addr" ]; then
    ip_addr="192.168.1.1"
fi

#create the key and automatically overwrite existing keys!
#Let's hold off the nuclear option until we think it through
#yes 'y' | ssh-keygen -f $HOME/$dir_ssh/$key_name -q -t rsa -N ''

#check if $dir_ssh exists on target server. If not, create the directory and copy 
#the public key.
if ssh $user_name@$ip_addr '[ -d $HOME/$dir_ssh ]'; then
{
    echo 'directory already exists'
    scp ${HOME}/$dir_ssh/$key_name.pub $user_name@$ip_addr:${HOME}/$dir_ssh/$key_name.pub
}

else
{
    ssh $user_name@$ip_addr "mkdir $HOME/$dir_ssh"
    scp ${HOME}/$dir_ssh/$key_name.pub $(whoami)@$ip_addr:${HOME}/$dir_ssh/$key_name.pub
}
fi

ssh-copy-id -i ${HOME}/$dir_ssh/$key_name.pub $user_name@$ip_addr
#################################################################################
