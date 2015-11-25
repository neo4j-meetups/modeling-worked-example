LOAD CSV WITH HEADERS FROM "file:///Users/markneedham/projects/meetups/modeling-worked-example/data/groups_topics.csv" AS row
MATCH (topic:Topic {id: row.id})
MATCH (group:Group {id: row.groupId})
MERGE (group)-[:HAS_TOPIC]->(topic);
