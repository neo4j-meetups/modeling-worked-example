CREATE INDEX ON :Event(id);
CREATE INDEX ON :Event(time);

LOAD CSV WITH HEADERS FROM "file:///events.csv" AS row
MERGE (event:Event {id: row.id})
ON CREATE SET event.name = row.name,
              event.time = toint(row.time),
              event.utcOffset = toint(row.utc_offset);
