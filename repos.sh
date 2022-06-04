#!/bin/env bash

#set -x
#trap read debug

cat $1 | while read line
do
    git clone git@github.com:williamblair333/$line
done <<< repos.txt
