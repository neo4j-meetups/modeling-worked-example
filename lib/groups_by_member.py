import requests
import os
import json
from py2neo import authenticate, Graph
import sys

if __name__ == "__main__":
    # member_id = "19057581"
    member_id = sys.argv[1]

    key =  os.environ['MEETUP_API_KEY']
    uri = "https://api.meetup.com/2/groups?lat=51.5072&lon=0.1275&member_id={0}&key={1}".format(member_id, key)

    r = requests.get(uri)
    results = r.json()["results"]

    group_ids = [str(item["id"]) for item in results]
    print "Group ids for {0}".format(member_id)
    print "{0}".format(group_ids)

    authenticate("localhost:7474", "neo4j", "medium")
    graph = Graph()
    rows = graph.cypher.execute(
    """
        MATCH (g:Group) WHERE g.id IN {group_ids}
        MATCH (m:Member {id: {member_id}})
        WHERE NOT (m)-[:MEMBER_OF]->(g)
        RETURN g.id AS groupId, g.name as groupName
    """, {"group_ids": group_ids, "member_id": str(member_id)})

    print ""
    print "Groups you aren't currently a member of:"
    print rows

    graph.cypher.execute(
    """
        MATCH (g:Group) WHERE g.id IN {group_ids}
        MATCH (m:Member {id: {member_id}}) WHERE NOT (m)-[:MEMBER_OF]->(g)
        MERGE (m)-[membershipRel:MEMBER_OF]->(g)
        ON CREATE SET membershipRel.joined = timestamp()
    """, {"group_ids": group_ids, "member_id": str(member_id)})
