#!/bin/bash

###############################
# Script to boot the PC Using  Raspbery pi, 
# and to check if any system is active/On.
# Raspbery Pi GPIO Pin : 16 (Phy)/ 27 Wir pi/ 16 (BCM)
# 
# 
###############################

PiGPIO=27  # Wiring Pi =27  , Physical Pin =16
PCIPS=201,102    # List of IP's or Multiple Ips
SUBNET=192.168.0.
IP=LOCAL
OPR=BOOT

function usage()
{

echo "Usage: startpc [-s <ip4[,ip4]...>] [-l <ocants[,octant]...>]"
echo
echo " Default:Boots PC"
echo " -s <IPs> :Status of System in CSV IP list"
echo " -l <lastoctant> :Status of IP's in subnet $SUBNET"
echo
exit
}

#Get the list of Ips from command line or set  it to default
function getips()
{
# Check command line args

case "$1" in

-s) OPR=STATUS
    if [[ "$2" == "" ]]
    then
      usage
    else
      IP=GLOBAL
      PCIPS=$2
    fi
    ;;

-l)OPR=STATUS 
   if [[ "$2" == "" ]]
    then
    usage
    else
    PCIPS=$2
    fi
    ;;
-O) OPR=OFF
   ;;
*) if [[ "$1" != "" ]]
   then
     usage
   fi
   ;;
esac

}


# Switching/Triggering the Power button
function presspowerbtn()
{
#echo "param- btn- $1"
sudo gpio mode $1 OUT
sudo gpio write  $1  1 && sleep 2 && sudo gpio write  $1  0
sudo gpio mode $1 IN
}

# Check  System is ON/OFF
function checkonoff()
{
#echo "param- on/off- $1"
  ping -W 1 -c 1 $1 > /dev/null
  if [ $? -eq 0 ]
   then
   echo "Your Computer ($1) is Active"
   return 0
  else
   return -1
  fi
}

getips $@

# set the IP array

ar_ip=(${PCIPS//,/ })
#echo ${arr[@]}

for ip in "${ar_ip[@]}" 
do
#echo "param- ip- ${ip}"
if  [[ "$IP" == "LOCAL"  ]] 
then
 ip=${SUBNET}${ip}
fi


checkonoff ${ip}
chk_status=$?
#echo "ch st - $chk_status"
  if [[ $chk_status == 0 ]]
  then
  if [[ "$OPR" == "BOOT" || "$OPR" == "OFF"  ]]
   then
    #echo "The System is Switched On"
    break
   fi
   if [[ "$OPR" == "STATUS"  ]]
   then
    PC_OS=`sudo nmap -O $1 | grep "^OS details" | awk -F':' '{print $2}'`
    echo "Curently Running $PC_OS"
   fi
  fi
done

if [[ "$OPR" == "STATUS" ]]
then
 exit
fi

#echo "sdf $chk_status"

if [[ $chk_status == 0 ]]
then
  echo "The System is Switched On."
 if [[ "$OPR" == "OFF" ]]
 then
  echo "Sending Switching Off Trigger"
 else
   exit
 fi
else
  echo "The System is OFF.."
 if [[ "$OPR" == "BOOT"  ]]
 then
  echo "Booting the Computer"
 else
  exit
 fi
fi
# Sending Trigger signal - pressing Power button
 presspowerbtn $PiGPIO

