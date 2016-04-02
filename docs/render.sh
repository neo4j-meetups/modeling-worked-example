GUIDES=../../neo4j-guides
# git clone http://github.com/jexp/neo4j-guides $GUIDES
BASE_URL=${1-http://localhost:8001}
$GUIDES/run.sh 01_groups_by_topics.adoc 01_groups_by_topics.html +1 $BASE_URL

python $GUIDES/http.py
