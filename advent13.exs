defmodule Advent13 do
    def part1(rows), do:
        parse(rows)
            |> Enum.filter(fn [level, range] -> is_caught?(level, range, 0) end)
            |> Enum.map(fn [level, range] -> level * range end)
            |> Enum.sum()
            |> IO.inspect

    def part2(rows), do: recurse(0, parse(rows)) |> IO.inspect

    def recurse(delay, rows) do
        case Enum.any?(rows, fn [level, range] -> is_caught?(level, range, delay) end) do
            true -> recurse(delay + 1, rows)
            false -> delay
        end
    end

    def is_caught?(level, range, delay), do: rem(delay + level, 2 * (range - 1)) == 0
    def parse(rows), do: 
        rows 
            |> Enum.map(fn [a, b] -> [String.to_integer(a), String.to_integer(b)] end) 
            |> Enum.sort(fn ([_, r1], [_, r2]) -> r1 < r2 end)
end

File.read!("input13") |> String.trim |> String.split("\n") |> Enum.map(fn row -> String.split(row, ": ") end) |> Advent13.part1
File.read!("input13") |> String.trim |> String.split("\n") |> Enum.map(fn row -> String.split(row, ": ") end) |> Advent13.part2