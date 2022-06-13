#!/usr/bin/env bash

clear

set -o errexit
set -o nounset
#set -eu -o pipefail
#set -x
#trap read debug
#################################################################################
#
#Run example: ./lvm-backup.sh -i 192.168.1.83 -u blairwb -f "mnt/backup-nvme" -m "/mnt/vmdisk" -l "lvtest0 lvtest1" -p 'password_here'" | tee stdout.log 3>&1 1>&2 2>&3 | tee stderr.log &> all.log
#File:        lvm-backup.sh
#Date:        updated 2022JUN13
#Author:      William Blair
#Contact:     williamblair333@gmail.com
#Tested on:   Debian 11+, Ubuntu 18
#
#This script is intended to do the following:
#
#- create snapshot of target logical volumes
#- mount each partition in target snapshot using guestfish
#- scp the file to a target location
#- NOTES: It's assumed no password is needed to ssh /scp log in. Use -p switch to 
#-   add a password.  Best practice is to create ssh keys.
#- TODO: function to scp with sshpass if -p flag is called Right now, just manually
#-   comment out the scp section if you're using ssh keys or supplying a password
#################################################################################

lv_control="lvtest0"
backup_ip="192.168.1.10"
backup_user="username"
backup_folder="mnt/backup_folder"
mount_path="/mnt/lvm_folder"
backup_user_pwd='password_goes_here'
DATE=$(date '+%Y-%m-%d')

function Help() 
{
    # Display Help
    echo "LVM Snapshot and Backup Helper Script"
    echo
    echo "Syntax: lvm-backup-sh  [-i|u|f|m|l]"
    echo "options:"
    echo "i     Remote Backup Target IP"
    echo "u     Remote Backup Target Username"
    echo "f     Remote Backup Target Folder"
    echo "m     Local Backup Target Folder"
    echo "l     Logical Volume Target List"
    echo "p     Remote Backup Target Username Password"
    echo "h     Help file" 
}

function control_filter() {
    LIST=$1
    DELIMITER=$2
    VALUE=$3
    echo "$LIST" | tr "$DELIMITER" '\n' | grep -q "$VALUE"
}

function get_lv_info() {
    #get logical volume name and size separated by comma
    v_group=$(vgs | awk '(NR>1)' | awk '{print $1}')
    lv_info=$(lvs | awk '(NR>1)' | awk '{print $1","$4}')
    lv_name=$(echo "$lv_info" | awk -v FS=, '{print $1}')
}

function get_part_list () {
    #get partition(s) with the logical volumes
    part_info=$(guestfish -a /dev/$1/$2 --ro <<EOT
        run
        list-partitions
        lvs
        quit
EOT)
}

function destroy_snapshot() {
    #lvremove --yes volume_group/logical_volume
    lvremove --yes $1/$2
}

function create_snapshot() {
    #lvcreate -s -n <snapshot_name> -L <size> <volume_group>/<logical_volume>
    #if snapshot_name exists, delete it
    [[ -e /dev/$1/$2 ]] && destroy_snapshot $5 $3
    lvcreate -s -n $3 -L $4 $5/$6
}

function create_part_backup () {
    #tar and compress the partition to file
    guestfish --ro -a /dev/$1/$2-backup -m $3 tgz-out / $4-backup.tar.gz
}

function get_lv_size () {
    lv_size=$(lvs | grep $1 | awk '{print $4}')
}

function main() {

    while getopts ":i:u:f:m:l:p:h" option;
        
      do
        #case "${flag}" in
        case "$option" in
          i)  backup_ip="$OPTARG";;          
          u)  backup_user="$OPTARG";;
          f)  backup_folder="$OPTARG";;
          m)  mount_path="$OPTARG";;
          l)  lv_control="$OPTARG";;
          p)  backup_user_pwd="$OPTARG";;
          h)  Help ;;
          *) 
        esac
    done
    
    #require at least one argument
    if [[ $# -lt 1 ]]; then
        Help
        exit 1
    fi

    get_lv_info
    destroy_snapshot /dev/"$v_group" "*-backup" || true
    get_lv_info

    while IFS= read -r name; do
        #if the logical volume exists and is present in lv_control variable 
        if control_filter "$lv_control" " " "$name"; then
            echo ---------------------------------------------------------------
            echo "Processing volume in list..."
            mount_point="$mount_path"/"$name"-backup
            [[ ! -d "$mount_point" ]] && mkdir "$mount_point"
                    
            get_lv_size "$name"
            create_snapshot "$v_group" "$name"-backup "$name"-backup "$lv_size" "$v_group" "$name"
            get_part_list "$v_group" "$name"-backup

            #some logical volumes only have one partition and it must be addressed 
            #  by auto adding partition information (sda), then tar, compress and
            #  and send to backup target server
            if [ -z "$part_info" ]; then
                echo "Backing up single partition for ""$name"-sda-"$DATE"
                create_part_backup "$v_group" "$name" /dev/sda "$mount_point"/"$name"-sda-"$DATE" || true
            else
                echo "$name"-sda-"$DATE"            
            #if more than one partion in logical volume, tar, compress and ship
            #  all of them to backup target server
                while IFS= read -r part; do
                    part_num=$(echo "$part" | awk -v FS=/ '{print$ 3}') && echo "$part"
                    create_part_backup "$v_group" "$name" "$part" "$mount_point"/"$name"-"$part_num"-"$DATE" || true
                done <<< "$part_info"
            fi
            echo ---------------------------------------------------------------
            #scp with ssh keys
            #scp "$mount_point"/* "$backup_user"@"$backup_ip":/"$backup_folder"/"$name"-backup/
            #scp with password
            sshpass -p "$backup_user_pwd" \
                scp "$mount_point"/* \
                "$backup_user"@"$backup_ip":/"$backup_folder"/"$name"-backup/ \
                
            rm -r "$mount_point"/*
            destroy_snapshot "$v_group" "$name"-backup
        else
            echo "Skipping ""$name"
        fi
    done <<< "$lv_name"
}

main "$@"
#################################################################################