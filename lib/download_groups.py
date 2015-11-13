import requests
import os
from collections import Counter
import json

key =  os.environ['MEETUP_API_KEY']

seed_topic = "nosql"
uri = "https://api.meetup.com/2/groups?&topic={0}&lat=51.5072&lon=0.1275&key={1}".format(seed_topic, key)

r = requests.get(uri)
all_topics = [topic["urlkey"]  for result in r.json()["results"] for topic in result["topics"]]
c = Counter(all_topics)

topics = [entry[0] for entry in c.most_common(10)]

groups = {}
for topic in topics:
    uri = "https://api.meetup.com/2/groups?&topic={0}&lat=51.5072&lon=0.1275&key={1}".format(topic, key)
    r = requests.get(uri)
    for group in r.json()["results"]:
        groups[group["id"]] = group

with open('groups.json', 'w') as groups_file:
    json.dump(groups.values(), groups_file)
