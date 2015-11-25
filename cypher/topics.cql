CREATE INDEX ON :Topic(id)

LOAD CSV WITH HEADERS FROM "file:///Users/markneedham/projects/meetups/modeling-worked-example/data/groups_topics.csv" AS row
MERGE (topic:Topic {id: row.id})
ON CREATE SET topic.name = row.name,
              topic.urlkey = row.urlkey;
