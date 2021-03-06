#!/bin/bash

#This script returns full or individual date / time values.  Values such as only the month or only the minutes, for example.

yymmdd=$(date '+%Y-%m-%d')
#echo $yymmdd

function yymmdd() {
  yymmdd=$(date '+%Y-%m-%d')
  echo "$yymmdd"
}

function year() {
  year=$(date '+%Y')
  echo "$year"
}

function month() {
 month=$(date '+%m')
 echo "$month"
}

function day() {
 day=$(date '+%d')
 echo "$day"
}

function hour() {
 hour=$(date '+%k')
 echo "$hour"
}

function minute() {
 minute_local=$(date '+%M')
 echo "$minute_local"
}

function seconds() {
 seconds=$(date '+%S')
 echo "$seconds"
}
