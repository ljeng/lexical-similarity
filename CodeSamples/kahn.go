package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
)

func kahn(graph map[int]map[int]struct{}, n int) interface{} {
    inverse := make(map[int]map[int]struct{})
    for u := range graph {
        for v := range graph[u] {
            if inverse[v] == nil {
                inverse[v] = make(map[int]struct{})
            }
            inverse[v][u] = struct{}{}
        }
    }

    stack := []int{}
    for v := 0; v < n; v++ {
        if len(inverse[v]) == 0 {
            stack = append(stack, v)
        }
    }

    order := []int{}

    for len(stack) > 0 {
        u := stack[len(stack)-1]
        stack = stack[:len(stack)-1]
        order = append(order, u)

        neighbors := make([]int, 0, len(graph[u]))
        for v := range graph[u] {
            neighbors = append(neighbors, v)
        }

        for _, v := range neighbors {
            delete(graph[u], v)
            delete(inverse[v], u)
            if len(inverse[v]) == 0 {
                stack = append(stack, v)
            }
        }
    }

    if len(order) != n {
        return "Cyclic graph"
    }

    return order
}

func main() {
    inputFile, _ := os.Open("input.txt")
    outputFile, _ := os.Create("output.txt")
    defer inputFile.Close()
    defer outputFile.Close()

    scanner := bufio.NewScanner(inputFile)

    scanner.Scan()
    t, _ := strconv.Atoi(scanner.Text())

    for i := 0; i < t; i++ {
        scanner.Scan()
        n, _ := strconv.Atoi(scanner.Text())
        graph := make(map[int]map[int]struct{})

        for {
            scanner.Scan()
            line := scanner.Text()
            if len(line) > 0 {
                parts := strings.Split(line, " ")
                u, _ := strconv.Atoi(parts[0])
                v, _ := strconv
