#########################################################################################

##############################ITI- Bash scripting task###################################

#required:
#////////////////#
#The script is called with a file as an argument
#Make new users with the name provided in the csv file 
#Set random passwords and chage to 0
#Send the userIDs and passwords through mails

#*****Requires Privileged Access*****#
##########################################################################################

#!/bin/bash

#Assuming the supported file contains only first and second names
#Each name, be it first or second, is in a separate entry
#So each user name takes two entris

user_full=($(awk -F',' ' { print $1 }  ' $1)) 

#echo ${user_full[3]}

user_first_name=$(awk -F\  ' { print $1 }  ' $1)
user_first_name=($(echo $user_first_name | tr '[[:upper:]]' '[[:lower:]]'))
#echo ${user_first_name[@]}
user_middle_name=($(awk -F'[,| ]' ' { print $2 }  ' $1))
#echo ${user_middle_name[@]}
user_emails=($(awk -F'[,]' ' { print $2 }  ' $1))
#echo ${user_mails[@]}
user_phones=($(awk -F'[,]' ' { print $3 }  ' $1))
#echo ${user_phones[@]}
#############Adding new users##############
#usr_count=$(wc -l $1 | awk '{print $1}')
#usr_count=$((usr_count+1))
#echo $usr_count
#echo ${#user_first_name[@]}
#echo ${user_first_name[@]}

for (( i=0; i<${#user_first_name[@]}; i++ ));
do
    #echo ${user_first_name[$i]}
    #id ${user_first_name[$i]}
    if ! ((id ${user_first_name[$i]}) &> /dev/null) ; then
        useradd ${user_first_name[$i]}
        #echo "fine"
    else 
        user_first_name[i]="${user_first_name[$i]}$i$RANDOM"
        i=$(($i-1))
        #echo "finer"
    fi
    
done

############Adding user details#############
#Phones and middle names
for (( i=0; i<${#user_first_name[@]}; i++ ));
do
    
    usermod -c "${user_middle_name[$i]} Phone-->${user_phones[$i]}" ${user_first_name[$i]}
    
done

############creating passwords#############
user_passwords=()
for (( i=0; i<${#user_first_name[@]}; i++ ));
do
    user_passwords+=($(dd if=/dev/urandom count=1 2> /dev/null | base64  | sed -ne 2p | cut -c-12))
    #echo ${user_passwords[$i]}
    echo ${user_passwords[$i]} | passwd ${user_first_name[$i]} --stdin   &>/dev/null
    #echo "Password: ${user_passwords[$i]} ---> ${user_first_name[$i]}"
    passwd -e ${user_first_name[$i]} &>/dev/null #expire
done
#echo ${#user_passwords[@]}

##############sending mails################
for (( i=0; i<${#user_first_name[@]}; i++ ));
do
    echo "Sending"
    echo -e "Subject: Credentials\nYour ID: ${user_first_name[$i]}\nYour Password: ${user_passwords[$i]}" | sendmail -Am -t -f amribraheem1@gmail.com ${user_emails[$i]}

    sleep 5
done
