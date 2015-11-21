// Topics that I'm interested in and follow groups focused on that
MATCH (member:Member {name: "Mark Needham"})-[:INTERESTED_IN]->(topic),
      (member)-[:MEMBER_OF]->(group)-[:HAS_TOPIC]->(topic)
RETURN member, topic, COUNT(*) AS times
ORDER BY times DESC
