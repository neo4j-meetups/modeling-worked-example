#!/bin/sh

# NEO="neo4j-community-2.3.2"
NEO="neo4j-enterprise-3.0.0-RC1"

echo ${PWD}

./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/groups.cql
./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/topics.cql
./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/topics_groups.cql
./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/members.cql
./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/members_groups.cql
./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/members_topics.cql

./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/venues.cql

./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/events.cql
./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/events_groups.cql
./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/events_venues.cql

./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/rsvps.cql

./${NEO}/bin/neo4j-shell --file ${PWD}/cypher/refactor_rsvp.cql

# ./${NEO}/bin/neo4j-shell --file cypher/refactor_membership.cql
# ./${NEO}/bin/neo4j-shell --file cypher/refactor_topic_interest.cql
