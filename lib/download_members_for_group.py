import requests
import os
from collections import Counter
import json

import sys
if len(sys.argv) < 2:
    print "Usage: python download_members_for_groups.py <group-id>"
    sys.exit(1)

group = sys.argv[1]
members_file = "data/members/{0}.json".format(group)

key =  os.environ['MEETUP_API_KEY']
lat = "51.5072"
lon = "0.1275"

print "processing group {0}".format(group)
results = []
uri = "https://api.meetup.com/2/members?&group_id={0}&lat={1}&lon={2}&key={3}".format(str(group),lat,lon, key)
while True:
    if uri is None:
        break
    r = requests.get(uri)

    headers = r.headers
    remaining = headers["X-RateLimit-Remaining"]
    reset = headers["X-RateLimit-Reset"]
    print "-> remaining: {0}, reset: {1}".format(remaining, reset)

    response = r.json()
    for result in response["results"]:
        results.append(result)
    uri = response["meta"]["next"] if response["meta"]["next"] else None

with(open(members_file, 'w')) as members_file:
    json.dump(results, members_file)
