#!/usr/bin/python

import sys, requests ,json ,time

url = "https://iot.ariba.org.in/api/devices/"
ttime = time.strftime("%Y-%m-%dT%H:%M:%S")

#print sys.argv[1]
if len(sys.argv[1]) != 0:
  print(ttime + ' IP:'+sys.argv[1] )
else:
  print(ttime +" No data provided!")
  sys.exit(1)

res=requests.get(url +"1",verify=False)

if ( res.status_code ==200 or res.status_code == 201 ):
   print(url +' -data fetched. ')
else:
    print('Error Accessing '+ url +',err code:'+ str(res.status_code))
    sys.exit(1)

#Post request with updated data.
d1=res.json()
d1['ip']=sys.argv[1]
d1['last_upd']=ttime
headers={'content-type':'application/json'}
res2=requests.put(url+'1',data=json.dumps(d1),headers=headers,stream=False,verify=False)

if res2.status_code <= 221:
  print(ttime +' Update put done! with  '+ str(res2.status_code))
else:
   print(ttime +' Error Put '+ url + ', err : '+ str(res2.status_code))
   sys.exit(1)
