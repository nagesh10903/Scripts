#!/usr/bin/python

import sys, requests ,json ,time, os

url = "https://iot.ariba.org.in/api/devices/"
ttime = time.strftime("%Y-%m-%dT%H:%M:%S")
resp=1

def check_ping(hostname):
    response = os.system("ping -c 2 -q -w 5 " + hostname)
    # and then check the response...
    if response == 0:
       return 0
    else:
       return -1



#print len(sys.argv)
if len(sys.argv[1]) != 0:
  print(ttime + ' Name :'+sys.argv[1])
else:
  print(ttime +" No hostname  provided!")
  sys.exit(1)
if len(sys.argv) > 1:
  wlanip=sys.argv[1]
  resp=check_ping(wlanip)
else:
  wlanip=''
  resp=-1

res=requests.get(url +"9")  # 9: to check Power supply

if ( res.status_code ==200 or res.status_code == 201 ):
   print(url +'9 -data fetched. ')
else:
    print('Error Accessing '+ url +',err code:'+ str(res.status_code))
    sys.exit(1)

ntime= time.strftime("%H:%M:%S")
#Post request with updated data.
d1=res.json()
if resp==0:
   d1['value1']=ntime
   d1['status']="ON"
else :
   d1['value2']=ntime  
   d1['status']="OFF"
d1['ip']=wlanip
d1['last_upd']=ttime
headers={'content-type':'application/json'}
res2=requests.put(url+'9',data=json.dumps(d1),headers=headers,stream=False,verify=False)

if res2.status_code <= 221:
  print(ttime +' Update put done! with  '+ str(res2.status_code))
else:
   print(ttime +' Error Put '+ url + ', err : '+ str(res2.status_code))
   sys.exit(1)
