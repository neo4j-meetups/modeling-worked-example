import requests
import os
from collections import Counter
import json

def chunks(l, n):
    """Yield successive n-sized chunks from l."""
    for i in xrange(0, len(l), n):
        yield l[i:i+n]

key =  os.environ['MEETUP_API_KEY']

with open('data/groups.json') as group_file:
    groups_json = json.load(group_file)

groups = [str(group['id']) for group in groups_json]

for group in groups:
    print "processing group {0}".format(group)
    results = []
    uri = "https://api.meetup.com/2/members?&group_id={0}&lat=51.5072&lon=0.1275&key={1}".format(str(group), key)
    while True:
        if uri is None:
            break
        response = requests.get(uri).json()
        for result in response["results"]:
            results.append(result)
        uri = response["meta"]["next"] if response["meta"]["next"] else None
    with(open("data/members/{0}.json".format(group), 'w')) as members_file:
        json.dump(results, members_file)
