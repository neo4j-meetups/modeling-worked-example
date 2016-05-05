echo "Usage: sh render.sh [publish]"
GUIDES=../../../neo4j-guides
# git clone http://github.com/jexp/neo4j-guides $GUIDES

function render {
$GUIDES/run.sh index.adoc index.html +1 "$@"
$GUIDES/run.sh 01_similar_groups_by_topic.adoc 01_similar_groups_by_topic.html +1 "$@"
$GUIDES/run.sh 02_clusters.adoc 02_clusters.html +1 "$@"
$GUIDES/run.sh 03_my_similar_groups.adoc 03_my_similar_groups.html +1 "$@"
}

# -a env-training is a flag to enable full content, if you comment it out, the guides are rendered minimally e.g. for a presentation
if [ "$1" == "publish" ]; then
  URL=guides.neo4j.com/pydata
  render http://$URL -a csv-url=https://raw.githubusercontent.com/neo4j-meetups/modeling-worked-example/master/data/ -a env-training
  s3cmd put --recursive -P *.html img s3://${URL}/
  s3cmd put -P index.html s3://${URL}

  echo "Publication Done"
else
  URL=localhost:8001
# copy the csv files to $NEO4J_HOME/import
  #render http://$URL -a csv-url=file:/// -a env-training
  render http://$URL -a csv-url=https://raw.githubusercontent.com/neo4j-meetups/modeling-worked-example/master/data/ -a env-training
  echo "Starting Websever at $URL Ctrl-c to stop"
  python $GUIDES/http.py
fi
