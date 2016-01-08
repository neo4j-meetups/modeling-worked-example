load csv from "file:///dups.csv" AS row
WITH split(row[0], ";") as duplicates

WITH duplicates[0] AS first, duplicates[1..] AS rest
UNWIND rest AS row

MATCH (v1:Venue {id: first})
MATCH (v2:Venue {id: row})
OPTIONAL MATCH (v2)<-[hostedAt:HOSTED_AT]-(event)
MERGE (v1)<-[:HOSTED_AT]-(event)
MERGE (v2)-[:ALIAS_OF]->(v1)
DELETE hostedAt;
