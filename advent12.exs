defmodule Advent12 do
  def paths(rows), do: parse_connections(rows) |> find_connected_nodes(["0"], []) |> Enum.count()

  def parse_connections(rows), do: rows |> Enum.reduce(%{}, &parse_row/2)

  def parse_row(row, map) do
    [id, connections] = String.split(row, " <-> ")
    conn_list = String.split(connections, ",") |> Enum.map(&String.trim/1)
    map = Map.update(map, id, conn_list, fn list -> conn_list ++ list end)
    conn_list |> Enum.reduce(map, fn el, m -> add_path_for_element(m, el, id) end)
  end

  def add_path_for_element(map, id, el), do: Map.update(map, id, [el], fn list -> [el | list] end)

  def find_connected_nodes(_, [], result), do: result

  def find_connected_nodes(connections, [first | rest], result) do
    result = List.flatten([first, result])
    conn = Map.fetch!(connections, first) |> Enum.filter(fn el -> !Enum.member?(result, el) end)
    find_connected_nodes(connections, Enum.uniq(rest ++ conn), result)
  end

  def groups(rows) do
    connections = parse_connections(rows)
    count_groups(0, connections |> Map.keys(), connections)
  end

  def count_groups(n, [], _), do: n

  def count_groups(n, list, connections) do
    [node | _] = list
    group = find_connected_nodes(connections, [node], [])
    count_groups(n + 1, list -- group, connections)
  end
end

File.read!("input12") |> String.trim() |> String.split("\n") |> Advent12.paths() |> IO.inspect()
File.read!("input12") |> String.trim() |> String.split("\n") |> Advent12.groups() |> IO.inspect()
