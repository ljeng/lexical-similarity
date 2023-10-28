function kahn(graph, n)
    inverse = cell(1, n);
    for u = 1:n
        for i = 1:length(graph{u})
            v = graph{u}(i);
            inverse{v} = [inverse{v}, u];
        end
    end
    stack = [];
    for v = 1:n
        if isempty(inverse{v})
            stack = [stack, v];
        end
    end
    order = [];
    while ~isempty(stack)
        u = stack(end);
        stack(end) = [];
        order = [order, u];
        for i = 1:length(graph{u})
            v = graph{u}(i);
            graph{u}(i) = [];
            inverse{v}(inverse{v} == u) = [];
            if isempty(inverse{v})
                stack = [stack, v];
            end
        end
    end
    if length(order) ~= n
        disp('Cyclic graph');
    else
        disp(order);
    end
end

input_file = fopen('input.txt', 'r');
output_file = fopen('output.txt', 'w');
T = str2double(fgetl(input_file));
for t = 1:T
    n = str2double(fgetl(input_file));
    graph = cell(1, n);
    while true
        line = fgetl(input_file);
        if isempty(line)
            break;
        end
        [u, v] = strread(line, '%d %d');
        graph{u} = [graph{u}, v];
    end
    kahn(graph, n);
end
fclose(input_file);
fclose(output_file);
