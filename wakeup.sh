#!/bin/bash

sudo python /home/pi/Scripts/python/ir_devices.py  LIGHT ON   >>/tmp/r_devices.log
sleep 2
sudo python /home/pi/Scripts/python/ir_devices.py  FAN  OFF   >>/tmp/r_devices.log

#sudo /home/pi/Scripts/speech/speech.sh `date +"Good Morning Today's date is %A %d %B %Y"`
#sudo /home/pi/Scripts/speech.sh 
