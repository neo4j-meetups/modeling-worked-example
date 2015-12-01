// find which people went to the same events as me
// Cypher version: CYPHER 2.3, planner: COST. 22353 total db hits in 218 ms.
// match (m1:Member {name: "Mark Needham"})-[:RSVPD {response:"yes"}]->(event)<-[:RSVPD {response: "yes"}]-(m2),
//       (group)-[:HOSTED_EVENT]->(event)
// RETURN m1, m2, COUNT(*) AS times
// ORDER BY times DESC

// refactor to RSVP_NO / RSVP_YE
match (m:Member)-[rsvp:RSVPD {response:"yes"}]->(event)
merge (m)-[rsvpYes:RSVP_YES {id: rsvp.id}]->(event)
ON CREATE SET rsvpYes.created = rsvp.created, rsvpYes.lastModified = rsvp.lastModified;

match (m:Member)-[rsvp:RSVPD {response:"no"}]->(event)
merge (m)-[rsvpYes:RSVP_NO {id: rsvp.id}]->(event)
ON CREATE SET rsvpYes.created = rsvp.created, rsvpYes.lastModified = rsvp.lastModified;

// find which people went to the same events as me
// Cypher version: CYPHER 2.3, planner: COST. 7933 total db hits in 109 ms.
// match (m1:Member {name: "Mark Needham"})-[:RSVP_YES]->(event)<-[:RSVP_YES]-(m2),
//       (group)-[:HOSTED_EVENT]->(event)
// RETURN m1, m2, COUNT(*) AS times
// ORDER BY times DESC


// people who went to 5 or more of the same events as me
// match (m1:Member {name: "Mark Needham"})-[:RSVP_YES]->(event)<-[:RSVP_YES]-(m2)
// WITH m1, m2, COLLECT(event) AS events, COUNT(*) AS times
// WHERE times >= 5
// WITH m1, m2, times, [event IN events | SIZE((event)<-[:RSVP_YES]-())] AS attendances
// RETURN m1, m2, REDUCE(score = 0.0, attendance IN attendances | score + (1.0 / attendance)) AS score
// ORDER BY score DESC

// add the FRIENDS relationship
// match (m1:Member)-[:RSVP_YES]->(event)<-[:RSVP_YES]-(m2)
// WITH m1, m2, COLLECT(event) AS events, COUNT(*) AS times
// WHERE times >= 5
// WITH m1, m2, times, [event IN events | SIZE((event)<-[:RSVP_YES]-())] AS attendances
// WITH m1, m2, REDUCE(score = 0.0, attendance IN attendances | score + (1.0 / attendance)) AS score
// MERGE (m1)-[friendsRel:FRIENDS]->(m2)
// SET friendsRel.score = score
