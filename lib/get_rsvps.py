import requests
import os
from collections import Counter
import json
import glob

key =  os.environ['MEETUP_API_KEY']

event_ids = []
for event_file_path in glob.glob("data/events/*.json"):
    with open(event_file_path) as event_file:
        events_json = json.load(event_file)
        event_ids += [str(event['id']) for event in events_json]

for event in event_ids:
    event_file = "data/rsvps/{0}.json".format(event)
    if os.path.isfile(event_file):
        continue
    else:
        print event

    # results = []
    # uri = "https://api.meetup.com/2/rsvps?&event_id={0}&key={1}".format(event, key)
    #
    # while True:
    #     if uri is None:
    #         break
    #     response = requests.get(uri).json()
    #     for result in response["results"]:
    #         results.append(result)
    #     uri = response["meta"]["next"] if response["meta"]["next"] else None
    # with(open(event_file, 'w')) as rsvps_file:
    #     json.dump(results, rsvps_file)
