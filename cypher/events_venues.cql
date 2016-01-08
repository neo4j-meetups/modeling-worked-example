LOAD CSV WITH HEADERS FROM "file:///events.csv" AS row
MATCH (venue:Venue {id: row.venue_id})
MATCH (event:Event {id: row.id})
MERGE (event)-[:HOSTED_AT]->(venue);
