use std::collections::{HashMap, HashSet};
use std::fs::File;
use std::io::{BufRead, BufReader, Write};

fn kahn(graph: &mut HashMap<i32, HashSet<i32>>, n: i32) -> Result<Vec<i32>, String> {
    let mut inverse: HashMap<i32, HashSet<i32>> = HashMap::new();
    for (u, neighbors) in graph.iter() {
        for &v in neighbors {
            inverse.entry(v).or_insert(HashSet::new()).insert(*u);
        }
    }

    let mut stack: Vec<i32> = (0..n).filter(|&v| !inverse.contains_key(&v)).collect();
    let mut order: Vec<i32> = Vec::new();

    while let Some(u) = stack.pop() {
        order.push(u);
        if let Some(neighbors) = graph.get(&u) {
            let neighbor_list: Vec<i32> = neighbors.iter().cloned().collect();
            for v in neighbor_list {
                graph.get_mut(&u).unwrap().remove(&v);
                inverse.get_mut(&v).unwrap().remove(&u);
                if inverse[&v].is_empty() {
                    stack.push(v);
                }
            }
        }
    }

    if order.len() != n as usize {
        return Err("Cyclic graph".to_string());
    }

    Ok(order)
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let file = File::open("input.txt")?;
    let reader = BufReader::new(file);
    let mut input_lines = reader.lines().map(|line| line.unwrap());

    let t: i32 = input_lines.next().unwrap().parse()?;
    let mut output = String::new();

    for _ in 0..t {
        let n: i32 = input_lines.next().unwrap().parse()?;
        let mut graph: HashMap<i32, HashSet<i32>> = HashMap::new();

        loop {
            let line = input_lines.next().unwrap();
            if line.is_empty() {
                break;
            }
            let values: Vec<i32> = line
                .split_whitespace()
                .map(|s| s.parse().unwrap())
                .collect();
            let u = values[0];
            let v = values[1];
            graph.entry(u).or_insert(HashSet::new()).insert(v);
        }

        match kahn(&mut graph, n) {
            Ok(result) => {
                output.push_str(&result.iter().map(|&x| x.to_string()).collect::<Vec<String>>().join(" "));
                output.push('\n');
            }
            Err(_) => output.push_str("Cyclic graph\n"),
        }
    }

    let mut output_file = File::create("output.txt")?;
    output_file.write_all(output.as_bytes())?;

    Ok(())
}
