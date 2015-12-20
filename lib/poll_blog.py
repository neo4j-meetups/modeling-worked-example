import requests
import json

def stream_meetup_initial():
    uri = "http://stream.meetup.com/2/rsvps"
    response = requests.get(uri, stream = True)
    buffer = ""
    for chunk in response.iter_content(chunk_size = None):
        yield chunk

def stream_meetup_newline():
    uri = "http://stream.meetup.com/2/rsvps"
    response = requests.get(uri, stream = True)
    buffer = ""
    for chunk in response.iter_content(chunk_size = 1):
        if chunk.endswith("\n"):
            buffer += chunk
            yield buffer
            buffer = ""
        else:
            buffer += chunk

r = requests.get('http://stream.meetup.com/2/rsvps', stream=True)
for raw_rsvp in r.iter_lines():
    if raw_rsvp:
        rsvp = json.loads(raw_rsvp)
        print rsvp
