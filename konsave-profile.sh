#!/bin/bash

#The purpose of this script is to automate profile creation and export of KDE user
#configurations using the Konsave project (https://github.com/Prayag2/konsave)
#################################################################################

source '/path/to/file/date-time.config'

rm ${HOME}/.config/konsave/*.knsv
${HOME}/.local/bin/konsave -w
echo "WIPE"

ext='knsv'
export_path=${HOME}/.config/konsave
echo $export_path
export_path=${export_pathvar%?}
echo $export_path

username=$(whoami)
hostname=$(cat /etc/hostname)
filename=$hostname-$username-$year-$month-$day

echo $username
echo $hostname
echo $filename

${HOME}/.local/bin/konsave -s $filename
${HOME}/.local/bin/konsave -e $filename
echo "Konsave: Moving" $filename.$ext "to" $export_path
echo "here" $export_path
mv ${HOME}/$filename.$ext ${HOME}/.config/konsave/$filename.$ext
