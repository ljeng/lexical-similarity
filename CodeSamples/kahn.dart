import 'dart:collection';

kahn(List<List<int>> graph, int n) {
  Map<int, Set<int>> inverse = {};
  for (var u in graph) {
    for (var v in u) {
      inverse[v] ??= {};
      inverse[v].add(u);
    }
  }

  List<int> stack = [];
  for (var i = 0; i < n; i++) {
    if (!inverse.containsKey(i)) {
      stack.add(i);
    }
  }

  List<int> order = [];
  while (stack.isNotEmpty) {
    var u = stack.removeLast();
    order.add(u);

    for (var v in graph[u]) {
      graph[u].remove(v);
      inverse[v].remove(u);

      if (inverse[v].isEmpty) {
        stack.add(v);
      }
    }
  }

  if (order.length != n) {
    return "Cyclic graph";
  }

  return order;
}

void main() {
  var inputFile = File('input.txt');
  var outputFile = File('output.txt');

  var lines = inputFile.readAsLinesSync();
  var n = int.parse(lines[0]);

  var graph = List.filled(n, []);
  for (var i = 1; i < lines.length; i++) {
    var line = lines[i].split(' ');
    if (line.isNotEmpty) {
      var u = int.parse(line[0]);
      var v = int.parse(line[1]);
      graph[u].add(v);
    }
  }

  var order = kahn(graph, n);
  if (order is String) {
    outputFile.writeAsStringSync('Cyclic graph\n');
  } else {
    outputFile.writeAsStringSync(order.join(' ') + '\n');
  }
}
