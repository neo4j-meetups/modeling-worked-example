return "Importing groups";

CREATE INDEX ON :Group(id);
CREATE INDEX ON :Group(name);

// initial version
// LOAD CSV WITH HEADERS FROM "file:///Users/markneedham/projects/meetups/modeling-worked-example/data/groups.csv" AS row
// CREATE (:Group { id:row.id,
//                  name:row.name,
//                  urlname:row.urlname,
//                  rating:toint(row.rating),
//                  created:toint(row.created) });


// idempotent version

// LOAD CSV WITH HEADERS FROM "file:///Users/markneedham/projects/meetups/modeling-worked-example/data/groups.csv" AS row

LOAD CSV WITH HEADERS FROM "file:///groups.csv" AS row
MERGE (group:Group { id:row.id})
SET group.name = row.name,
    group.urlname = row.urlname,
    group.rating = toint(row.rating),
    group.created = toint(row.created);
