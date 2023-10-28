require 'set'

def kahn(graph, n)
  inverse = Hash.new { |hash, key| hash[key] = Set.new }
  graph.each do |u, neighbors|
    neighbors.each { |v| inverse[v].add(u) }
  end

  stack = (0...n).select { |v| inverse[v].empty? }
  order = []

  until stack.empty?
    u = stack.pop
    order.push(u)
    graph[u].to_a.each do |v|
      graph[u].delete(v)
      inverse[v].delete(u)
      stack.push(v) if inverse[v].empty?
    end
  end

  return 'Cyclic graph' if order.length != n
  order
end

input_file = File.open('input.txt', 'r')
output_file = File.open('output.txt', 'w')

t = input_file.readline.to_i
t.times do
  n = input_file.readline.to_i
  graph = Hash.new { |hash, key| hash[key] = Set.new }

  loop do
    line = input_file.readline.strip.split
    if line.any?
      u, v = line.map(&:to_i)
      graph[u].add(v)
    else
      output = kahn(graph, n)
      if output == 'Cyclic graph'
        output_file.puts 'Cyclic graph'
      else
        output_file.puts output.join(' ')
      end
      break
    end
  end
end

input_file.close
output_file.close
