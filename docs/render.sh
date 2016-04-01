GUIDES=../../neo4j-guides
# git clone http://github.com/jexp/neo4j-guides $GUIDES

$GUIDES/run.sh 01_groups_by_topics.adoc 01_groups_by_topics.html +1 http://localhost:8001

python $GUIDES/http.py
