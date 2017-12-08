defmodule Advent5 do
    def calculate_jumps(offsets, update_fn), do: calculate_jumps(offsets, 0, 0, update_fn)

    def calculate_jumps( _, count, current_index, _) when current_index < 0, do: count
    def calculate_jumps(offsets, count, current_index, update_fn) do
        if(current_index > Enum.count(offsets) - 1) do
            count
        else
            current_offset = Enum.at(offsets, current_index)
            updated_offsets = List.update_at(offsets, current_index, update_fn)
            calculate_jumps(updated_offsets, count + 1, current_index + current_offset, update_fn)
        end
    end

    def increase_by_one(value), do: value + 1
    def strange_update(value) when value >= 3, do: value - 1
    def strange_update(value), do: value + 1
end

{:ok, input} = File.read("input5")
input |> String.trim |> String.split("\n") |> Enum.map(&String.to_integer/1) |> Advent5.calculate_jumps(&Advent5.increase_by_one/1) |> IO.inspect
input |> String.trim |> String.split("\n") |> Enum.map(&String.to_integer/1) |> Advent5.calculate_jumps(&Advent5.strange_update/1) |> IO.inspect