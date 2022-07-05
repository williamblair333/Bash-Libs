#!/usr/bin/env bash

set -o errexit
set -o nounset
set -eu -o pipefail
#set -x
#trap read debug
#################################################################################
#put tips, tricks and other stuff here. Maybe make a lib of sorts one day.
#################################################################################

#get date & time service was last started
sudo systemctl status service-name | grep Active | awk '{print $6 "|" $7}'

#use sed to grep for a string and make changes before or after that line -1, +2 etc..
sed -i "$(( $(sed -n "/string_on_a_line/"= /path/to/file.conf) +- int )) s/find_string/replace_string/g" /path/to/file.conf

#create multiple directories, useful for building a skeleton quickly
mkdir -p htg/{articles/{new,rewrites},images,notes,done}

#for loop, check space separated variable and then do stuff
function package_check() {
    PACKAGES='curl jq'
    for package in $PACKAGES; do 
        CHECK_PACKAGE=$(sudo dpkg -l \
        | grep --max-count 1 "$package" \
        | awk '{print$ 2}')
            
        if [[ ! -z "$CHECK_PACKAGE" ]]; then 
            echo "$package" 'is already installed'; 
        else 
            sudo apt-get --yes install --no-install-recommends "$package"
        fi
    done
}

#Create a file in bash using EOF
cat << 'EOF' > 
path/dummyfile.txtTest file
EOF
