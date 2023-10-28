import scala.io.Source
import java.io.PrintWriter

def kahn(graph: Map[Int, Set[Int]], n: Int): Any = {
  var inverse: Map[Int, Set[Int]] = Map()
  for ((u, neighbors) <- graph; v <- neighbors) {
    inverse += (v -> (inverse.getOrElse(v, Set()) + u))
  }

  var stack: List[Int] = (0 until n).filterNot(inverse.contains).toList
  var order: List[Int] = List()

  while (stack.nonEmpty) {
    val u = stack.head
    stack = stack.tail
    order :+= u
    graph.get(u) match {
      case Some(neighbors) =>
        for (v <- neighbors.toList) {
          graph += (u -> (graph(u) - v))
          inverse += (v -> (inverse(v) - u))
          if (inverse(v).isEmpty) {
            stack :+= v
          }
        }
      case None =>
    }
  }

  if (order.length != n) {
    return "Cyclic graph"
  }

  order
}

val inputLines = Source.fromFile("input.txt").getLines.toList
var inputIndex = 0

val t = inputLines(inputIndex).toInt
inputIndex += 1
var output = ""

for (_ <- 1 to t) {
  val n = inputLines(inputIndex).toInt
  inputIndex += 1
  var graph = Map[Int, Set[Int]]()

  while (true) {
    val line = inputLines(inputIndex).split(" ").map(_.toInt)
    inputIndex += 1

    if (line.length > 1) {
      val u = line(0)
      val v = line(1)
      graph += (u -> (graph.getOrElse(u, Set()) + v))
    } else {
      val result = kahn(graph, n)
      if (result == "Cyclic graph") {
        output += "Cyclic graph\n"
      } else {
        output += result.mkString(" ") + "\n"
      }
    }
  }
}

val writer = new PrintWriter("output.txt")
writer.write(output)
writer.close()
