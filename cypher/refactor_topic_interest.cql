match (m:Member)-[:RSVPD {response:"yes"}]->(event)<-[:HOSTED_EVENT]->()-[:HAS_TOPIC]->(topic)
WITH m, topic, COUNT(*) AS times, COLLECT(event.name) AS events WHERE times > 5 AND NOT (m)-[:INTERESTED_IN]->(topic)
MERGE (m)-[:INTERESTED_IN]->(topic)
