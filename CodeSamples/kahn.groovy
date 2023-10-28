def kahn(graph, n) {
    def inverse = [:].withDefault { [] }
    graph.each { u, vertices ->
        vertices.each { v ->
            inverse[v] << u
        }
    }

    def stack = (0..n - 1).findAll { !inverse[it] }
    def order = []

    while (stack) {
        def u = stack.pop()
        order << u
        graph[u].each { v ->
            graph[u] -= v
            inverse[v] -= u
            if (!inverse[v]) {
                stack << v
            }
        }
    }

    if (order.size() == n) {
        return order
    } else {
        return 'Cyclic graph'
    }
}

def input = new File('input.txt').text.readLines()
def t = input[0] as int
def data = input.tail()
def output = []

for (int i = 0; i < t; i++) {
    def n = data[0] as int
    data = data.tail()
    def graph = [:].withDefault { [] }

    while (!data[0].isEmpty()) {
        def parts = data[0].split(' ')*.toInteger()
        def u = parts[0]
        def v = parts[1]
        graph[u] << v
        data = data.tail()
    }

    data = data.tail()
    def result = kahn(graph, n)
    if (result == 'Cyclic graph') {
        output << 'Cyclic graph'
    } else {
        output << result.join(' ')
    }
}

new File('output.txt').text = output.join('\n')
