CREATE INDEX ON :Group(id);
CREATE INDEX ON :Group(name);

// initial version
// LOAD CSV WITH HEADERS FROM "file:///Users/markneedham/projects/meetups/modeling-worked-example/data/groups.csv" AS row
// CREATE (:Group { id:row.id,
//                  name:row.name,
//                  urlname:row.urlname,
//                  rating:row.rating,
//                  link:row.link,
//                  created:toint(row.created) });


// idempotent version

// LOAD CSV WITH HEADERS FROM "file:///Users/markneedham/projects/meetups/modeling-worked-example/data/groups.csv" AS row

export base=${PWD}

LOAD CSV WITH HEADERS FROM "file:///Users/markneedham/projects/meetups/modeling-worked-example/data/groups.csv" AS row
MERGE (group:Group { id:row.id})
SET group.name = row.name,
    group.urlname = row.urlname,
    group.rating =row.rating,
    group.link = row.link,
    group.created = toint(row.created);
