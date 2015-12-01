import requests
import json
from py2neo import authenticate, Graph

def stream_meetup():
    r = requests.get('http://stream.meetup.com/2/rsvps', stream=True)
    for raw_rsvp in r.iter_lines():
        if raw_rsvp:
            yield raw_rsvp

authenticate("localhost:7474", "neo4j", "medium")
graph = Graph()

group_ids = []
for row in graph.cypher.execute("MATCH (g:Group) RETURN g.id AS groupId"):
    group_ids.append(int(row["groupId"]))

for raw_rsvp in stream_meetup():
    # print raw_rsvp
    try:
        rsvp = json.loads(raw_rsvp)
    except ValueError as e:
        print e
        continue

    group_id = rsvp["group"]["group_id"]
    print "{0}:{1}".format(group_id, group_id in group_ids)

    if group_id in group_ids:
        params = {
            "rsvp_id": str(rsvp["rsvp_id"]),
            "event_id": str(rsvp["event"]["event_id"]),
            "member_id": str(rsvp["member"]["member_id"]),
            "response": rsvp["response"],
            "mtime": rsvp["mtime"]
        }

        print "Processing RSVP: {0}".format(params)

        if rsvp["response"] == "yes":
            graph.cypher.execute("""
                MATCH (event:Event {id: {event_id}})
                MATCH (member:Member {id: {member_id}})
                MERGE (member)-[rsvpRel:RSVPD {id: {rsvp_id}}]->(event)
                ON CREATE SET rsvpRel.created = toint({mtime})
                ON MATCH  SET rsvpRel.lastModified = toint({mtime})
                SET rsvpRel.response = {response}

                MERGE (member)-[rsvpYes:RSVP_YES {id: {rsvp_id}}]->(event)
                ON CREATE SET rsvpYes.created = toint({mtime})
                ON MATCH  SET rsvpYes.lastModified = toint({mtime})
                SET rsvpYes.response = {response}

                WITH member, event
                MATCH (member)-[oldRSVP:RSVP_NO]->(event)
                DELETE oldRSVP
            """, params)
        else:
            graph.cypher.execute("""
                MATCH (event:Event {id: {event_id}})
                MATCH (member:Member {id: {member_id}})
                MERGE (member)-[rsvpRel:RSVPD {id: {rsvp_id}}]->(event)
                ON CREATE SET rsvpRel.created = toint({mtime})
                ON MATCH  SET rsvpRel.lastModified = toint({mtime})
                SET rsvpRel.response = {response}

                MERGE (member)-[rsvpNo:RSVP_NO {id: {rsvp_id}}]->(event)
                ON CREATE SET rsvpNo.created = toint({mtime})
                ON MATCH  SET rsvpNo.lastModified = toint({mtime})
                SET rsvpNo.response = {response}

                WITH member, event
                MATCH (member)-[oldRSVP:RSVP_YES]->(event)
                DELETE oldRSVP
            """, params)
