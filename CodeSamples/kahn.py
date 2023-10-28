import collections

def kahn(graph, n):
    inverse = collections.defaultdict(set)
    for u in graph:
        for v in graph[u]:
            inverse[v].add(u)
    stack = [v for v in range(n) if not inverse[v]]
    order = []
    while stack:
        u = stack.pop()
        order.append(u)
        for v in list(graph[u]):
            graph[u].remove(v)
            inverse[v].remove(u)
            if not inverse[v]:
                stack.append(v)
    if len(order) != n:
        return "Cyclic graph"
    return order

input_file = open('input.txt', 'r')
output_file = open('output.txt', 'w')
for _ in range(int(input_file.readline())):
    n = int(input_file.readline().strip())
    graph = collections.defaultdict(set)
    while True:
        line = input_file.readline().strip().split()
        if len(line):
            u, v = map(int, line)
            graph[u].add(v)
        else:
            output = kahn(graph, n)
            if output == 'Cyclic graph':
                output_file.write('Cyclic graph\n')
            else:
                output_file.write(' '.join(map(str, output)) + '\n')
            break
input_file.close()
output_file.close()