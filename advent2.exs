defmodule Advent2 do
  def checkSum(input, checksum_function) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn x -> String.split(x, "\t") end)
    |> Enum.map(checksum_function)
    |> Enum.reduce(fn a, b -> a + b end)
  end

  def get_min_max_checksum(row) do
    numbers = get_numbers(row)
    Enum.max(numbers) - Enum.min(numbers)
  end

  def get_divisible_checksum(row) do
    numbers = get_numbers(row)

    for x <- numbers,
        y <- numbers,
        x != y,
        rem(x, y) == 0 do
      div(x, y)
    end
    |> Enum.at(0)
  end

  defp get_numbers(row) do
    row
    |> Enum.map(fn x -> String.to_integer(x) end)
  end
end

{:ok, input} = File.read("input2")
input |> Advent2.checkSum(&Advent2.get_min_max_checksum/1) |> IO.inspect()
input |> Advent2.checkSum(&Advent2.get_divisible_checksum/1) |> IO.inspect()
