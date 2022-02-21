#!/bin/bash

dir=backup/btrfs-backup

# -z mean is that if the command line argument doesn't exist, then...
if [ -z "$1" ] 
then
      file=btrfs-target_server_01.txt
      while IFS= read -r line; do /$dir/backup_worker_server_01.sh "$line"; done < /$dir/$file
else
      file=$1
      cd /$dir
      /$dir/backup_worker_server_01.sh "$file"
fi

