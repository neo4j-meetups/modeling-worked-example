from collections import defaultdict
import csv
from py2neo import authenticate, Graph

authenticate("localhost:7474", "neo4j", "medium")
graph = Graph()

events = {}
for row in graph.cypher.execute(
    """
    MATCH (e:Event) WHERE HAS(e.description)
    RETURN e.id AS eventId, e.description AS description
    """):
    events[row["eventId"]] = row["description"]

corpus = []
for id, event in sorted(events.iteritems(), key=lambda t: t[0]):
    corpus.append(event)

from sklearn.feature_extraction.text import TfidfVectorizer
tf = TfidfVectorizer(analyzer='word', ngram_range=(1,3), min_df = 0, stop_words = 'english')

tfidf_matrix =  tf.fit_transform(corpus)
feature_names = tf.get_feature_names()

with open("data/tfidf_scikit.csv", "w") as file:
    writer = csv.writer(file, delimiter=",")
    writer.writerow(["EventId", "Phrase", "Score"])
    doc_id = 0
    for doc in tfidf_matrix.todense():
        print "Document %d" %(doc_id)
        word_id = 0
        for score in doc.tolist()[0]:
            if score > 0:
                word = feature_names[word_id]
                writer.writerow([doc_id+1, word.encode("utf-8"), score])
            word_id +=1
        doc_id +=1
