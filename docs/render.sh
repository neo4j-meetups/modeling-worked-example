GUIDES=../../neo4j-guides
# git clone http://github.com/jexp/neo4j-guides $GUIDES
BASE_URL=${1-http://localhost:8001}
$GUIDES/run.sh 01_similar_groups_by_topic.adoc 01_similar_groups_by_topic.html +1 $BASE_URL
$GUIDES/run.sh 02_recommend_me_similar_groups.adoc 02_recommend_me_similar_groups.html +1 $BASE_URL

python $GUIDES/http.py
