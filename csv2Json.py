import csv
from collections import defaultdict
import json
import pandas

components = {
    # Denim: systems programming
    0: ['C', 'C++', 'Go', 'Rust'],
    # Pumpkin: object-oriented programming
    1: ['C#', 'Java', 'Kotlin', 'Objective-C', 'Swift', 'TypeScript'],
    # Slimy green: computing
    2: ['Julia', 'MATLAB', 'R'],
    # Middle purple: functional programming
    4: ['Clojure', 'Elixir', 'Erlang', 'F#', 'Haskell', 'Lisp', 'OCaml', 'Scala'],
    # Acid gold: dynamic
    8: ['Dart', 'JavaScript', 'Python', 'Ruby'],
    # Cerulean: scripting
    9: ['Bash', 'CoffeeScript', 'Groovy', 'Lua', 'Perl', 'PHP', 'PowerShell', 'Vim']
}

# File names
count_file_name = 'count.csv'
similarity_file_name = 'similarity.csv'
data_file_name = 'data.json'

# Map each language to its component
language_component = dict()
for i, languages in components.items():
    for language in languages:
        language_component[language] = i

# Map each language to its count
language_count = dict()
count_file = open(count_file_name, 'r')
for language, c in csv.reader(count_file):
    language_count[language] = float(c)

# Nodes
nodes = []
for language in language_count:
    nodes.append({'language': language, 'component': language_component[language], 'count': language_count[language]})

# Edges
similarity_dataframe = pandas.read_csv(similarity_file_name, index_col=0)
edges = defaultdict(dict)
for source in similarity_dataframe.columns:
    edges[source]
    for target, weight in similarity_dataframe[source].items():
        if source < target:
            edges[source][target] = weight

# Kruskal's algorithm strongly connects the graph
MST = defaultdict(dict)
forest = [{source} for source in edges]
enum = {list(source)[0]: i for i, source in enumerate(forest)}
for source, target, weight1 in sorted([(source, target, edges[source][target]) for source in edges for target in edges[source]], key = lambda x: x[2], reverse=True):
    if enum[source] != enum[target]:
        source, target = sorted([source, target], key = lambda x: len(forest[enum[x]]))
        for weight2 in list(forest[enum[source]]):
            forest[enum[source]].discard(weight2)
            forest[enum[target]].discard(weight2)
            enum[weight2] = enum[target]
            MST[source][target] = weight1

# Strong connections are in the minimum spanning tree
strong_connections = []
for source, target_value in MST.items():
    for target, weight in target_value.items():
        strong_connections.append({'source': source, 'target': target, 'weight': weight})
        del edges[source][target]

# Weak connections are edges without strong connections
weak_connections = []
for source, target_value in edges.items():
    for target, weight in target_value.items():
        weak_connections.append({'source': source, 'target': target, 'weight': weight})

# Dump the JSON
data_file = open(data_file_name, 'w')
json.dump({'nodes': nodes, 'strong_connections': strong_connections, 'weak_connections': weak_connections}, open(data_file_name, 'w'))

# Close the files
count_file.close()
data_file.close()