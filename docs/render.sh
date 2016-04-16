echo "Usage: sh render.sh [publish]"
GUIDES=../../neo4j-guides
# git clone http://github.com/jexp/neo4j-guides $GUIDES

function render {
BASE_URL=$1
$GUIDES/run.sh index.adoc index.html +1 $BASE_URL
$GUIDES/run.sh 01_similar_groups_by_topic.adoc 01_similar_groups_by_topic.html +1 $BASE_URL
$GUIDES/run.sh 02_my_similar_groups.adoc 02_my_similar_groups.html +1 $BASE_URL
$GUIDES/run.sh 03_my_interests.adoc 03_my_interests.html +1 $BASE_URL
$GUIDES/run.sh 04_events.adoc 04_events.html +1 $BASE_URL
$GUIDES/run.sh 05_venues.adoc 05_venues.html +1 $BASE_URL
$GUIDES/run.sh 05_venues_answers.adoc 05_venues_answers.html +1 $BASE_URL
$GUIDES/run.sh 06_rsvps.adoc 06_rsvps.html +1 $BASE_URL
$GUIDES/run.sh 07_procedures.adoc 07_procedures.html +1 $BASE_URL
$GUIDES/run.sh 08_layered_events.adoc 08_layered_events.html +1 $BASE_URL
$GUIDES/run.sh 09_free_for_all.adoc 09_free_for_all.html +1 $BASE_URL
}

if [ "$1" == "publish" ]; then
  URL=guides.neo4j.com/reco
  render http://$URL
  s3cmd put --recursive -P *.html img s3://${URL}/
  s3cmd put -P index.html s3://${URL}
  echo "Publication Done"
else
  URL=localhost:8001
  render http://$URL
  echo "Starting Websever at $URL Ctrl-c to stop"
  python $GUIDES/http.py
fi
