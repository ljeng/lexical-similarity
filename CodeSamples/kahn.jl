function kahn(graph, n)
    inverse = Vector{Vector{Int}}(undef, n)
    fill!(inverse, [])
    for u in 1:n
        for v in graph[u]
            push!(inverse[v], u)
        end
    end
    stack = Int[]
    for v in 1:n
        if isempty(inverse[v])
            push!(stack, v)
        end
    end
    order = Int[]
    while !isempty(stack)
        u = pop!(stack)
        push!(order, u)
        for v in graph[u]
            deleteat!(graph[u], findfirst(isequal(v), graph[u]))
            deleteat!(inverse[v], findfirst(isequal(u), inverse[v]))
            if isempty(inverse[v])
                push!(stack, v)
            end
        end
    end
    if length(order) != n
        println("Cyclic graph")
    else
        println(join(order, " "))
    end
end

input_file = open("input.txt", "r")
output_file = open("output.txt", "w")
T = parse(Int, readline(input_file))
for t in 1:T
    n = parse(Int, readline(input_file))
    graph = Vector{Vector{Int}}(undef, n)
    fill!(graph, Int[])
    while true
        line = readline(input_file)
        if isempty(line)
            break
        end
        u, v = parse.(Int, split(line))
        push!(graph[u], v)
    end
    kahn(graph, n)
end
close(input_file)
close(output_file)
