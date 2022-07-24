User_manage.sh can:
-----------------
#1# user add
#2# user delete (normal or recursive)
#3# get user details
#4# password unlock
#5# password lock
#6# Disable account
#7# Enable Account
#8# Add group
#9# Delete group
#10# Add user to group
#11#Delete user from group


User_manage.sh calls user_add.sh
----------------------------------

user_add.sh:

*Needs a CSV file in form of <full name>,<email>,<phone number>
*Adds a new user for every first name mentioned, some user names will be padded with numbers if 
found to be existing
*user last/middle names and phone numbers will be added as comments
*Passwords are generated for each user and the credentials are sent via mail 

*sendmail is used in this script.
The configuration description is in a separate file