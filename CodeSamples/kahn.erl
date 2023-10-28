-module(kahn).
-export([main/0, kahn/2]).

kahn(Graph, N) ->
    Inverse = build_inverse_graph(Graph, N),
    Stack = [V || V <- lists:seq(0, N-1), length(Inverse[V]) == 0],
    kahn(Graph, Inverse, Stack, []).

kahn(_, _, [], Order) when length(Order) == length(?GRAPH) -> lists:reverse(Order);
kahn(_, _, [], _) -> "Cyclic graph";
kahn(Graph, Inverse, [U | Stack], Order) ->
    kahn(remove_dependencies(U, Graph, Inverse), Inverse, Stack, [U | Order]).

build_inverse_graph(Graph, N) ->
    build_inverse_graph(Graph, N, dict:new()).

build_inverse_graph([], _, Inverse) -> Inverse;
build_inverse_graph([{U, Vs} | Rest], N, Inverse) ->
    NewInverse = lists:foldl(fun(V, Inv) -> dict:append(V, [U | dict:fetch(V, Inv, [])], Inv) end, Inverse, Vs),
    build_inverse_graph(Rest, N, NewInverse).

remove_dependencies(U, Graph, Inverse) ->
    {NewGraph, NewInverse} = remove_dependencies(U, Graph, Inverse, []),
    NewGraph.

remove_dependencies(_, [], Inverse, NewInverse) -> {NewInverse, NewInverse};
remove_dependencies(U, [{U, Vs} | Rest], Inverse, NewInverse) ->
    remove_dependencies(U, Rest, Inverse, NewInverse);
remove_dependencies(U, [{V, Vs} | Rest], Inverse, NewInverse) ->
    NewVs = lists:filter(fun(X) -> X /= U end, Vs),
    if
        length(NewVs) == 0 ->
            remove_dependencies(U, Rest, Inverse, dict:erase(V, NewInverse));
        true ->
            remove_dependencies(U, Rest, Inverse, dict:store(V, NewVs, NewInverse))
    end.
  
main() ->
    {ok, InputFile} = file:open("input.txt", [read]),
    {ok, OutputFile} = file:open("output.txt", [write]),
    {ok, [T | Rest]} = io:get_line(InputFile, ''),
    T1 = list_to_integer(string:strip(T, right, $\n)),
    process_cases(InputFile, OutputFile, T1, Rest),
    file:close(InputFile),
    file:close(OutputFile).

process_cases(_, _, 0, _) -> ok;
process_cases(InputFile, OutputFile, T, Rest) ->
    {ok, [NLine | Rest1]} = io:get_line(InputFile, Rest),
    N = list_to_integer(string:strip(NLine, right, $\n)),
    Graph = read_graph(InputFile, N, []),
    Order = kahn:topological_sort(Graph, N),
    case Order of
        "Cyclic graph" ->
            io:format(OutputFile, "Cyclic graph~n", []),
            process_cases(InputFile, OutputFile, T-1, Rest1);
        _ ->
            io:format(OutputFile, "~s~n", [format_order(Order)]),
            process_cases(InputFile, OutputFile, T-1, Rest1)
    end.

format_order([]) -> "";
format_order([H]) -> integer_to_list(H);
format_order([H | T]) -> integer_to_list(H) ++ " " ++ format_order(T).

read_graph(_, 0, Acc) -> lists:reverse(Acc);
read_graph(InputFile, N, Acc) ->
    {ok, [EdgeLine | Rest]} = io:get_line(InputFile, ''),
    [U, V] = string:tokens(string:strip(EdgeLine, right, $\n), " "),
    read_graph(InputFile, N - 1, [{list_to_integer(U), list_to_integer(V)} | Acc]).