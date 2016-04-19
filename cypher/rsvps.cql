LOAD CSV WITH HEADERS FROM "file:///rsvps.csv" AS row
WITH row WHERE row.response = "yes"

MATCH (member:Member {id: row.member_id})
MATCH (event:Event {id: row.event_id})
MERGE (member)-[rsvp:RSVPD {id: row.rsvp_id}]->(event)
ON CREATE SET rsvp.created = toint(row.created), rsvp.lastModified = toint(row.mtime);

// MATCH (topic1:Topic)-[similar:SIMILAR]->(topic2:Topic)
// WITH  topic1,
//       topic2,
//       similar,
//       SIZE((topic1)<-[:HAS_TOPIC]-()) AS topic1Total,
//       SIZE((topic2)<-[:HAS_TOPIC]-()) AS topic2Total
// WITH topic1,
//      topic2,
//      toFloat(similar.total) / toFloat(topic1Total + topic2Total) AS score,
//      similar
// SET similar.score = score;
