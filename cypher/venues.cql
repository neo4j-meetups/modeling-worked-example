CREATE INDEX ON :Venue(id);
CREATE INDEX ON :Venue(name);

LOAD CSV WITH HEADERS FROM "file:///venues.csv" AS row
MERGE (venue:Venue {id: row.id})
ON CREATE SET venue.name = row.name,
              venue.city = row.city,
              venue.address1 = row.address_1,
              venue.address2 = row.address_2,
              venue.lat = tofloat(row.lat),
              venue.lon = tofloat(row.lon);
