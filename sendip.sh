#!/bin/bash

SDATE=`date +%d-%m-%Y-%H:%M:%S`
EMAIL_ADDR=nagesh10903@gmail.com
OLDIP=test
if [[ -f "/tmp/.exipaddress" ]]
then
OLDIP=$(cat /tmp/.exipaddress)
fi
#echo "fetching ip"
#NEWIP=$(curl -s http://myexternalip.com/raw)
NEWIP=$(curl -s ifconfig.me)
#echo $OLDIP  $NEWIP
if [[ "$NEWIP" != "$OLDIP" ]]
then
  echo $NEWIP | tee /tmp/.exipaddress
  echo "$NEWIP" | mail -s " Airtel IP OLD: $OLDIP , NEW: $NEWIP " $EMAIL_ADDR
  sudo python /home/pi/Scripts/python/postip.py  $NEWIP
fi
echo "$SDATE  OLDIP:$OLDIP , NEWIP:$NEWIP"  
 
