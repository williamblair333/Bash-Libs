#ip_list=$(ip address | grep -B 3 'valid_lft' | awk '{print $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7 "," $8 "," $9}')
#awk NR== refers to which line number to return / print
#grep -A refers to returning result plus x lines after -B before -C before and after
#echo "${variable//<character>}") will remove the character listed and optionally all characters after
nic_up=$(ip address | grep 'state UP'| awk '{print $2}')

for name in $nic_up
do
   nic_name=$(ip address | grep -A 2 "$name" | awk '{print $2}' | awk 'NR==1')
   nic_name=$(echo "${nic_name//:}")
   nic_mac=$(ip address | grep -A 2 "$name" | awk '{print $2}' | awk 'NR==2')
   nic_ip=$(ip address | grep -A 2 "$name" | awk '{print $2}' | awk 'NR==3')
   nic_ip=$(echo "${nic_ip//\/*}")   
   echo $nic_name","$nic_mac","$nic_ip
done
