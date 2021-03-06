#!/usr/bin/bash
#When variable can’t be made local try the best to make it readonly
#https://mresetar.github.io/2020-03-25-writing-good-bash-scripts/
#https://www.putorius.net/using-trap-to-exit-bash-scripts-cleanly.html
#http://redsymbol.net/articles/bash-exit-traps/
#https://www.shellcheck.net/#
#https://github.com/bertvv/dotfiles/blob/master/.vim/templates/sh
#https://bertvv.github.io/cheat-sheets/Bash.html
#https://learnxinyminutes.com/docs/bash/
#https://google.github.io/styleguide/shellguide.html

#https://book.git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup

set -o errexit
set -o nounset
set -eu -o pipefail
#set -x
#trap read debug

function Help()
{
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

while getopts u:d:i:k: flag
do
    case "${flag}" in
        n)    user_name=${OPTARG};;
        e)    user_email={OPTARG};;
        i)    ip_addr=${OPTARG};;
	k)    key_name=${OPTARG};;
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

git_identity () {
    local user_name="$user_name"
    local user_email="$user_email"
	
	git config --list --show-origin
    git config --global user.name "${user.name}"
    git config --global user.email "${user.email}"


#!/usr/bin/env bash

#Global variable example
_GLOBAL_EXAMPLE="${GLOBAL_EXAMPLE:-"$USER"}"
_USER_AGE="${USER_AGE:-""}"


function complement_name(){
  local name="$1"
  echo "Wow, ${name}, you have a beautiful name!"
}


function complement_age(){
  local name="$1"
  local age="$2"
  if [[ "$age" -gt "30" ]]; then
    echo "Seriously ${name}? I thought you were $((age-7))"
  else
    echo "Such a weird age, are you sure it's a number?"
  fi
}

function main(){
  # The only function that is not "pure"
  # This function is tightly coupled to the script
  complement_name "$_USER_NAME"
  complement_age "$_USER_NAME" "$_USER_AGE"
}

# Invokes the main function
#main
main "$@"
