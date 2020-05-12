#!/usr/bin/python
import sys
import Adafruit_DHT
import time

# Parse command line parameters.
sensor_args = { '11': Adafruit_DHT.DHT11,
                '22': Adafruit_DHT.DHT22,
                '2302': Adafruit_DHT.AM2302 }
fpath = "/home/pi/data/dth11/"
if ( len(sys.argv) == 3 or len(sys.argv)==4 ) and sys.argv[1] in sensor_args:
    sensor = sensor_args[sys.argv[1]]
    pin = sys.argv[2]
    fname = sys.argv[3] 
else:
#    print('usage: sudo ./DHT.py [11|22|2302] GPIOpin#')
    sys.exit(1)

#Retry  15 times to get a sensor reading (waiting 2 seconds between each retry).
humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
ttime = time.strftime("%Y-%m-%d %H:%M")
fname = fpath + fname
f = open(fname,"a")
# Un-comment the line below to convert the temperature to Fahrenheit.
#tfahren = temperature * 9/5.0 + 32

if humidity is not None and temperature is not None:
    f = open(fname,"a")
    data = '{0}   {1:0.2f}C  {2:0.2f}%'.format(ttime,temperature, humidity)
    print data
    f.write(data + "\n")
    f.close() 
else:
    print('Failed to get reading. Try again!')
    sys.exit(1)
