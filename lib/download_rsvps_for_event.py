import requests
import os
from collections import Counter
import json
import glob
import time

key =  os.environ['MEETUP_API_KEY']

import sys
if len(sys.argv) < 2:
    print "Usage: python download_rsvps_for_event.py <event-id>"
    sys.exit(1)

event = sys.argv[1]
event_file = "data/rsvps/{0}.json".format(event)

results = []
uri = "https://api.meetup.com/2/rsvps?&event_id={0}&key={1}".format(event, key)

while True:
    if uri is None:
        break

    r = requests.get(uri)
    headers = r.headers
    remaining = int(headers["X-RateLimit-Remaining"])
    reset = int(headers["X-RateLimit-Reset"])
    print "-> <{0}> remaining: {1}, reset: {2}".format(event, remaining, reset)

    if remaining < 5:
        print "sleeping for {0} seconds".format(reset)
        time.sleep(reset)

    response = r.json()
    for result in response["results"]:
        results.append(result)
    uri = response["meta"]["next"] if response["meta"]["next"] else None
    
with(open(event_file, 'w')) as rsvps_file:
    json.dump(results, rsvps_file)
