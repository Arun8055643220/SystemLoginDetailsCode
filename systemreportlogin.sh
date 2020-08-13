#!/bin/bash
echo -e "Enter the Date, Use Double Space for date from 1 to 9 (Nov  3): \c"
read yday


MYPATH=/var/log/secure*
HOSTNAME=/var/log/auth.log*
MYPATH=/var/log/wtmp*

tuser=$(grep "$yday" $MYPATH | grep "Accepted|Failed" | who /var/log/wtmp | head -1 | awk '{print $3}'| wc -l)
suser=$(grep "$yday" $MYPATH | grep "Accepted password|Accepted publickey|keyboard-interactive" |  who /var/log/wtmp | head -1 | awk '{print $3}'| wc -l)
fuser=$(grep "$yday" $MYPATH | grep "Failed password" | wc -l)
scount=$(grep "$yday" $MYPATH | grep "Accepted" | awk -F: 'NR==1{ print $1 }' /etc/passwd | sort | uniq -c)
fcount=$(grep "$yday" $MYPATH | grep "Failed" | awk '{print $9;}' | sort | uniq -c)

echo "----------------"
echo "       User Access Report on: $yday"
echo "--------------------------------------------"
echo "Number of Users logged on System: $tuser"
echo "Successful logins attempt: $suser"
echo "Failed logins attempt: $fuser"
echo "--------------------------------------------"
echo -e "Success User Details:\n $scount"

echo "-------------------------"
echo -e "Failed User Details:\n $fcount"
echo "--------------------------------------------"
echo "--------------------------"
echo -e " ip address of login system:\n "
w -i
