#!/bin/bash

#Declare our variables
PROC_LST_REAR=$(ps -aux | grep -v grep | grep '/usr/sbin/rear udev' | awk '{print $2}')
MNT_PART_REAR=$(cat /proc/mounts | grep 'REAR' | awk '{print $1}')
MNT_DIR_REAR=$(cat /proc/mounts | grep 'REAR' | awk '{print $1}')

#Are REAR processes running?  Check here, return process number and then exit
if [ -z "$PROC_LST_REAR" ]
then
      echo "REAR process(es) not detected"
else
      echo "REAR process(es) detected!"
      for process in $PROC_LST_REAR; do
        echo "PID:  $process"
        #exit
      done
fi

#Is REAR mounted? Check here and report partition and mount directory
if [ -z "$MNT_PART_REAR" ]
then
      echo "REAR doesn't appear to be mounted"
      echo "Now running REAR"
      /usr/sbin/rear -v mkbackup
else
      echo "REAR is currently residing on partition $MNT_PART_REAR and mounted on $MNT_DIR_REAR"
      echo "Unmounting REAR"
      umount $MNT_DIR_REAR
      echo "Now running REAR"
      /usr/sbin/rear -v mkbackup
fi
