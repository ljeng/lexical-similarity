const fs = require('fs');
const readline = require('readline');

function kahn(graph, n) {
    const inverse = new Map();
    for (const u in graph) {
        for (const v of graph[u]) {
            if (!inverse.has(v)) {
                inverse.set(v, new Set());
            }
            inverse.get(v).add(parseInt(u));
        }
    }

    const stack = [...Array(n).keys()].filter(v => !inverse.has(v));
    const order = [];

    while (stack.length > 0) {
        const u = stack.pop();
        order.push(u);
        for (const v of [...graph[u]]) {
            graph[u].delete(v);
            inverse.get(v).delete(u);
            if (inverse.get(v).size === 0) {
                stack.push(v);
            }
        }
    }

    if (order.length !== n) {
        return 'Cyclic graph';
    }

    return order;
}

const rl = readline.createInterface({
    input: fs.createReadStream('input.txt'),
    output: fs.createWriteStream('output.txt'),
    terminal: false
});

let t = -1;
let n, graph;

rl.on('line', line => {
    if (t === -1) {
        t = parseInt(line);
    } else if (n === undefined) {
        n = parseInt(line);
        graph = new Map();
    } else {
        const parts = line.split(' ');
        if (parts.length > 1) {
            const u = parseInt(parts[0]);
            const v = parseInt(parts[1]);
            if (!graph.has(u)) {
                graph.set(u, new Set());
            }
            graph.get(u).add(v);
        } else {
            const output = kahn(graph, n);
            if (output === 'Cyclic graph') {
                rl.output.write('Cyclic graph\n');
            } else {
                rl.output.write(output.join(' ') + '\n');
            }
            n = undefined;
            graph = undefined;
            t--;
        }
    }
});
