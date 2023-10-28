using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

public class Program
{
    public static Dictionary<int, HashSet<int>> Kahn(Dictionary<int, HashSet<int>> graph, int n)
    {
        var inverse = new Dictionary<int, HashSet<int>>();
        foreach (var u in graph.Keys)
        {
            foreach (var v in graph[u])
            {
                if (!inverse.ContainsKey(v))
                    inverse[v] = new HashSet<int>();
                inverse[v].Add(u);
            }
        }

        var stack = Enumerable.Range(0, n).Where(v => !inverse.ContainsKey(v)).ToList();
        var order = new List<int>();

        while (stack.Any())
        {
            var u = stack[stack.Count - 1];
            stack.RemoveAt(stack.Count - 1);
            order.Add(u);

            var neighbors = graph.ContainsKey(u) ? graph[u].ToList() : new List<int>();
            foreach (var v in neighbors)
            {
                graph[u].Remove(v);
                inverse[v].Remove(u);
                if (!inverse[v].Any())
                    stack.Add(v);
            }
        }

        if (order.Count != n)
            throw new InvalidOperationException("Cyclic graph");

        return order.ToDictionary(key => key, _ => new HashSet<int>());
    }

    public static void Main(string[] args)
    {
        var inputLines = File.ReadAllLines("input.txt");
        var inputIndex = 0;
        var t = int.Parse(inputLines[inputIndex++]);
        var output = new List<string>();

        for (var i = 0; i < t; i++)
        {
            var n = int.Parse(inputLines[inputIndex++]);
            var graph = new Dictionary<int, HashSet<int>>();

            while (true)
            {
                var line = inputLines[inputIndex++];
                if (string.IsNullOrWhiteSpace(line))
                {
                    var result = Kahn(graph, n);
                    if (result.Count > 0)
                        output.Add(string.Join(" ", result.Keys));
                    else
                        output.Add("Cyclic graph");
                    break;
                }
                var uv = line.Split(' ').Select(int.Parse).ToArray();
                var u = uv[0];
                var v = uv[1];
                if (!graph.ContainsKey(u))
                    graph[u] = new HashSet<int>();
                graph[u].Add(v);
            }
        }

        File.WriteAllLines("output.txt", output);
    }
}
