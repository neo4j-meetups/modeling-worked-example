#!/bin/sh

NEO="neo4j-community-2.3.1"

./${NEO}/bin/neo4j-shell --file cypher/groups.cql
./${NEO}/bin/neo4j-shell --file cypher/topics.cql
./${NEO}/bin/neo4j-shell --file cypher/topics_groups.cql
./${NEO}/bin/neo4j-shell --file cypher/members.cql
./${NEO}/bin/neo4j-shell --file cypher/members_groups.cql
./${NEO}/bin/neo4j-shell --file cypher/members_topics.cql
./${NEO}/bin/neo4j-shell --file cypher/events.cql
./${NEO}/bin/neo4j-shell --file cypher/events_groups.cql
./${NEO}/bin/neo4j-shell --file cypher/rsvps.cql
./${NEO}/bin/neo4j-shell --file cypher/events_rsvps.cql
./${NEO}/bin/neo4j-shell --file cypher/refactor_membership.cql
