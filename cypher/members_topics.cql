return "Importing (member)-[:INTERESTED_IN]->(topic)";

USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM "file:///members.csv" AS row
WITH split(row.topics, ";") AS topics, row.id AS memberId
UNWIND topics AS topicId
MATCH (member:Member {id: memberId})
MATCH (topic:Topic {id: topicId})
MERGE (member)-[:INTERESTED_IN]->(topic);
