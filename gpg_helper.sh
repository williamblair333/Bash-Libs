#!/bin/env bash

set -o errexit
set -o nounset
set -eu -o pipefail

#set -x
#trap read debug
#It's not finished.
#################################################################################

function Help() {
   # Display Help
   echo "GPG Encryption Helper Script"
   echo
   echo "Syntax: gpg-helper.sh  [-w|b|c|s|t|n|o|u|h]"
   echo "options:"
   echo "a     Algorithm type, default is aes256"
   echo "f     Filename, default is my_home"
   echo "p     passphrase, default is !@!@#@#ADFlkjoij899978IOf1234234"
   echo "s     Source file or directory, default is $HOME"
   echo "t     Directory target, default ."
   echo "e     Encrypt Switch"
   echo "d     Decrypt Switch"   
   echo 
}
#################################################################################

algorithm=aes256
file_name=my_home
pass_phrase='!@!@#@#ADFlkjoij899978IOf1234234'
source=$HOME
dir_target="."
#################################################################################

#This corrects gpg: error creating passphrase: Operation cancelled
GPG_TTY=$(tty)
export GPG_TTY
#################################################################################

function gpg_encrypt() {
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

function gpg_decrypt() {
    gpg --decrypt "$dir_target"/"$file_name".tar.gz | tar xzvf -
}
#################################################################################

while getopts a:f:p:t:e:d:h: flag
do
    case "${flag}" in
        a)    algorithm=${OPTARG};;
        f)    file_name=${OPTARG};;
        p)    pass_phrase=${OPTARG};;
        t)    dir_target=${OPTARG};;
        e)    gpg_encrypt
              exit;;
        d)    gpg_decrypt
              exit;;
        h)    Help
              exit;;
        [?])  print >&2 "Usage: $0 [-a Algorithm] [-f Filename] [-p Passphrase]"
              exit 1;;
        \?)   # incorrect option
              echo "Error: Invalid option"
              exit;;			   
        *)
    esac
done
#################################################################################
function main() {
    printf "%s\n" "GPG Helper script starting..."
}
# Invokes the main function
#main
main "$@"
#################################################################################
