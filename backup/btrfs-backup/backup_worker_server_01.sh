#!/bin/bash

source /backup/btrfs-backup/date-time.config
source /backup/btrfs-backup/backup_server.config

#get just the name for our target and insert into the backup tgz name
#folder_target='config_server_01_container_01.conf'
folder_target=$1
one=${folder_target#*_}
two=${one#*_}
three=${two#*_}
folder_target=${three%.*}

cd /mnt/backup/btrfs-backup

./backup snap test 1 -c $1 -p1
tempfolder=$(ls /$start_path/$gen_path/$year/$month/$day)
#tar -zcvf backup_$year-$month-$day-$folder_target.tar.gz /$start_path/$gen_path/$year/$month/$day/$tempfolder
tar -zcvf backup_$year-$month-$day-$folder_target.tar.gz /$start_path/$gen_path/$year/$month/$day/$tempfolder
rm -r /$start_path/$gen_path/$year/$month/$day/*
mv backup*.tar.gz /$start_path/$gen_path
