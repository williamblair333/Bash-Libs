#!/bin/env bash
set -o errexit
set -o nounset
set -eu -o pipefail
#set -x
#trap read debug
#################################################################################
#
#Run example: ./far.sh -l "unique_string_here" -i "test.txt" -j "+2" -f "string to find" -r "string_to_replace" -s "g"
#File:        ./far.sh
#Date:        2022MAY04
#Author:      William Blair
#Contact:     williamblair333@gmail.com
#Tested on:   Debian 11

#This script is intended to do the following:
#
#Find a specific line by inputting a string then manipulate that string using sed
#################################################################################

function Help() 
{
    # Display Help
    echo "Sed Find and Replace Helper Script"
    echo
    echo "usage: -l line in file to search for, required"
    echo "usage: -i input file to make changes to, required"
    echo "usage: -j how many lines to jump up or down. Ex. +2 or -2, optional"
    echo "usage: -f string to find, required"
    echo "usage: -r string to replace, optional"
	echo "usage: -s scope of replacement, Ex. g for all instances.  See man sed" \
    echo "for more examples, optional"
	echo "usage: -h this help file"
	echo
}
#################################################################################

function main() 
{
    while getopts ":c:t:x:h" option;
      do
          case "$option" in
              
              i)  file_input="$OPTARG";;
			  l)  line_search="$OPTARG";;
              f)  string_find="$OPTARG";;
              r)  string_replace="$OPTARG";;
              s)  replace_scope="$OPTARG";;
              j)  line_jump="$OPTARG";;
              c)  line_jump="$OPTARG" ;;
              h)  Help;;

              *)  echo "No valid answer, exiting.."
                  exit;;
         esac
    done
    
    if [[ $# -lt 1 ]]; then
        Help
    fi
	
	sed_check=$(find /usr/bin -name 'sede' | awk -F / '{print $4}')
	
	if [ -z "$sed_check" ]; then
	    echo 'Sed not found! Exiting'
		exit 1
		echo 'hello'
	fi
	
	sed -i "$(( $(sed -n '/$line_search/'= $file_input) $line_jump ))s/$string_find/$string_replace/$replace_scope" $file_input
}
#################################################################################

main "$@"
#################################################################################