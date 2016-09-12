#!/bin/sh

echo "id,name,urlname,link,rating,created,description,organiserName,organiserMemberId" > data/groups.csv
jq -r '.[] | [.id, .name, .urlname, .link, .rating, .created, .description, .organizer.name, .organizer.member_id] | @csv' data/groups.json >> data/groups.csv

echo "groupId,name,id,urlkey" > data/groups_topics.csv
jq -r '.[] |
       {id: .id, topics:  (.topics[] // [])} |
       [.id, .topics.name, .topics.id, .topics.urlkey] |
       @csv' data/groups.json >> data/groups_topics.csv

# find data/members -type f | xargs -I {} jq -r '.[] | [.id, .name, .joined, ([.topics[].id | tostring] | join(";")), $({})] | @csv' {}

echo "id,name,joined,topics,groupId" > data/members.csv
for file in `find data/members -type f`
do
  group_id=`echo $file | awk -F"/" '{print $3}' | sed 's/\.json//'`
  jq --arg group_id "$group_id" -r '.[] | [.id, .name, .joined, ([.topics[].id | tostring] | join(";")),$group_id] | @csv' ${file} >> data/members.csv
  echo $group_id " is done"
done

echo "id,name,city,address_1,address_2,lat,lon" > data/venues.csv
for file in `find data/events -type f`
do
  jq -r ".[] | select(.venue != null) | .venue | [.id, .name, .city, .address_1, .address_2, .lat, .lon] | @csv" $file | sort | uniq >> data/venues.csv
done

echo "id,name,time,utc_offset,group_id,venue_id,status,description" > data/events.csv
for file in `find data/events -type f`
do
  jq -r ".[] | [.id, .name, .time, .utc_offset, .group.id, .venue.id, .status, .description] | @csv" $file >> data/events.csv
done

echo "rsvp_id,event_id,member_id,guests,response,created,mtime" > data/rsvps.csv
for file in `find data/rsvps -type f`
do
  jq -r '.[] | [.rsvp_id, .event.id, .member.member_id, .guests, .response, .created, .mtime] | @csv' $file >> data/rsvps.csv
done

#bad
# jq -r '.[] | [.id, .name, .joined, ([.topics[].id] | join(";"))] | @csv' data/members/18313232.json

# good
# jq -r '.[] | [.id, .name, .joined, ([.topics[].id | tostring] | join(";"))] | @csv' data/members/18313232.json
