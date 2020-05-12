import json,requests

url = 'http://myexternalip.com/raw'
r = requests.get(url)
ip = r.text

try:
    from urlparse import urlparse
except ImportError:
    from urllib.parse import urlparse

headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8'
}

uri = 'http://iot.ariba.org'
path = '/api/devices/1'

rdev = requests.get(uri+path)

# assume that content is a json reply
# parse content with the json module
data = rdev.json()
