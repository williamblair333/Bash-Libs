#create two separate files, and display on screen and combine all output to one file
cmd | tee stdout.log 3>&1 1>&2 2>&3 | tee stderr.log &> all.log

#less confusing, suppress errors, create two separate files with console output 
#tee -a to append
cmd 2>/tmp/stderr.log | tee /tmp/stdout.log
