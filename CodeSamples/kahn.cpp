#include <iostream>
#include <fstream>
#include <vector>
#include <map>
#include <set>

std::map<int, std::vector<int>> kahn(std::map<int, std::set<int>>& graph, int n) {
    std::map<int, std::set<int>> inverse;
    for (const auto& u : graph) {
        for (int v : u.second) {
            inverse[v].insert(u.first);
        }
    }

    std::vector<int> stack;
    for (int v = 0; v < n; v++) {
        if (inverse[v].empty()) {
            stack.push_back(v);
        }
    }

    std::vector<int> order;
    while (!stack.empty()) {
        int u = stack.back();
        stack.pop_back();
        order.push_back(u);
        std::vector<int> neighbors(graph[u].begin(), graph[u].end());
        for (int v : neighbors) {
            graph[u].erase(v);
            inverse[v].erase(u);
            if (inverse[v].empty()) {
                stack.push_back(v);
            }
        }
    }

    if (order.size() != n) {
        return {{0, {0}}};
    }

    std::map<int, std::vector<int>> result;
    for (int i = 0; i < n; i++) {
        result[i] = {order[i]};
    }
    return result;
}

int main() {
    std::ifstream input_file("input.txt");
    std::ofstream output_file("output.txt");

    int t;
    input_file >> t;
    while (t--) {
        int n;
        input_file >> n;
        std::map<int, std::set<int>> graph;

        while (true) {
            int u, v;
            if (input_file >> u >> v) {
                graph[u].insert(v);
            } else {
                auto result = kahn(graph, n);
                if (result.begin()->second[0] == 0) {
                    output_file << "Cyclic graph" << std::endl;
                } else {
                    for (const auto& entry : result) {
                        for (int i = 0; i < entry.second.size(); i++) {
                            output_file << entry.second[i];
                            if (i < entry.second.size() - 1) {
                                output_file << " ";
                            }
                        }
                        output_file << std::endl;
                    }
                }
                break;
            }
        }
    }

    input_file.close();
    output_file.close();

    return 0;
}
