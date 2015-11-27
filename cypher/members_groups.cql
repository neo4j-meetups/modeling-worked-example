return "Importing (member)-[:MEMBER_OF]->(group)";

LOAD CSV WITH HEADERS FROM "file:///members.csv" AS row
WITH row WHERE NOT row.joined is null
MATCH (member:Member {id: row.id})
MATCH (group:Group {id: row.groupId})
MERGE (member)-[:MEMBER_OF {joined: toint(row.joined)}]->(group);
