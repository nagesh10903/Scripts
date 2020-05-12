#!/usr/bin/python

import sys, requests ,json ,time ,Adafruit_DHT , socket

sensor_args = { '11': Adafruit_DHT.DHT11,
                '22': Adafruit_DHT.DHT22,
                '2302': Adafruit_DHT.AM2302 }
if ( len(sys.argv) == 3 or len(sys.argv)==4 ) and sys.argv[1] in sensor_args:
    sensor = sensor_args[sys.argv[1]]
    pin = sys.argv[2]
    fname = sys.argv[3] 
else:
#    print('usage: sudo ./postDHT.py [11|22|2302] GPIOpin#  filename')
    sys.exit(1)

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
url = "http://iot.ariba.org.in/api/devices/"
ttime = time.strftime("%Y-%m-%dT%H:%M:%S")
fpath = "/home/pi/data/dth11/"
wflag = 0
s.connect(('www.ariba.org.in', 0))
ip=s.getsockname()[0]
#Retry  15 times to get a sensor reading (waiting 2 seconds between each retry).
humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
ttime = time.strftime("%Y-%m-%d %H:%M")
fname = fpath + fname
f = open(fname,"a")
if humidity is not None and temperature is not None:
    f = open(fname,"a")
    data = '{0}   {1:0.2f}C  {2:0.2f}%'.format(ttime,temperature, humidity)
    print data
    f.write(data + "\n")
    f.close() 
    wflag = 1
else:
    print('Failed to get reading. Try again!')
    sys.exit(1)

# Post data to website restfull
res=requests.get(url +"3")

if ( res.status_code ==200 or res.status_code == 201 ) and wflag==1:
   print(url +'3 -data fetched' )
else:
    print('Error Accessing '+ url +',err code:'+ str(res.status_code))
    sys.exit(1)

#Post request with updated data.
d1=res.json()
dtemp = '{0:0.2f} C'.format(temperature)
dhumid = '{0:0.2f}%'.format(humidity)
d1['value1']=dtemp
d1['value2']=dhumid
d1['last_upd']=ttime
d1['ip']=ip
headers={'content-type':'application/json'}
res2=requests.put(url+'3',data=json.dumps(d1),headers=headers,stream=False)

if res2.status_code <= 221:
  print(ttime +' Update put done! with  '+ str(res2.status_code))
else:
   print(ttime +' Error Put '+ url + ', err : '+ str(res2.status_code))
   sys.exit(1)
