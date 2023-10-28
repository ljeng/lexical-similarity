function kahn(graph, n)
    local inverse = {}
    for u, neighbors in pairs(graph) do
        for _, v in ipairs(neighbors) do
            inverse[v] = inverse[v] or {}
            table.insert(inverse[v], u)
        end
    end

    local stack = {}
    for v = 0, n - 1 do
        if not inverse[v] then
            table.insert(stack, v)
        end
    end

    local order = {}
    while #stack > 0 do
        local u = table.remove(stack, #stack)
        table.insert(order, u)
        local neighbors = graph[u] or {}
        local neighborList = {}
        for v in pairs(neighbors) do
            table.insert(neighborList, v)
        end
        for _, v in ipairs(neighborList) do
            graph[u][v] = nil
            inverse[v][u] = nil
            if not next(inverse[v]) then
                table.insert(stack, v)
            end
        end
    end

    if #order ~= n then
        return "Cyclic graph"
    end

    return order
end

local input_file = io.open("input.txt", "r")
local output_file = io.open("output.txt", "w")

local t = tonumber(input_file:read())
for i = 1, t do
    local n = tonumber(input_file:read())
    local graph = {}

    while true do
        local line = input_file:read()
        if not line then
            break
        end

        local u, v = line:match("(%S+)%s+(%S+)")
        u, v = tonumber(u), tonumber(v)

        if not graph[u] then
            graph[u] = {}
        end

        table.insert(graph[u], v)
    end

    local result = kahn(graph, n)
    if result == "Cyclic graph" then
        output_file:write("Cyclic graph\n")
    else
        output_file:write(table.concat(result, " ") .. "\n")
    end
end

input_file:close()
output_file:close()
