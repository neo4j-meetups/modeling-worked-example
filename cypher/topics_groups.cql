return "Importing (group)-[:HAS_TOPIC]->(topic)";

LOAD CSV WITH HEADERS FROM "file:///groups_topics.csv" AS row
MATCH (topic:Topic {id: row.id})
MATCH (group:Group {id: row.groupId})
MERGE (group)-[:HAS_TOPIC]->(topic);
