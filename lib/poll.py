import requests
import json

uri = "http://stream.meetup.com/2/rsvps"

response = requests.get(uri, stream = True)

for chunk in response.iter_content(chunk_size = None):
    if chunk:
        print chunk
        jsonified = json.loads(chunk)
        print jsonified
