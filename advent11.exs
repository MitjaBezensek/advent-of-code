defmodule Advent11 do
    def follow_path(input) do
        moves = 
            input
                |> Enum.group_by(fn v -> v end)
                |> Enum.map(fn {el, list} -> %{String.to_atom(el) => Enum.count(list)} end)
                |> Enum.reduce(%{}, fn (el, acc) -> Enum.into(el, acc) end)
        north = moves.n - moves.s
        nw = moves.nw - moves.se
        ne = moves.ne - moves.sw
        north + nw + (ne - nw)
    end

    def follow_path2(input), do:
        Enum.to_list(30..Enum.count(input))
            |> Enum.map(fn length -> Enum.take(input, length) end)
            |> Enum.reduce(%{max_value: 0}, &get_length/2)
            |> Map.fetch!(:max_value)

    def get_length(el, %{max_value: m}), do: %{max_value: max(m, follow_path(el))}
end

input = File.read!("input11") |> String.trim |> String.split(",")
Advent11.follow_path(input) |> IO.inspect
Advent11.follow_path2(input) |> IO.inspect