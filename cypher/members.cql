return "Importing members";

CREATE INDEX ON :Member(id);
CREATE INDEX ON :Member(name);

LOAD CSV WITH HEADERS FROM "file:///members.csv" AS row
WITH DISTINCT row.id AS id, row.name AS name
MERGE (member:Member {id: id})
ON CREATE SET member.name = name;
