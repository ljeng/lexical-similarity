import java.io.File

fun kahn(graph: Map<Int, Set<Int>>, n: Int): Any {
    val inverse = mutableMapOf<Int, MutableSet<Int>>()
    for ((u, neighbors) in graph) {
        for (v in neighbors) {
            inverse.computeIfAbsent(v) { mutableSetOf() }.add(u)
        }
    }

    val stack = (0 until n).filterNot { inverse.containsKey(it) }.toMutableList()
    val order = mutableListOf<Int>()

    while (stack.isNotEmpty()) {
        val u = stack.removeAt(stack.size - 1)
        order.add(u)
        val neighbors = graph[u] ?: emptySet()
        val neighborList = neighbors.toMutableList()
        for (v in neighborList) {
            graph[u] = (graph[u] ?: emptySet()) - v
            inverse[v] = (inverse[v] ?: emptySet()) - u
            if (inverse[v]?.isEmpty() == true) {
                stack.add(v)
            }
        }
    }

    if (order.size != n) {
        return "Cyclic graph"
    }

    return order
}

fun main() {
    val lines = File("input.txt").readLines()
    var inputIndex = 0
    val t = lines[inputIndex++].toInt()
    val output = StringBuilder()

    repeat(t) {
        val n = lines[inputIndex++].toInt()
        val graph = mutableMapOf<Int, MutableSet<Int>>()

        while (true) {
            val line = lines[inputIndex++].split(" ")
            if (line.isNotEmpty()) {
                val u = line[0].toInt()
                val v = line[1].toInt()
                graph.computeIfAbsent(u) { mutableSetOf() }.add(v)
            } else {
                val result = kahn(graph, n)
                if (result == "Cyclic graph") {
                    output.append("Cyclic graph\n")
                } else {
                    output.append(result.joinToString(" ") + "\n")
                }
                break
            }
        }
    }

    File("output.txt").writeText(output.toString())
}
