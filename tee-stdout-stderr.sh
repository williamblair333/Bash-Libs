#create two separate files, and display on screen and combine all output to one file
cmd | tee stdout.log 3>&1 1>&2 2>&3 | tee stderr.log &> all.log
