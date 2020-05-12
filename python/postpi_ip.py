#!/usr/bin/python

import sys, requests ,json ,time

url = "https://iot.ariba.org.in/api/devices/"
ttime = time.strftime("%Y-%m-%dT%H:%M:%S")

print('Getting Data-GET:')
res=requests.get(url +"1",verify=False)

if ( res.status_code ==200 or res.status_code == 201 ):
   print(url +'1 -data fetched. ')
else:
    print('Error Accessing '+ url +',err code:'+ str(res.status_code))
    sys.exit(1)

#print len(sys.argv)
if len(sys.argv[1]) != 0:
  print(ttime + ' Name :'+sys.argv[1])
else:
  print(ttime +" No data provided!")
  sys.exit(1)
if len(sys.argv) > 3:
  wlanip=sys.argv[3]
else:
  wlanip=''



#Post request with updated data.
d1=res.json()
d1['name']=sys.argv[1]
d1['ip']=sys.argv[2]
d1['value1']=wlanip
d1['value2']=sys.argv[2]
d1['last_upd']=ttime
headers={'content-type':'application/json'}
print('Updating Data-PUT:')

res2=requests.put(url+'1',data=json.dumps(d1),headers=headers,stream=False,verify=False)

if res2.status_code <= 221:
  print(ttime +' Update put done! with  '+ str(res2.status_code))
else:
   print(ttime +' Error Put '+ url + ', err : '+ str(res2.status_code))
   sys.exit(1)
