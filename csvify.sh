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


#bad
# jq -r '.[] | [.id, .name, .joined, ([.topics[].id] | join(";"))] | @csv' data/members/18313232.json

# good
# jq -r '.[] | [.id, .name, .joined, ([.topics[].id | tostring] | join(";"))] | @csv' data/members/18313232.json
