defmodule Advent1 do
  def sum(input, offset) do
    first_part = Enum.take(input, offset)
    second_part = Enum.drop(input, offset)
    shifted_input = second_part ++ first_part
    sum(input, shifted_input, 0)
  end

  defp sum([], _, sum), do: sum
  defp sum([a | rest], [a | rest2], sum), do: sum(rest, rest2, sum + a)
  defp sum([_ | rest], [_ | rest2], sum), do: sum(rest, rest2, sum)
end

{:ok, input} = File.read("input1")
input = input |> String.replace("\n", "") |> String.codepoints() |> Enum.map(&String.to_integer/1)
input |> Advent1.sum(1) |> IO.inspect()
half_length = round(length(input) / 2)
input |> Advent1.sum(half_length) |> IO.inspect()
