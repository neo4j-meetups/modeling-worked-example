from py2neo import authenticate, Graph

authenticate("localhost:7474", "neo4j", "medium")
graph = Graph()

while True:
    rows = graph.cypher.execute(
    """
	MATCH (m1:Member)
	WHERE NOT m1:Processed
	WITH m1 LIMIT {limit}
	MATCH (m1)-[:RSVP_YES]->(event:Event)<-[:RSVP_YES]-(m2:Member)
	WITH m1, m2, COLLECT(event) AS events, COUNT(*) AS times
	WHERE times >= 5
	WITH m1, m2, times, [event IN events | SIZE((event)<-[:RSVP_YES]-())] AS attendances
    WITH m1, m2, REDUCE(score = 0.0, attendance IN attendances | score + (1.0 / attendance)) AS score
    return ID(m1) AS m1, ID(m2) AS m2, score
    """, {"limit": 100})

    if len(rows) == 0:
        break

    params = []
    for row in rows:
        params.append({"m1": row["m1"], "m2": row["m2"], "score": row["score"]})

    print "Processing {0} FRIENDS relationships".format(len(rows))
    graph.cypher.execute(
    """
    UNWIND {rows} AS row
    MATCH (m1), (m2)
    WHERE ID(m1) = row.m1 AND ID(m2) = row.m2
    MERGE (m1)-[friendsRel:FRIENDS]-(m2)
    SET friendsRel.score = row.score
    SET m1:Processed
    """, {"rows": params}
    )
