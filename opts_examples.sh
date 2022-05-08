#!/bin/env bash

set -o errexit
set -o nounset
set -eu -o pipefail

#set -x
#trap read debug

#############################################################
#This is an example of parsing options and arguments. 
#############################################################
#https://www.livefirelabs.com/unix_tip_trick_shell_script/
#unix_shell_scripting/
#examples-of-how-to-pass-shell-script-arguments-using-shift-and-getopts.htm
#https://www.reddit.com/r/bash/comments/jkblav/
#double_dash_parameters_in_bash_script/

#https://stackoverflow.com/questions/9271381/how-can-i-parse-
#long-form-arguments-in-shell

https://stackoverflow.com/questions/402377/
#using-getopts-to-process-long-and-short-command-line-options
#Arvid Requate 

C_OPT=0
DIR=`pwd`
VERSION="0.1Alpha"

while [ "$1" != "" ]; 
do
   case $1 in
    -c | --c_option )
        C_OPT=1
        ;;
    -v | --version )
        echo "Version: $VERSION"
        ;;
    -d | --directory )
        shift
        if [ -d "$1" ]
           then
             DIR="$1"
        else
           echo "$0: $1 is not a valid directory" >&2
           exit
        fi
        ;;
    -h | --help ) 
         echo "Usage: my_test [OPTIONS]"
         echo "OPTION includes:"
         echo "   -c | --c_option - flips the C_OPT variable from 0 to 1"
         echo "   -v | --version - prints out version information for this script"
         echo "   -d | --directory - requires user to specify a directory"
         echo "   -h | --help - displays this message"
         echo "   the command requires a filename argument"
         exit
      ;;
    * ) 
        echo "Invalid option: $1"
        echo "Usage: my_test [-c] [-v] [-d directory_name ]"
        echo "     -c flips the C_OPT variable from 0 to 1"
        echo "     -v prints out version information for this script"
        echo "     -d requires user to specify a directory"
        echo "     -h | --help - displays this message"
        echo "     the command requires a filename argument"
        exit
       ;;
  esac
  shift
done


#!/usr/bin/env bash 
optspec=":hv-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                loglevel)
                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                    ;;
                loglevel=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
                    echo "Parsing option: '--${opt}', value: '${val}'" >&2
                    ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac;;
        h)
            echo "usage: $0 [-v] [--loglevel[=]<value>]" >&2
            exit 2
            ;;
        v)
            echo "Parsing option: '-${optchar}'" >&2
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done
