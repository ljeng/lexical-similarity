defmodule Kahn do
  def kahn(graph, n) do
    inverse = MapSet.new()
    graph
    |> Map.to_list()
    |> Enum.map(fn {u, neighbors} ->
      Enum.each(neighbors, fn v ->
        inverse = MapSet.put(inverse, v, u)
      end)
    end)

    {stack, _} =
      0..(n - 1)
      |> Enum.reduce({[], inverse}, fn v, {stack, inverse} ->
        if MapSet.member?(inverse, v) do
          {stack, inverse}
        else
          {[v | stack], MapSet.delete(inverse, v)}
        end
      end)

    kahn([], graph, stack, [])
  end

  defp kahn([], _graph, [], order) do
    {order, :ok}
  end
  defp kahn(_graph, _inverse, [], _order) do
    {"Cyclic graph", :error}
  end
  defp kahn(graph, inverse, [u | stack], order) do
    {new_graph, new_inverse} =
      graph
      |> Enum.reduce({[], inverse}, fn {v, neighbors}, {new_graph, new_inverse} ->
        if v != u do
          {[{v, neighbors} | new_graph, MapSet.update(new_inverse, v, &MapSet.delete(&1, u))}
        else
          {new_graph, new_inverse}
        end
      end)

    new_stack =
      stack
      |> Enum.reduce([], fn v, stack ->
        if MapSet.member?(new_inverse, v) do
          stack
        else
          [v | stack]
        end
      end)

    kahn(new_graph, new_inverse, new_stack, [u | order])
  end
end

defmodule Main do
  def run do
    {:ok, input_file} = File.read("input.txt")
    {:ok, output_file} = File.open("output.txt", [:write])

    t = String.to_integer(Enum.at(IO.read(input_file, :all) |> String.split("\n"), 0))
    cases = Enum.drop(Enum.at(IO.read(input_file, :all) |> String.split("\n"), 1), 1)

    Enum.each(cases, fn n_str ->
      n = String.to_integer(n_str)
      {input_lines, _} = IO.stream(:stdio, :line)

      {graph, _} =
        Stream.unfold(input_lines, fn lines ->
          case Enum.take(lines, 1) do
            [line] ->
              {[{String.split(line, " ") |> Enum.map(&String.to_integer(&1))} | graph], lines}

            [] ->
              {[], []}
          end
        end)
        |> Enum.reverse()
        |> Enum.reduce(%{}, fn [{u, v} | rest], graph ->
          Map.update(graph, u, [%{v | graph[u]} | graph], &List.wrap(&1, v))
        end)

      case Kahn.kahn(graph, n) do
        {order, _} when length(order) == n ->
          IO.puts(output_file, Enum.join(order, " ") <> "\n")

        {"Cyclic graph", _} ->
          IO.puts(output_file, "Cyclic graph\n")
      end
    end)

    File.close(output_file)
    :ok
  end
end

Main.run()
