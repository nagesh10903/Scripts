#!/usr/bin/python

#######################################
# Script to Control the Devices using lirc-web IR remote control.  
#
######################################

import requests, sys, time

#URL = "http://192.168.0.104/remotes/PG01_R01/"
URL = "http://localhost/remotes/PG01_R01/"

control_devices = {'LIGHT': "LIGHT_3",
                'FAN': "FAN_2",
                'BEDLAMP': "LIGHT_5" }

control_action = {"ON":"ON","OFF":"OFF"}   

#print(sys.argv[1]+ ' is '+ sys.argv[2] +', args='+ str(len(sys.argv)))

if(len(sys.argv) <= 3 or len(sys.argv) == 2) and sys.argv[1].upper() in control_devices:
    device = control_devices[sys.argv[1].upper()]
    action = control_action[sys.argv[2].upper()] 
#    print('Ok params ') 
else:
    print('usage: sudo ./onoff.py [LIGHT|FAN|BEDLAMP] [ON|OFF] ')
    sys.exit(1)

URL = URL+device+"_"+action
#print URL
device_action = requests.post(URL)

ttime = time.strftime("%Y-%m-%dT%H:%M:%S")
if device_action.status_code <= 221:
   print(ttime +': '+sys.argv[1]+ ' is '+ sys.argv[2])
else:
   print(ttime +' Error Put '+ URL + ', err : '+ str(device_action.status_code))
   sys.exit(1)

