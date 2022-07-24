#########################################################################################

##############################ITI- Bash scripting task###################################

#1# user add
#2# user delete (normal or recursive)
#3# get user details
#4# password unlock
#5# password lock
#6# Disable account
#7# Add group
#8# Delete group
#9# Add user to group
#10#Delete user from group
#*****Requires Privileged Access*****
##########################################################################################

#!/bin/bash

echo "############################/*************\####################################"
echo "###########################| Select Option |###################################"
echo "############################\*************/####################################"

select option in "user add" "user deletion" "get user details" "password lock" "password unlock" \
"Disable account" "Enable account" "Add Group" "Remove Group" "Add user to group" \
"Remove User From Group" "Exit"
do
   case $option in
    ("user add") 
        echo "Enter the name/path of a file with valid format: name,email,phone"
        read inp_file
        if [ -z "$inp_file" ]; then 
            echo "No Input detected"
        elif [ $(awk -F',' '{print NF; exit}' $inp_file)  -ne 3 ]; then
            echo "Fields less or more than required"
            echo "Detected Fields: $(awk -F',' '{print NF; exit}' $inp_file)"
            echo "Make sure the fields are separated by \",\" and don't use it in the context"
        else
            ./user_add.sh $inp_file
        fi
    ;;

    ("user deletion")
        echo "Please metion the user you wish to delete"
        read deleted_user
        if ! ((id $deleted_user) &> /dev/null) ; then
            echo "No such user"
            #break
        else
            select del_type in "normal" "recursive"
            do
                case $del_type in
                    ("normal")
                        userdel $deleted_user
                    ;;
                    ("recursive")
                        userdel -r $deleted_user
                    ;;
                    (*)
                        echo "Undefined input"
                    ;;
                esac
                break
            done
        fi
        
    ;;
    ("get user details")
        echo "Please Enter The Name Of The User Whose Details Interest You"
        read commented_user
        if ! ((id $deleted_user) &> /dev/null) ; then
            echo "No such user"
            
        else
            cat /etc/passwd | grep $commented_user | awk -F ":" '{print $5; exit}'
        fi
    ;;
    ("password lock")
        echo "Please Mention The User Whose Password You Wish To Lock:"
        read locked_user
        if ! ((id $locked_user) &>/dev/null) ; then
            echo "No Such User"
        else
            passwd --lock $locked_user
        fi
    ;;
    ("password unlock")
        echo "Please Mention The User Whose Password You Wish To Unlock:"
        read unlocked_user
        if ! ((id $unlocked_user) &>/dev/null) ; then
            echo "No Such User"
        else
            passwd --unlock $unlocked_user
        fi
    ;;
    ("Disable account")
        echo "Please Mention The User You Wish To Disable:"
        read disabl_usr
        if ! ((id $disabl_usr) &>/dev/null) ; then
            echo "No Such User"
        else
            chage -E 0 $disabl_usr
        fi
    ;;
    ("Enable account")
        echo "Please Mention The User Whose Account You wish To Enable"
        read enb_usr
        if ! ((id $enb_usr) &>/dev/null) ; then
            echo "No Such User"
        else
            chage -E -1 $enb_usr
        fi
    ;;
   ("Add Group")
        echo "Please Enter The Name Of The New Group:"
        read new_name
        groupadd $new_name
   ;;
   ("Remove Group")
        echo "Please Enter The Name Of The Group You Wish To Remove:"
        read del_grp
        groupdel $del_grp
   ;;
   ("Add user to group")
        echo "WARNING: YOU CAN'T CHANGE PRIMARY GROUPS."
        echo "Enter The User Name:"
        read usr
        if ! ((id $usr) &>/dev/null) ; then
            echo "No Such User"
            continue
        fi
        echo "Enter Group Name:"
        read grp
        if ! ((getent group $grp) &>/dev/null) ; then
            echo "No Such Group"
            continue
        fi
        usermod -aG $grp $usr
   ;;
   ("Remove User From Group")
        echo "Enter The User Name:"
        read usr
        if ! ((id $usr) &>/dev/null) ; then
            echo "No Such User"
            continue
        fi
        echo "Enter Group Name:"
        read grp
        if ! ((getent group $grp) &>/dev/null) ; then
            echo "No Such Group"
            continue
        fi
        gpasswd -d $usr $grp 
   ;;
   ("Exit")
        break
   ;;
   esac
done