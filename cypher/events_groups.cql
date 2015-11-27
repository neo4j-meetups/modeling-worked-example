LOAD CSV WITH HEADERS FROM "file:///events.csv" AS row
MATCH (group:Group {id: row.group_id})
MATCH (event:Event {id: row.id})
MERGE (group)-[:HOSTED_EVENT]->(event);
