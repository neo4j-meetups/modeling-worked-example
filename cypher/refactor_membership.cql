CREATE INDEX ON :Membership(id);

// create membership nodes
MATCH (member:Member)-[rel:MEMBER_OF]->(group)

MERGE (membership:Membership {id: member.id + "_" + group.id})
SET membership.joined = rel.joined

MERGE (member)-[:HAS_MEMBERSHIP]->(membership)
MERGE (membership)-[:OF_GROUP]->(group);

// add NEXT relationships
MATCH (member:Member)-[:HAS_MEMBERSHIP]->(membership)

WITH member, membership ORDER BY member.id, membership.joined

WITH member, COLLECT(membership) AS memberships
UNWIND RANGE(0,SIZE(memberships) - 2) as idx

WITH memberships[idx] AS m1, memberships[idx+1] AS m2
MERGE (m1)-[:NEXT]->(m2);
