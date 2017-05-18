import requests
import os
import json

from collections import Counter
from pprint import pprint

key =  os.environ['MEETUP_API_KEY']
lat = os.getenv('LAT', "51.5072")
lon = os.getenv('LON', "0.1275")

seed_topic = "nosql"
uri = "https://api.meetup.com/2/groups?&topic={0}&lat={1}&lon={2}&key={3}".format(seed_topic, lat, lon, key)

r = requests.get(uri)
all_topics = [topic["urlkey"]  for result in r.json()["results"] for topic in result["topics"]]
c = Counter(all_topics)

topics = [entry[0] for entry in c.most_common(10)]

print(topics)

groups = {}
for topic in topics:
    print(topic)
    uri = "https://api.meetup.com/2/groups?&topic={0}&lat={1}&lon={2}&key={3}".format(topic, lat, lon, key)
    r = requests.get(uri)
    try:
        result = r.json()["results"]
        for group in result:
            groups[group["id"]] = group
    except ValueError:
        print("Skipping {0}".format(topic))        

with open('data/groups.json', 'w') as groups_file:
    json.dump(groups.values(), groups_file, indent=4, sort_keys=True)
