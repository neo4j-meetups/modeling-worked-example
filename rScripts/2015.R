library(RNeo4j)
library(ggplot2)
library(dplyr)
library(zoo)
library(scales)
library(reshape)

graph = startGraph("http://localhost:7474/db/data/", username = "neo4j", password = "medium")

query = "MATCH (:Group {name: {name}})<-[membership:MEMBER_OF]-()
         RETURN membership.joined AS timestamp"

joinedDF = cypher(graph, query, name = "Neo4j - London User Group")
joinedDF$joinDate = as.Date(as.POSIXct(joinedDF$timestamp / 1000, origin="1970-01-01"))

ggplot(aes(x = year, y = n, label = n), 
       data = joinedDF %>% mutate(year = format(joinDate, "%Y")) %>% count(year)) + 
  geom_bar(stat = "identity", fill = "Dark Blue") + 
  ggtitle("Number of new members by year") +
  geom_text(vjust=-0.5)

byYearMon = joinedDF %>% 
  filter(format(joinDate, "%Y") == 2015) %>% 
  mutate(yearmon = as.Date(as.yearmon(joinDate))) %>% 
  count(yearmon)

ggplot(aes(x = yearmon, y = n, label = n), data = byYearMon) + 
  geom_bar(stat = "identity", fill = "Dark Blue") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_x_date(labels = date_format("%B"), breaks = "1 month") +
  ggtitle("Number of new members by month/year")

eventsQuery = "MATCH (:Group {name: {name}})-[:HOSTED_EVENT]->(event)
               RETURN event.time + event.utcOffset AS timestamp"
eventsDF = cypher(graph, eventsQuery, name = "Neo4j - London User Group")
eventsDF$timestamp = as.Date(as.POSIXct(eventsDF$timestamp / 1000, origin="1970-01-01"))

ggplot(aes(x = year, y = n, label = n), data = eventsDF %>% mutate(year = format(timestamp, "%Y")) %>% count(year)) + 
  geom_bar(stat = "identity", fill = "Dark Blue") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Number of events")

eventsQuery = "MATCH (:Group {name: {name}})-[:HOSTED_EVENT]->(event)<-[:RSVPD {response: 'yes'}]-()
               WHERE event.time + event.utcOffset < timestamp()
               WITH event, COUNT(*) AS rsvps
               RETURN event.time + event.utcOffset AS timestamp, rsvps"
eventsDF = cypher(graph, eventsQuery, name = "Neo4j - London User Group")
eventsDF$timestamp = as.Date(as.POSIXct(eventsDF$timestamp / 1000, origin="1970-01-01"))

ggplot(aes(x = year, y = rsvps), 
       data = eventsDF %>% mutate(year = format(timestamp, "%Y")) %>% group_by(year) %>% summarise(rsvps= sum(rsvps)) ) + 
  geom_bar(stat = "identity", fill = "Dark Blue") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Number of attendees")


eventsByYearMon = eventsDF %>% 
  filter(format(joinDate, "%Y") == 2015) %>% 
  mutate(yearmon = as.Date(as.yearmon(joinDate))) %>% 
  count(yearmon) 

merge(eventsByYearMon, byYearMon, by="yearmon")

eventsQuery = "MATCH (:Group {name: {name}})-[:HOSTED_EVENT]->(event)
               WHERE {startYear} <= (event.time + event.utcOffset) < {endYear}
               RETURN event.name AS event, COUNT(*) AS times
               ORDER BY times DESC"
eventsDF = cypher(graph, eventsQuery, name = "Neo4j - London User Group", 
                  startYear  = as.numeric(as.POSIXct("2015-01-01", format="%Y-%m-%d")) * 1000, 
                  endYear = as.numeric(as.POSIXct("2015-12-31", format="%Y-%m-%d")) * 1000)
eventsDF %>% filter(times > 1)

eventsQuery = "MATCH (:Group {name: {name}})-[:HOSTED_EVENT]->(event)
               WHERE {startYear} <= (event.time + event.utcOffset) < {endYear}
               WITH event
               MATCH (event)<-[:RSVPD {response: 'yes'}]-()
               WITH event.id AS id, event.name AS event, COUNT(*) AS rsvps
               RETURN event, rsvps
               ORDER BY rsvps DESC"
eventsDF = cypher(graph, eventsQuery, name = "Neo4j - London User Group", 
                  startYear  = as.numeric(as.POSIXct("2015-01-01", format="%Y-%m-%d")) * 1000, 
                  endYear = as.numeric(as.POSIXct("2015-12-31", format="%Y-%m-%d")) * 1000)
eventsDF %>% head(5)

eventsQuery = "MATCH (:Group {name: {name}})-[:HOSTED_EVENT]->(event)<-[:RSVPD {response: 'yes'}]-()
               WITH event, COUNT(*) AS rsvps
               RETURN event.name AS event, event.time + event.utcOffset AS time, rsvps
               ORDER BY rsvps DESC"
eventsDF = cypher(graph, eventsQuery, name = "Neo4j - London User Group")
eventsDF$time = as.Date(as.POSIXct(eventsDF$time / 1000, origin="1970-01-01"))
eventsDF %>% mutate(year = format(time, "%Y")) %>% dplyr::select(-time) %>% head(10)
