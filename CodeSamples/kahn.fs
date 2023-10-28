open System.IO

let kahn graph n =
    let inverse = Array.zeroCreate n |> Array.map (fun _ -> HashSet<int>())
    for u in 0 .. n - 1 do
        for v in graph.[u] do
            inverse.[v].Add(u)
    let stack = [ for v in 0 .. n - 1 do if inverse.[v].Count = 0 then yield v ]
    let order = List<int>()
    while stack.Count > 0 do
        let u = List.head stack
        stack <- List.tail stack
        order <- List.append order [u]
        for v in graph.[u] do
            graph.[u] <- List.filter (fun x -> x <> v) graph.[u]
            inverse.[v].Remove(u)
            if inverse.[v].Count = 0 then
                stack <- List.append stack [v]
    if order.Count <> n then
        printfn "Cyclic graph"
    else
        printfn "%s" (String.concat " " (List.map string order))

let rec readGraph n graph =
    match n with
    | 0 -> graph
    | _ ->
        let line = Console.ReadLine()
        let u, v = line.Split([|' '|]) |> Array.map int
        graph.[u].Add(v)
        readGraph (n - 1) graph

[<EntryPoint>]
let main argv =
    use input_file = new StreamReader("input.txt")
    use output_file = new StreamWriter("output.txt")
    let t = input_file.ReadLine() |> int
    for _ in 1 .. t do
        let n = input_file.ReadLine() |> int
        let graph = Array.init n (fun _ -> HashSet<int>())
        let graph = readGraph n graph
        kahn graph n |> function
        | "Cyclic graph" -> output_file.WriteLine("Cyclic graph")
        | order -> output_file.WriteLine(order)
    0
