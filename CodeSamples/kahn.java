import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

public class Kahn {
    public static Map<Integer, List<Integer>> kahn(Map<Integer, Set<Integer>> graph, int n) {
        Map<Integer, Set<Integer>> inverse = new HashMap<>();
        for (Map.Entry<Integer, Set<Integer>> entry : graph.entrySet()) {
            int u = entry.getKey();
            for (int v : entry.getValue()) {
                inverse.computeIfAbsent(v, k -> new HashSet<>()).add(u);
            }
        }

        List<Integer> stack = new ArrayList<>();
        for (int v = 0; v < n; v++) {
            if (!inverse.containsKey(v)) {
                stack.add(v);
            }
        }

        List<Integer> order = new ArrayList<>();
        while (!stack.isEmpty()) {
            int u = stack.remove(stack.size() - 1);
            order.add(u);
            List<Integer> neighbors = new ArrayList<>(graph.get(u));
            for (int v : neighbors) {
                graph.get(u).remove(v);
                inverse.get(v).remove(u);
                if (inverse.get(v).isEmpty()) {
                    stack.add(v);
                }
            }
        }

        if (order.size() != n) {
            return Collections.singletonMap(0, Collections.singletonList(0));
        }

        Map<Integer, List<Integer>> result = new TreeMap<>();
        for (int i = 0; i < order.size(); i++) {
            result.put(i, Collections.singletonList(order.get(i)));
        }
        return result;
    }

    public static void main(String[] args) throws IOException {
        BufferedReader input = new BufferedReader(new FileReader("input.txt"));
        PrintWriter output = new PrintWriter(new FileWriter("output.txt"));

        int t = Integer.parseInt(input.readLine().trim());
        while (t > 0) {
            int n = Integer.parseInt(input.readLine().trim());
            Map<Integer, Set<Integer>> graph = new HashMap<>();
            String line;
            while ((line = input.readLine()) != null && !line.isEmpty()) {
                String[] uv = line.split(" ");
                int u = Integer.parseInt(uv[0]);
                int v = Integer.parseInt(uv[1]);
                graph.computeIfAbsent(u, k -> new HashSet<>()).add(v);
            }

            Map<Integer, List<Integer>> result = kahn(graph, n);
            if (result.containsKey(0) && result.get(0).get(0) == 0) {
                output.println("Cyclic graph");
            } else {
                for (List<Integer> order
