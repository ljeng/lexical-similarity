import * as fs from 'fs';

function kahn(graph: Record<number, Set<number>>, n: number): number[] | string {
    const inverse: Record<number, Set<number>> = {};

    for (const u in graph) {
        for (const v of graph[u]) {
            inverse[v] = inverse[v] || new Set();
            inverse[v].add(parseInt(u));
        }
    }

    const stack: number[] = [];
    for (let v = 0; v < n; v++) {
        if (!inverse[v]) {
            stack.push(v);
        }
    }

    const order: number[] = [];
    while (stack.length > 0) {
        const u = stack.pop() as number;
        order.push(u);
        for (const v of Array.from(graph[u])) {
            graph[u].delete(v);
            inverse[v].delete(u);
            if (!inverse[v].size) {
                stack.push(v);
            }
        }
    }

    if (order.length !== n) {
        return 'Cyclic graph';
    }

    return order;
}

const input: string = fs.readFileSync('input.txt', 'utf-8');
const lines: string[] = input.trim().split('\n');

let index: number = 0;
const t: number = parseInt(lines[index++], 10);

let output: string = '';
for (let i = 0; i < t; i++) {
    const n: number = parseInt(lines[index++], 10);
    const graph: Record<number, Set<number>> = {};

    while (true) {
        const line: string = lines[index++];
        if (line) {
            const [u, v] = line.split(' ').map(Number);
            graph[u] = graph[u] || new Set();
            graph[u].add(v);
        } else {
            const result = kahn(graph, n);
            if (result === 'Cyclic graph') {
                output += 'Cyclic graph\n';
            } else {
                output += result.join(' ') + '\n';
            }
            break;
        }
    }
}

fs.writeFileSync('output.txt', output);
