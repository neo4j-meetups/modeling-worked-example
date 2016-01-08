import requests
import os
from collections import Counter
import json
from pprint import pprint

key =  os.environ['MEETUP_API_KEY']
lat = "51.5072"
lon = "0.1275"

seed_topic = "nosql"
uri = "https://api.meetup.com/2/groups?&topic={0}&lat={1}&lon={2}&key={3}".format(seed_topic, lat, lon, key)

r = requests.get(uri)
all_topics = [topic["urlkey"]  for result in r.json()["results"] for topic in result["topics"]]
c = Counter(all_topics)

topics = [entry[0] for entry in c.most_common(10)]

groups = {}
for topic in topics:
    uri = "https://api.meetup.com/2/groups?&topic={0}&lat={1}&lon={2}&key={3}".format(topic, lat, lon, key)
    r = requests.get(uri)
    for group in r.json()["results"]:
        groups[group["id"]] = group

with open('data/groups.json', 'w') as groups_file:
    json.dump(groups.values(), groups_file, indent=4, sort_keys=True)
