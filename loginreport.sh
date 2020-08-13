#!/bin/bash

AUTHLOG=/var/log/secure

if [[ -n $1 ]];
then
  AUTHLOG=$1
  echo Using Log file : $AUTHLOG
fi


FAILED_LOG=/tmp/failed.$$.log
egrep "Failed pass" $AUTHLOG > $FAILED_LOG 


SUCCESS_LOG=/tmp/success.$$.log
egrep "Accepted password|Accepted publickey|keyboard-interactive" $AUTHLOG > $SUCCESS_LOG


failed_users=$(cat $FAILED_LOG | awk '{ print $(NF-5) }' | sort | uniq)


success_users=$(cat $SUCCESS_LOG | awk '{ print $(NF-5) }' | sort | uniq)

failed_ip_list="$(egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" $FAILED_LOG | sort | uniq)"
success_ip_list="$(egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" $SUCCESS_LOG | sort | uniq)"


printf "%-10s|%-10s|%-10s|%-15s|%-15s|%s\n" "status" "User" "Attempts" "IP address" "Host" "Time range"



for ip in $failed_ip_list;
do
  for user in $failed_users;
    do
   IP
    attempts=`grep $ip $FAILED_LOG | grep " $user " | wc -l`

    if [ $attempts -ne 0 ]
    then
      first_time=`grep $ip $FAILED_LOG | grep " $user " | head -1 | cut -c-16`
      time="$first_time"
      if [ $attempts -gt 1 ]
      then
        last_time=`grep $ip $FAILED_LOG | grep " $user " | tail -1 | cut -c-16`
        time="$first_time -> $last_time"
      fi
      HOST=$(host $ip 8.8.4.4 | tail -1 | awk '{ print $NF }' )
      printf "%-10s|%-10s|%-10s|%-15s|%-15s|%-s\n" "Failed" "$user" "$attempts" "$ip"  "$HOST" "$time";
    fi
  done
done

for ip in $success_ip_list;
do
  for user in $success_users;
    do
    
    attempts=`grep $ip $SUCCESS_LOG | grep " $user " | wc -l`

    if [ $attempts -ne 0 ]
    then
      first_time=`grep $ip $SUCCESS_LOG | grep " $user " | head -1 | cut -c-16`
      time="$first_time"
      if [ $attempts -gt 1 ]
      then
        last_time=`grep $ip $SUCCESS_LOG | grep " $user " | tail -1 | cut -c-16`
        time="$first_time -> $last_time"
      fi
      HOST=$(host $ip 8.8.4.4 | tail -1 | awk '{ print $NF }' )
      printf "%-10s|%-10s|%-10s|%-15s|%-15s|%-s\n" "Success" "$user"  "$attempts" "$ip"  "$HOST" "$time";
    fi
  done
done
