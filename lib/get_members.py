import requests
import os
from collections import Counter
import json

key =  os.environ['MEETUP_API_KEY']
lat = "51.5072"
lon = "0.1275"

with open('data/groups.json') as group_file:
    groups_json = json.load(group_file)

groups = [str(group['id']) for group in groups_json]

for group in groups:
    members_file = "data/members/{0}.json".format(group)
    if os.path.isfile(members_file):
        continue
    else:
        print group
