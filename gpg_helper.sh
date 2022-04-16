#!/bin/env bash

set -o errexit
set -o nounset
set -eu -o pipefail

#set -x
#trap read debug

#################################################################################
#
#Run example: ./gpg_helper.sh -e "yes" -s "$HOME/src_file" -p 'L0ckdmeUp1' -a "aes256" -t "." -f "enc_src_file"
#File:        gpg_helper.sh
#Date:        updated 2022APR16
#Author:      William Blair
#Contact:     williamblair333@gmail.com
#Tested on:   Debian 10
#To test:     Ubuntu 20+
#
#This script is intended to do the following:
#
#- encrypt a tar.gz on the fly using a passphrase
#
#- TODO add more gpg functionality like keys and better error handling
#################################################################################

function Help() 
{
    # Display Help
    echo "GPG Encryption Helper Script"
    echo
    echo "Syntax: gpg-helper.sh  [-a|f|p|s|t|e|d]"
    echo "options:"
    echo "a     Algorithm type, ex. aes256"
    echo "f     Filename, default is my_home"
    echo "p     passphrase, default is !@!@#@#ADFlkjoij899978IOf1234234"
    echo "s     Source file or directory, default is $HOME"
    echo "t     Directory target, default ."
    echo "e     Encrypt Switch -e 'yes' to encrypt"
    echo "d     Decrypt Switch -d 'yes' to decrypt"   
    echo "h     Help file" 
}
#################################################################################

function gpg_encrypt() 
{
    tar czvpf - "$source" \
    | gpg \
    --batch --yes \
    --no-tty \
    --passphrase="$pass_phrase" \
    --symmetric \
    --pinentry-mode=loopback \
    --cipher-algo "$algorithm" \
    --output "$dir_target"/"$file_name".tar.gz
}
#################################################################################

function gpg_decrypt() 
{
    gpg \
    --passphrase="$pass_phrase" \
    --pinentry-mode=loopback \
    --decrypt "$dir_target"/"$file_name".tar.gz \
    | tar xzvf -
}
#################################################################################
function main() 
{

    encrypt="no"
    decrypt="no"

    #This corrects gpg: error creating passphrase: Operation cancelled
    GPG_TTY=$(tty)
    export GPG_TTY
#################################################################################

    while getopts ":s:p:a:t:f:e:d:h" option;
        
      do
        #case "${flag}" in
        case "$option" in
          s)  source="$OPTARG";;          
          p)  pass_phrase="$OPTARG";;
          a)  algorithm="$OPTARG";;
          t)  dir_target="$OPTARG";;
          f)  file_name="$OPTARG";;
          e)  encrypt="$OPTARG" ;;
          d)  decrypt="$OPTARG" ;;
          h)  Help ;;
          *) 

        esac
    done
#################################################################################

    if [ "$encrypt" == "yes" ] && [ "$decrypt" == "yes" ]; then
        echo "Invalid arguments.  You can either encrypt or decrypt, not both."
        exit

    elif [ "$encrypt" == "yes" ]; then
        decrypt="no"
        echo "doing gpg_encrypt"
        gpg_encrypt
        exit
        
    elif [ "$decrypt" == "yes" ]; then
    {
        echo "doing gpg_encrypt"
        gpg_decrypt
        exit
    }
    fi
    
    Help
}

main "$@"
#################################################################################
