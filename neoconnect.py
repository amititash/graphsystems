'''
Wrapper file that reads a line of text and calls
open IE to create a graph DB
'''

from neo4jrestclient.client import GraphDatabase, Node
from neo4jrestclient import client
import urllib
import json

# cucco is for text normalisation
from cucco import Cucco

cucco = Cucco()
db = GraphDatabase("http://localhost:7474", username="neo4j", password="")

tx = db.transaction(for_query=True)
 

normalizations = [
    'remove_extra_white_spaces',
    ('replace_punctuation', {'replacement': ' '}),
    'remove_stop_words',
    'replace_symbols',
]

if __name__ == "__main__":
    # Load the file that has the questions and strip away any white lines while doing so
    fname='input.txt'
    with open(fname) as f:
        content =  [l for l in f.readlines() if l.strip()]

# remove whitespace characters like `\n` at the end of each line
content = [x.strip() for x in content] 

'''

TBD

Relationship rules

1. Nodes only NNS and NNP (noun or noun phrase)
2. Relationships only single word verbs
3. Break down phrases to root noun through pos tagging - find the verb in the rel

'''



# normalise the content so it is parsed accurately
# content = [cucco.normalize(x) for x in content]


# For each line, send it to open ie for info extraction
 
 
    

for con in content:
    url = 'http://localhost:3001/gettriplets/?sentence='+urllib.parse.quote_plus(con)
    print(url)

    with urllib.request.urlopen(url) as u:
       # jsonRes = json.loads(u.read().decode())
       print(type(u))
       graph_result = json.loads(u.read())


       if graph_result != "err":
           
           koNodeName1 = str(graph_result[0]
           query = ("MERGE (:ko {"name":  koNodeName1 })")
           results = gdb.query(query)
           
           koNodeName2 = str(graph_result[2]
           query = ("MERGE (:ko {"name":  koNodeName2 })")
           results = gdb.query(query)

           relationship = str(graph_result[1]) if str(graph_result[1]) != "" else "IS_RELATED"


           print("making relationship "+graph_result[0]+"--"+graph_result[1]+"---"+graph_result[2])
           koNodeName1.relationships.create(relationship, koNodeName2)
           
    print("finished")