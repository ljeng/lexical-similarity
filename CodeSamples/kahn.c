#include <stdio.h>
#include <stdlib.h>

struct Node {
    int data;
    struct Node* next;
};

struct Graph {
    int V;
    struct Node** adj;
};

struct Node* createNode(int data) {
    struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
    newNode->data = data;
    newNode->next = NULL;
    return newNode;
}

struct Graph* createGraph(int V) {
    struct Graph* graph = (struct Graph*)malloc(sizeof(struct Graph));
    graph->V = V;
    graph->adj = (struct Node**)malloc(V * sizeof(struct Node*));
    for (int i = 0; i < V; i++) {
        graph->adj[i] = NULL;
    }
    return graph;
}

void addEdge(struct Graph* graph, int u, int v) {
    struct Node* newNode = createNode(v);
    newNode->next = graph->adj[u];
    graph->adj[u] = newNode;
}

void topologicalSort(struct Graph* graph, int n, int* order, int* index) {
    int* inDegree = (int*)malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) {
        inDegree[i] = 0;
    }

    for (int u = 0; u < n; u++) {
        struct Node* temp = graph->adj[u];
        while (temp != NULL) {
            inDegree[temp->data]++;
            temp = temp->next;
        }
    }

    for (int u = 0; u < n; u++) {
        if (inDegree[u] == 0) {
            order[(*index)++] = u;
        }
    }

    for (int u = 0; u < n; u++) {
        struct Node* temp = graph->adj[u];
        while (temp != NULL) {
            inDegree[temp->data]--;
            if (inDegree[temp->data] == 0) {
                order[(*index)++] = temp->data;
            }
            temp = temp->next;
        }
    }
}

int* kahn(struct Graph* graph, int n) {
    int index = 0;
    int* order = (int*)malloc(n * sizeof(int));
    topologicalSort(graph, n, order, &index);

    if (index != n) {
        free(order);
        return NULL;
    }

    return order;
}

int main() {
    FILE* input_file = fopen("input.txt", "r");
    FILE* output_file = fopen("output.txt", "w");

    int t;
    fscanf(input_file, "%d", &t);

    while (t--) {
        int n;
        fscanf(input_file, "%d", &n);
        struct Graph* graph = createGraph(n);

        while (1) {
            int u, v;
            if (fscanf(input_file, "%d %d", &u, &v) == 2) {
                addEdge(graph, u, v);
            } else {
                int* result = kahn(graph, n);
                if (result == NULL) {
                    fprintf(output_file, "Cyclic graph\n");
                } else {
                    for (int i = 0; i < n; i++) {
                        fprintf(output_file, "%d", result[i]);
                        if (i < n - 1) {
                            fprintf(output_file, " ");
                        }
                    }
                    fprintf(output_file, "\n");
                }
                break;
            }
        }
    }

    fclose(input_file);
    fclose(output_file);
    return 0;
}
