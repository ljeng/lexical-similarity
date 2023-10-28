fs = require('fs')

kahn = (graph, n) ->
  inverse = {}
  for u of graph
    for v in graph[u]
      inverse[v] ?= []
      inverse[v].push(u)

  stack = (v for v in [0...n] when not inverse[v]?)
  order = []

  while stack.length
    u = stack.pop()
    order.push(u)
    for v in (graph[u] ? [])
      graph[u].splice(graph[u].indexOf(v), 1)
      inverse[v].splice(inverse[v].indexOf(u), 1) if inverse[v]?
      stack.push(v) if not inverse[v]?

  if order.length isnt n
    return 'Cyclic graph'
  return order

inputData = fs.readFileSync('input.txt', 'utf8').split('\n')
t = parseInt(inputData[0])
output = ''

index = 1
for i in [0...t]
  n = parseInt(inputData[index])
  index++
  graph = {}
  while true
    line = inputData[index].split(' ')
    index++
    if line.length
      u = parseInt(line[0])
      v = parseInt(line[1])
      graph[u] ?= []
      graph[u].push(v)
    else
      result = kahn(graph, n)
      if result is 'Cyclic graph'
        output += 'Cyclic graph\n'
      else
        output += result.join(' ') + '\n'
      break

fs.writeFileSync('output.txt', output)
