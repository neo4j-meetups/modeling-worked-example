from __future__ import unicode_literals
from neo4j.v1 import GraphDatabase, basic_auth
import os

username = os.environ.get("NEO4J_USERNAME", "neo4j")
password = os.environ.get("NEO4J_PASSWORD", "neo")

driver = GraphDatabase.driver("bolt://localhost", auth=basic_auth(username, password), encrypted=False)
session = driver.session()
query = """
    MATCH (n:Event)
    RETURN n
"""

result = session.run(query)

for row in result:
    props = row["n"].properties
    print(props)

session.close()
