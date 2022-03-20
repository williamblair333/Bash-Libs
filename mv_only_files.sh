#!/bin/bash

#Simple script to quickly move only files in a folder to destination
#https://superuser.com/questions/65635/how-to-move-only-files-in-unix

find . -maxdepth 1 -type f -name '*' -exec mv -n {} $1 \;
