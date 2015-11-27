return "Importing topics";

CREATE INDEX ON :Topic(id);

LOAD CSV WITH HEADERS FROM "file:///groups_topics.csv" AS row
MERGE (topic:Topic {id: row.id})
ON CREATE SET topic.name = row.name,
              topic.urlkey = row.urlkey;
