CREATE INDEX ON :Group(id)
CREATE INDEX ON :Group(name)

LOAD CSV WITH HEADERS FROM "file:///Users/markneedham/projects/meetups/modeling-worked-example/data/groups.csv" AS row
CREATE (:Group { id:row.id,
                 name:row.name,
                 urlname:row.urlname,
                 rating:row.rating,
                 link:row.link,
                 created:toint(row.created) });
