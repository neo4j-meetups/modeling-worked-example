import nltk
import itertools
import csv

from py2neo import authenticate, Graph
from BeautifulSoup import BeautifulSoup
from collections import Counter

def strip_html_tags(htmlTxt):
    if htmlTxt is None:
        return None
    else:
        return ''.join(BeautifulSoup(htmlTxt).findAll(text=True))

authenticate("localhost:7474", "neo4j", "medium")
graph = Graph()

events_query = """
MATCH (e:Event)
WHERE HAS(e.description)
RETURN e.id AS eventId, e.description AS description, e.name AS name
"""

events = {}
for row in graph.cypher.execute(events_query):
    events[row["eventId"]] = row["name"] + " " + row["description"]

topics_query = """
MATCH (topic:Topic)
RETURN topic.id AS topicId, topic.name AS topic
"""

rows = graph.cypher.execute(topics_query)
topics = [row["topic"] for row in rows]

topics_lookup = {}
for row in rows:
    topics_lookup[row["topic"]] = row["topicId"]

with open("data/events_topics.csv", "w") as events_topics_file:
    writer = csv.writer(events_topics_file, delimiter = ",")
    writer.writerow(["eventId", "topicId", "times"])

    for event_id, description in events.iteritems():
        description = strip_html_tags(description)
        sentences = nltk.sent_tokenize(description)

        matching_words = []
        for sentence in sentences:
            words = nltk.word_tokenize(sentence)
            matching_words.append([word for word in words if word in topics])

        counts = Counter(list(itertools.chain.from_iterable(matching_words)))
        for topic in counts:
            writer.writerow([event_id, topics_lookup.get(topic), counts[topic]])
            print event_id, topics_lookup.get(topic), counts[topic]
