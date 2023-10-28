import Foundation

func kahn(_ graph: [Int: Set<Int>], _ n: Int) -> Any {
    var inverse = [Int: Set<Int>]()
    for u in graph {
        for v in u.value {
            if inverse[v] == nil {
                inverse[v] = Set()
            }
            inverse[v]!.insert(u.key)
        }
    }
    
    var stack = [Int]()
    for v in 0..<n where inverse[v] == nil {
        stack.append(v)
    }
    
    var order = [Int]()
    while !stack.isEmpty {
        let u = stack.removeLast()
        order.append(u)
        if let neighbors = graph[u] {
            for v in neighbors {
                graph[u]!.remove(v)
                inverse[v]!.remove(u)
                if inverse[v]!.isEmpty {
                    stack.append(v)
                }
            }
        }
    }
    
    if order.count != n {
        return "Cyclic graph"
    }
    return order
}

if let inputString = try? String(contentsOfFile: "input.txt") {
    let inputLines = inputString.components(separatedBy: "\n")
    var inputIndex = 0
    
    if let t = Int(inputLines[inputIndex]) {
        inputIndex += 1
        var output = ""
        for _ in 0..<t {
            if let n = Int(inputLines[inputIndex]) {
                inputIndex += 1
                var graph = [Int: Set<Int>]()
                while inputIndex < inputLines.count {
                    let line = inputLines[inputIndex].split(separator: " ")
                    inputIndex += 1
                    if line.count == 2, let u = Int(line[0]), let v = Int(line[1]) {
                        if graph[u] == nil {
                            graph[u] = Set()
                        }
                        graph[u]!.insert(v)
                    } else {
                        let result = kahn(graph, n)
                        if let resultArray = result as? [Int] {
                            output += resultArray.map { String($0) }.joined(separator: " ") + "\n"
                        } else {
                            output += "Cyclic graph\n"
                        }
                        break
                    }
                }
            }
        }
        try? output.write(toFile: "output.txt", atomically: false, encoding: .utf8)
    }
}
