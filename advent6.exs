defmodule Advent6 do
  def calculate_cycles(list), do: calculate_cycles(list, [list], 0)

  def calculate_cycles(list, seen_states, count) do
    max = Enum.max(list)
    max_index = Enum.find_index(list, fn x -> x == max end)
    list = List.update_at(list, max_index, fn _ -> 0 end)
    list = update_list(list, rem(max_index + 1, Enum.count(list)), max)

    if Enum.member?(seen_states, list) do
      IO.inspect(count + 1)
      IO.inspect(Enum.find_index(seen_states, fn x -> x == list end) + 1)
    else
      calculate_cycles(list, [list | seen_states], count + 1)
    end
  end

  def update_list(list, _, 0), do: list

  def update_list(list, index, count) do
    list = List.update_at(list, index, &(&1 + 1))
    update_list(list, rem(index + 1, Enum.count(list)), count - 1)
  end
end

{:ok, input} = File.read("input6")

input |> String.trim() |> String.split("\t") |> Enum.map(&String.to_integer/1)
|> Advent6.calculate_cycles()
