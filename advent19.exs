defmodule Advent19 do
  def follow(input) do
    input
    |> Enum.with_index(1)
    |> Enum.reduce(%{}, &parse_row/2)
    |> follow({1, 2}, {1, 0}, [], 0)
  end

  def follow(maze, pos, direction, result, count) do
    case Map.fetch(maze, pos) do
      {:ok, el} -> move(maze, el, pos, direction, result, count)
      :error -> %{part1: Enum.join(result), part2: count}
    end
  end

  def move(maze, el, {x, y}, {dx, dy}, result, count) when el == "|" or el == "-",
    do: follow(maze, {x + dx, y + dy}, {dx, dy}, result, count + 1)

  def move(maze, "+", {x, y}, {dx, dy} = direction, result, count) do
    case Map.fetch(maze, {x + dx, y + dy}) do
      :error -> find_turn(maze, {x, y}, direction, result, count)
      _el -> follow(maze, {x + dx, y + dy}, direction, result, count + 1)
    end
  end

  def move(maze, el, {x, y}, {dx, dy}, result, count),
    do: follow(maze, {x + dx, y + dy}, {dx, dy}, result ++ [el], count + 1)

  def find_turn(maze, {x, y}, {dx, dy}, result, count) do
    moves = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}] -- [{-dx, -dy}]

    {{dx, dy}, _} =
      moves
      |> Enum.map(fn {dx, dy} -> {{dx, dy}, Map.fetch(maze, {x + dx, y + dy})} end)
      |> Enum.reject(fn {_, el} -> el == :error end)
      |> List.first()

    follow(maze, {x + dx, y + dy}, {dx, dy}, result, count + 1)
  end

  def parse_row({r, row}, map) do
    r
    |> String.split("")
    |> Enum.with_index(1)
    |> Enum.reject(fn {el, _} -> el == " " || el == "" end)
    |> Enum.reduce(map, fn {el, col}, map -> Map.put(map, {row, col}, el) end)
  end
end

File.read!("input19") |> String.split("\n", trim: true) |> Advent19.follow() |> IO.inspect()